import 'dart:async';

import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/cors/services/socket_service.dart';
import 'package:abbas/cors/services/token_storage.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/message/model/chat_message_model.dart';
import 'package:abbas/presentation/views/message/model/conversation_model.dart';
import 'package:abbas/presentation/views/message/provider/conversations_provider.dart';
import 'package:abbas/presentation/views/message/model/chat_send_payload.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path/path.dart' as p;

class ChatState {
  final List<ChatMessage> messages;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool isSending;
  final bool isOtherUserTyping;
  final String? error;
  final String? nextCursor;
  final bool hasMore;
  final String? currentUserId;
  final String? typingUserName;

  const ChatState({
    this.messages = const [],
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.isSending = false,
    this.isOtherUserTyping = false,
    this.error,
    this.nextCursor,
    this.hasMore = true,
    this.currentUserId,
    this.typingUserName,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? isSending,
    bool? isOtherUserTyping,
    String? error,
    bool clearError = false,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? hasMore,
    String? currentUserId,
    String? typingUserName,
    bool clearTypingUserName = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSending: isSending ?? this.isSending,
      isOtherUserTyping: isOtherUserTyping ?? this.isOtherUserTyping,
      error: clearError ? null : (error ?? this.error),
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      hasMore: hasMore ?? this.hasMore,
      currentUserId: currentUserId ?? this.currentUserId,
      typingUserName:
          clearTypingUserName ? null : (typingUserName ?? this.typingUserName),
    );
  }
}

class ChatArgs {
  final String conversationId;
  final ConversationType type;
  final String title;
  final String? avatarUrl;

  const ChatArgs({
    required this.conversationId,
    required this.type,
    required this.title,
    this.avatarUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatArgs &&
          conversationId == other.conversationId &&
          type == other.type &&
          title == other.title &&
          avatarUrl == other.avatarUrl;

  @override
  int get hashCode => Object.hash(conversationId, type, title, avatarUrl);
}

final chatProvider =
    StateNotifierProvider.autoDispose.family<ChatNotifier, ChatState, ChatArgs>(
  (ref, args) => ChatNotifier(
    ref: ref,
    args: args,
    dioClient: DioClient(),
    socketService: SocketService(),
  ),
);

class ChatNotifier extends StateNotifier<ChatState> {
  final Ref ref;
  final ChatArgs args;
  final DioClient dioClient;
  final SocketService socketService;

  Timer? _typingDebounce;
  Timer? _typingHideTimer;
  String? _lastMarkedReadId;
  bool _messagesLoaded = false;

  void Function(dynamic)? _onNewMessage;
  void Function(dynamic)? _onMessageStatus;
  void Function(dynamic)? _onTyping;

  ChatNotifier({
    required this.ref,
    required this.args,
    required this.dioClient,
    required this.socketService,
  }) : super(const ChatState());

  Future<void> reload() async {
    state = state.copyWith(isInitialLoading: true, clearError: true);
    await _fetchMessages(cursor: null, append: false);
    state = state.copyWith(isInitialLoading: false);
  }

  Future<void> init(String currentUserId) async {
    state = state.copyWith(
      currentUserId: currentUserId,
      clearError: true,
    );

    await _activateRealtime();

    if (_messagesLoaded) return;

    state = state.copyWith(isInitialLoading: true);
    await _fetchMessages(cursor: null, append: false);
    await _markLatestIncomingRead();
    state = state.copyWith(isInitialLoading: false);
    _messagesLoaded = true;
    ref.read(conversationsProvider.notifier).clearUnread(args.conversationId);
  }

  Future<void> _activateRealtime() async {
    final token = await TokenStorage().getToken();
    if (token == null || token.isEmpty) return;

    logger.i('[Chat] Activating realtime for ${args.conversationId}');
    socketService.connect(token);
    socketService.joinConversation(args.conversationId);
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    if (_onNewMessage != null) {
      socketService.removeNewMessageListener(_onNewMessage!);
    }
    if (_onMessageStatus != null) {
      socketService.removeMessageStatusListener(_onMessageStatus!);
    }
    if (_onTyping != null) {
      socketService.removeTypingListener(_onTyping!);
    }

    _onNewMessage = (data) {
      try {
        final conversationId =
            ChatMessage.conversationIdFromSocket(data) ?? args.conversationId;
        if (conversationId != args.conversationId) return;

        final message = ChatMessage.fromSocket(data);
        if (message.id.isEmpty) return;

        _insertOrReplace(message);
        _sortMessagesDesc();

        ref.read(conversationsProvider.notifier).updateConversationPreview(
              conversationId: args.conversationId,
              lastMessage: ConversationLastMessage(
                id: message.id,
                kind: message.kind,
                content: message.content,
                createdAt: message.createdAt,
                sender: message.sender != null
                    ? ConversationParticipant(
                        id: message.sender!.id,
                        name: message.sender!.name,
                        avatar: message.sender!.avatar,
                      )
                    : null,
                isMe: message.isMine(state.currentUserId),
              ),
            );

        if (!message.isMine(state.currentUserId)) {
          _markLatestIncomingRead();
        }

        state = state.copyWith(messages: List.of(state.messages));
      } catch (e, st) {
        logger.e('message:new parse error: $e\n$st');
      }
    };

    _onMessageStatus = (data) {
      try {
        final map = Map<String, dynamic>.from(data as Map);
        final convId =
            map['conversation_id']?.toString() ?? map['conversationId']?.toString();
        if (convId != null &&
            convId.isNotEmpty &&
            convId != args.conversationId) {
          return;
        }

        final ids = (map['message_ids'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            const [];
        final status = DeliveryStatus.fromApi(map['status']?.toString());

        final updated = [
          for (final msg in state.messages)
            if (ids.contains(msg.id)) msg.copyWith(status: status) else msg,
        ];
        state = state.copyWith(messages: updated);
      } catch (e) {
        logger.e('message:status parse error: $e');
      }
    };

    _onTyping = (data) {
      try {
        final map = Map<String, dynamic>.from(data as Map);
        final convId =
            map['conversation_id']?.toString() ?? map['conversationId']?.toString();
        if (convId != null &&
            convId.isNotEmpty &&
            convId != args.conversationId) {
          return;
        }

        final userId =
            map['user_id']?.toString() ?? map['userId']?.toString();
        final on = map['on'] == true;
        if (userId == null || userId == state.currentUserId) return;

        _typingHideTimer?.cancel();
        if (on) {
          state = state.copyWith(
            isOtherUserTyping: true,
            typingUserName:
                map['user_name']?.toString() ?? map['userName']?.toString(),
          );
          _typingHideTimer = Timer(const Duration(seconds: 4), () {
            state = state.copyWith(
              isOtherUserTyping: false,
              clearTypingUserName: true,
            );
          });
        } else {
          state = state.copyWith(
            isOtherUserTyping: false,
            clearTypingUserName: true,
          );
        }
      } catch (e) {
        logger.e('typing parse error: $e');
      }
    };

    socketService.addNewMessageListener(_onNewMessage!);
    socketService.addMessageStatusListener(_onMessageStatus!);
    socketService.addTypingListener(_onTyping!);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.nextCursor == null) {
      return;
    }
    state = state.copyWith(isLoadingMore: true);
    await _fetchMessages(cursor: state.nextCursor, append: true);
    state = state.copyWith(isLoadingMore: false);
  }

  Future<void> _fetchMessages({
    required String? cursor,
    required bool append,
  }) async {
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.conversationMessages(
          args.conversationId,
          limit: 20,
          cursor: cursor,
        ),
      );

      if (res is ResponseModel) {
        state = state.copyWith(error: res.message);
        return;
      }

      if (res == null) {
        state = state.copyWith(error: 'Failed to load messages');
        return;
      }

      if (res is Map && res['success'] == true) {
        final model = MessagesResponse.fromJson(
          Map<String, dynamic>.from(res),
        );

        final merged = append
            ? [...state.messages, ...model.data]
            : model.data;

        final unique = <String, ChatMessage>{};
        for (final msg in merged) {
          if (msg.id.isNotEmpty) unique[msg.id] = msg;
        }

        final list = unique.values.toList();
        _sortListDesc(list);

        state = state.copyWith(
          messages: list,
          nextCursor: model.meta?.nextCursor,
          clearNextCursor: model.meta?.nextCursor == null,
          hasMore: model.meta?.nextCursor != null,
          clearError: true,
        );
        logger.i(
          '[Chat] Loaded ${list.length} messages for ${args.conversationId}',
        );
      } else {
        logger.e('[Chat] Fetch messages failed: $res');
        state = state.copyWith(
          error: res is Map
              ? (res['message']?.toString() ?? 'Failed to load messages')
              : 'Failed to load messages',
        );
      }
    } catch (e) {
      logger.e('Fetch messages error: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> sendText(String text) async {
    await sendMessage(ChatSendPayload(
      text: text,
      kind: MessageKind.text,
    ));
  }

  Future<void> sendMessage(ChatSendPayload payload) async {
    final trimmed = payload.text?.trim() ?? '';
    final hasFiles = payload.filePaths.isNotEmpty;
    if ((!hasFiles && trimmed.isEmpty) || state.isSending) return;

    final optimistic = ChatMessage.local(
      conversationId: args.conversationId,
      senderId: state.currentUserId ?? '',
      text: trimmed.isNotEmpty
          ? trimmed
          : (hasFiles ? payload.kind.apiValue : ''),
    );

    final updated = [optimistic, ...state.messages];
    state = state.copyWith(messages: updated, isSending: true);
    stopTyping();

    try {
      dynamic res;
      if (hasFiles) {
        logger.i(
          '[Chat] Sending ${payload.kind.apiValue} with ${payload.filePaths.length} file(s)',
        );
        final formData = FormData();
        formData.fields.add(MapEntry('kind', payload.kind.apiValue));
        if (trimmed.isNotEmpty) {
          formData.fields.add(MapEntry('content', trimmed));
        }
        if (payload.replyToId != null && payload.replyToId!.isNotEmpty) {
          formData.fields.add(MapEntry('reply_to_id', payload.replyToId!));
        }
        for (final path in payload.filePaths) {
          formData.files.add(MapEntry(
            'attachments',
            await MultipartFile.fromFile(
              path,
              filename: p.basename(path),
            ),
          ));
        }
        res = await dioClient.postMultipart(
          ApiEndpoints.dmSendMessage(args.conversationId),
          formData,
        );
      } else {
        logger.i('[Chat] Sending TEXT to ${args.conversationId}: $trimmed');
        final body = <String, dynamic>{
          'kind': 'TEXT',
          'content': trimmed,
        };
        if (payload.replyToId != null && payload.replyToId!.isNotEmpty) {
          body['reply_to_id'] = payload.replyToId!;
        }
        res = await dioClient.postHttp(
          ApiEndpoints.dmSendMessage(args.conversationId),
          body,
        );
      }

      if (res is ResponseModel) {
        logger.e('[Chat] Send failed: ${res.message}');
        state = state.copyWith(
          isSending: false,
          error: res.message,
          messages: state.messages.where((m) => m.id != optimistic.id).toList(),
        );
        return;
      }

      if (res is Map && res['success'] == true && res['data'] is Map) {
        final sent = ChatMessage.fromJson(
          Map<String, dynamic>.from(res['data'] as Map),
        );
        _insertOrReplace(sent);
        _updateConversationPreview(sent);
        logger.i('[Chat] Message sent — id=${sent.id} kind=${sent.kind.apiValue}');
        state = state.copyWith(isSending: false, messages: List.of(state.messages));
      } else {
        state = state.copyWith(
          isSending: false,
          messages: state.messages.where((m) => m.id != optimistic.id).toList(),
          error: res is Map
              ? (res['message']?.toString() ?? 'Failed to send message')
              : 'Failed to send message',
        );
      }
    } catch (e) {
      logger.e('[Chat] Send error: $e');
      state = state.copyWith(
        isSending: false,
        messages: state.messages.where((m) => m.id != optimistic.id).toList(),
        error: e.toString(),
      );
    }
  }

  void _updateConversationPreview(ChatMessage message) {
    ref.read(conversationsProvider.notifier).updateConversationPreview(
          conversationId: args.conversationId,
          lastMessage: ConversationLastMessage(
            id: message.id,
            kind: message.kind,
            content: message.content,
            createdAt: message.createdAt,
            sender: message.sender != null
                ? ConversationParticipant(
                    id: message.sender!.id,
                    name: message.sender!.name,
                    avatar: message.sender!.avatar,
                  )
                : null,
            isMe: message.isMine(state.currentUserId),
          ),
        );
  }

  void updateTyping(bool isTyping) {
    _typingDebounce?.cancel();
    _typingDebounce = Timer(const Duration(milliseconds: 350), () {
      socketService.sendTyping(
        conversationId: args.conversationId,
        isTyping: isTyping,
      );
    });
  }

  void stopTyping() {
    _typingDebounce?.cancel();
    socketService.sendTyping(
      conversationId: args.conversationId,
      isTyping: false,
    );
  }

  Future<void> _markLatestIncomingRead() async {
    final incoming = state.messages
        .where((m) => !m.isMine(state.currentUserId))
        .toList();
    if (incoming.isEmpty) return;

    final latest = incoming.first;
    if (latest.id.isEmpty || latest.id.startsWith('local_')) return;
    if (_lastMarkedReadId == latest.id) return;

    try {
      await dioClient.patchHttp(
        ApiEndpoints.markConversationRead(args.conversationId),
        {'up_to_message_id': latest.id},
      );

      _lastMarkedReadId = latest.id;
      final at = latest.createdAt ?? DateTime.now().toUtc().toIso8601String();
      socketService.sendRead(
        conversationId: args.conversationId,
        at: at,
      );
    } catch (e) {
      logger.e('Mark read error: $e');
    }
  }

  void _insertOrReplace(ChatMessage incoming) {
    final messages = List<ChatMessage>.from(state.messages);
    final index = messages.indexWhere((m) => m.id == incoming.id);
    if (index != -1) {
      messages[index] = incoming;
      state = state.copyWith(messages: messages);
      return;
    }

    final localIndex = messages.indexWhere((m) {
      return m.status == DeliveryStatus.sending &&
          m.isMine(state.currentUserId) &&
          m.bodyText() == incoming.bodyText();
    });

    if (localIndex != -1) {
      messages[localIndex] = incoming;
      state = state.copyWith(messages: messages);
      return;
    }

    messages.insert(0, incoming);
    state = state.copyWith(messages: messages);
  }

  void _sortMessagesDesc() {
    final messages = List<ChatMessage>.from(state.messages);
    _sortListDesc(messages);
    state = state.copyWith(messages: messages);
  }

  void _sortListDesc(List<ChatMessage> list) {
    list.sort((a, b) {
      final aTime = DateTime.tryParse(a.createdAt ?? '');
      final bTime = DateTime.tryParse(b.createdAt ?? '');
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return bTime.compareTo(aTime);
    });
  }

  @override
  void dispose() {
    _typingDebounce?.cancel();
    _typingHideTimer?.cancel();
    stopTyping();
    if (_onNewMessage != null) {
      socketService.removeNewMessageListener(_onNewMessage!);
    }
    if (_onMessageStatus != null) {
      socketService.removeMessageStatusListener(_onMessageStatus!);
    }
    if (_onTyping != null) {
      socketService.removeTypingListener(_onTyping!);
    }
    socketService.leaveConversation();
    super.dispose();
  }
}
