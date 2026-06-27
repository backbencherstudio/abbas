import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/cors/services/socket_service.dart';
import 'package:abbas/cors/services/token_storage.dart';
import 'package:abbas/cors/services/user_id_storage.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/message/model/chat_message_model.dart';
import 'package:abbas/presentation/views/message/model/conversation_model.dart';
import 'package:flutter_riverpod/legacy.dart';

enum ConversationFilter { all, groups, dm }

class ConversationsState {
  final List<ConversationItem> conversations;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? error;
  final String? nextCursor;
  final bool hasMore;
  final String searchQuery;
  final ConversationFilter filter;
  final String? currentUserId;

  const ConversationsState({
    this.conversations = const [],
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.error,
    this.nextCursor,
    this.hasMore = true,
    this.searchQuery = '',
    this.filter = ConversationFilter.all,
    this.currentUserId,
  });

  ConversationsState copyWith({
    List<ConversationItem>? conversations,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? error,
    bool clearError = false,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? hasMore,
    String? searchQuery,
    ConversationFilter? filter,
    String? currentUserId,
  }) {
    return ConversationsState(
      conversations: conversations ?? this.conversations,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: clearError ? null : (error ?? this.error),
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
      filter: filter ?? this.filter,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }
}

final conversationsProvider =
    StateNotifierProvider<ConversationsNotifier, ConversationsState>(
  (ref) => ConversationsNotifier(dioClient: DioClient()),
);

class ConversationsNotifier extends StateNotifier<ConversationsState> {
  final DioClient dioClient;
  bool _isFetching = false;
  void Function(dynamic)? _onNewMessageListener;

  ConversationsNotifier({required this.dioClient})
      : super(const ConversationsState()) {
    _registerSocketListener();
  }

  void _registerSocketListener() {
    _onNewMessageListener ??= (data) {
      try {
        final message = ChatMessage.fromSocket(data);
        final conversationId = message.conversationId.isNotEmpty
            ? message.conversationId
            : ChatMessage.conversationIdFromSocket(data);
        if (conversationId == null || conversationId.isEmpty) return;

        final isMe = message.senderId == state.currentUserId;
        updateConversationPreview(
          conversationId: conversationId,
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
            isMe: isMe,
          ),
          unreadDelta: isMe ? 0 : 1,
        );
      } catch (e) {
        logger.e('Conversations socket message error: $e');
      }
    };
    SocketService().addNewMessageListener(_onNewMessageListener!);
  }

  @override
  void dispose() {
    if (_onNewMessageListener != null) {
      SocketService().removeNewMessageListener(_onNewMessageListener!);
    }
    super.dispose();
  }

  String? _typeParam() {
    switch (state.filter) {
      case ConversationFilter.all:
        return null;
      case ConversationFilter.groups:
        return 'GROUP';
      case ConversationFilter.dm:
        return 'DM';
    }
  }

  Future<void> loadInitial() async {
    if (_isFetching) return;
    state = state.copyWith(isInitialLoading: true, clearError: true);
    await _fetch(cursor: null, append: false);
  }

  Future<void> refresh() async {
    if (_isFetching) return;
    state = state.copyWith(isRefreshing: true, clearError: true);
    await _fetch(cursor: null, append: false);
  }

  Future<void> loadMore() async {
    if (_isFetching || !state.hasMore || state.nextCursor == null) return;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    await _fetch(cursor: state.nextCursor, append: true);
  }

  Future<void> setFilter(ConversationFilter filter) async {
    if (state.filter == filter) return;
    state = state.copyWith(filter: filter);
    await refresh();
  }

  Future<void> connectSocket() async {
    final token = await TokenStorage().getToken();
    if (token != null && token.isNotEmpty) {
      SocketService().connect(token);
    }
  }

  /// Resolves the logged-in user id from storage or `/api/auth/me`.
  Future<String?> ensureCurrentUserId() async {
    if (state.currentUserId != null && state.currentUserId!.isNotEmpty) {
      return state.currentUserId;
    }

    final stored = await UserIdStorage().getUserId();
    try {
      final res = await dioClient.getHttp(ApiEndpoints.getProfile);
      if (res is Map && res['success'] == true && res['data'] is Map) {
        final data = Map<String, dynamic>.from(res['data'] as Map);
        final userId = data['id']?.toString();
        if (userId != null && userId.isNotEmpty) {
          await UserIdStorage().saveUserId(userId);
          state = state.copyWith(currentUserId: userId);
          return userId;
        }
      }
    } catch (e) {
      logger.e('ensureCurrentUserId error: $e');
    }

    if (stored != null && stored.isNotEmpty) {
      state = state.copyWith(currentUserId: stored);
      return stored;
    }
    return null;
  }

  Future<void> search(String query) async {
    state = state.copyWith(searchQuery: query.trim());
    await refresh();
  }

  void updateConversationPreview({
    required String conversationId,
    required ConversationLastMessage lastMessage,
    int unreadDelta = 0,
  }) {
    final updated = [
      for (final conv in state.conversations)
        if (conv.id == conversationId)
          ConversationItem(
            id: conv.id,
            title: conv.title,
            avatar: conv.avatar,
            type: conv.type,
            totalMembers: conv.totalMembers,
            unreadMessages: (conv.unreadMessages + unreadDelta).clamp(0, 999),
            participant: conv.participant,
            isSilenced: conv.isSilenced,
            mutedUntil: conv.mutedUntil,
            lastMessage: lastMessage,
          )
        else
          conv,
    ];

    updated.sort((a, b) {
      final aTime = DateTime.tryParse(a.lastMessage?.createdAt ?? '');
      final bTime = DateTime.tryParse(b.lastMessage?.createdAt ?? '');
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return bTime.compareTo(aTime);
    });

    state = state.copyWith(conversations: updated);
  }

  void clearUnread(String conversationId) {
    final updated = [
      for (final conv in state.conversations)
        if (conv.id == conversationId)
          ConversationItem(
            id: conv.id,
            title: conv.title,
            avatar: conv.avatar,
            type: conv.type,
            totalMembers: conv.totalMembers,
            unreadMessages: 0,
            participant: conv.participant,
            isSilenced: conv.isSilenced,
            mutedUntil: conv.mutedUntil,
            lastMessage: conv.lastMessage,
          )
        else
          conv,
    ];
    state = state.copyWith(conversations: updated);
  }

  Future<void> _fetch({required String? cursor, required bool append}) async {
    _isFetching = true;
    try {
      await ensureCurrentUserId();

      final res = await dioClient.getHttp(
        ApiEndpoints.conversationsList(
          type: _typeParam(),
          limit: 10,
          cursor: cursor,
          search: state.searchQuery,
        ),
      );

      if (res is ResponseModel) {
        state = state.copyWith(
          isInitialLoading: false,
          isLoadingMore: false,
          isRefreshing: false,
          error: res.message,
        );
        return;
      }

      if (res is Map && res['success'] == true) {
        final model = ConversationsResponse.fromJson(
          Map<String, dynamic>.from(res),
        );
        final merged = append
            ? [...state.conversations, ...model.data]
            : model.data;

        state = state.copyWith(
          conversations: merged,
          isInitialLoading: false,
          isLoadingMore: false,
          isRefreshing: false,
          clearError: true,
          nextCursor: model.meta?.nextCursor,
          clearNextCursor: model.meta?.nextCursor == null,
          hasMore: model.meta?.nextCursor != null,
        );
        return;
      }

      state = state.copyWith(
        isInitialLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        error: res is Map
            ? (res['message']?.toString() ?? 'Failed to load conversations')
            : 'Failed to load conversations',
      );
    } catch (e) {
      logger.e('Conversations error: $e');
      state = state.copyWith(
        isInitialLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        error: e.toString(),
      );
    } finally {
      _isFetching = false;
    }
  }
}
