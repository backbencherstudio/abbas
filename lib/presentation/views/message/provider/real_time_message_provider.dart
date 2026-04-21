import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../cors/constants/api_endpoints.dart';
import '../../../../cors/services/socket_service.dart';
import '../model/dm_all_message_model.dart';

class RealTimeMessageProvider extends ChangeNotifier {
  final SocketService _socketService = SocketService();

  List<Items> messages = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool isOtherUserTyping = false;
  bool hasMore = true;
  String? nextCursor;
  String? error;

  String? _currentUserId;
  String? _conversationId;
  String? _token;
  Timer? _typingDebounce;

  Future<void> initChat(
      String token,
      String conversationId,
      String myUserId,
      ) async {
    _token = token;
    _currentUserId = myUserId;
    _conversationId = conversationId;

    isLoading = true;
    error = null;
    messages = [];
    nextCursor = null;
    hasMore = true;
    notifyListeners();

    _socketService.connect(token);
    _socketService.joinConversation(conversationId);
    _setupSocketListeners();

    await loadInitialMessages();
    await markConversationRead();

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadInitialMessages() async {
    final conversationId = _conversationId;
    final token = _token;
    if (conversationId == null || token == null) return;

    try {
      final loadedMessages = await _fetchAllMessagesUntilEnd(
        conversationId: conversationId,
        token: token,
        take: 50,
      );

      messages = loadedMessages;
      _sortMessagesDesc();
    } catch (e) {
      error = 'Failed to load messages';
      debugPrint('❌ loadInitialMessages error: $e');
    }
  }

  Future<List<Items>> _fetchAllMessagesUntilEnd({
    required String conversationId,
    required String token,
    int take = 50,
  }) async {
    final List<Items> all = [];
    String? cursor;
    bool continueLoading = true;

    while (continueLoading) {
      final url = ApiEndpoints.dmAllMessage(conversationId, take, cursor);

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Message fetch failed: ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final model = DmAllMessageModel.fromJson(decoded);

      final pageItems = model.items ?? [];
      all.addAll(pageItems);

      final newCursor = model.nextCursor;
      if (newCursor == null || newCursor.isEmpty) {
        continueLoading = false;
      } else {
        cursor = newCursor;
      }
    }

    final unique = <String, Items>{};
    for (final item in all) {
      final key = (item.id ?? '').trim();
      if (key.isNotEmpty) {
        unique[key] = item;
      }
    }

    nextCursor = null;
    hasMore = false;
    return unique.values.toList();
  }

  Future<void> loadMoreMessages() async {
    if (isLoadingMore || !hasMore) return;
    final conversationId = _conversationId;
    final token = _token;
    final cursor = nextCursor;

    if (conversationId == null || token == null || cursor == null || cursor.isEmpty) {
      hasMore = false;
      notifyListeners();
      return;
    }

    isLoadingMore = true;
    notifyListeners();

    try {
      final url = ApiEndpoints.dmAllMessage(conversationId, 30, cursor);

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final model = DmAllMessageModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );

        final incoming = model.items ?? [];
        for (final item in incoming) {
          _insertOrReplace(item);
        }

        nextCursor = model.nextCursor;
        hasMore = nextCursor != null && nextCursor!.isNotEmpty;
        _sortMessagesDesc();
      }
    } catch (e) {
      debugPrint('❌ loadMoreMessages error: $e');
    }

    isLoadingMore = false;
    notifyListeners();
  }

  void _setupSocketListeners() {
    _socketService.offNewMessage();
    _socketService.offMessageAck();
    _socketService.offTyping();
    _socketService.offMessageRead();
    _socketService.offConversationJoined();

    _socketService.onConversationJoined((data) {
      debugPrint('✅ conversation:joined => $data');
    });

    _socketService.onNewMessage((data) {
      try {
        final item = Items.fromSocket(Map<String, dynamic>.from(data));
        if ((item.conversationId ?? '').trim() != (_conversationId ?? '').trim()) {
          return;
        }

        _insertOrReplace(item);
        _sortMessagesDesc();
        notifyListeners();
      } catch (e) {
        debugPrint('❌ onNewMessage parse error: $e');
      }
    });

    _socketService.onMessageAck((data) {
      debugPrint('✅ message:ack => $data');
    });

    _socketService.onTyping((data) {
      try {
        final map = Map<String, dynamic>.from(data);
        final userId = map['userId']?.toString();
        final on = map['on'] == true;

        if (userId != null && userId != _currentUserId) {
          isOtherUserTyping = on;
          notifyListeners();
        }
      } catch (e) {
        debugPrint('❌ typing parse error: $e');
      }
    });

    _socketService.onMessageRead((data) {
      debugPrint('✅ message:read => $data');
    });
  }

  void sendTextMessage(String text) {
    final trimmed = text.trim();
    final conversationId = _conversationId;

    if (trimmed.isEmpty || conversationId == null || conversationId.isEmpty) {
      return;
    }

    final optimistic = Items(
      id: 'local_${DateTime.now().microsecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: _currentUserId,
      kind: 'TEXT',
      content: Content(text: trimmed),
      createdAt: DateTime.now().toIso8601String(),
      status: 'sending',
    );

    messages.insert(0, optimistic);
    notifyListeners();

    _socketService.sendTextMessage(
      conversationId: conversationId,
      text: trimmed,
    );
  }

  Future<void> markConversationRead() async {
    final conversationId = _conversationId;
    final token = _token;
    if (conversationId == null || token == null) return;

    final nowIso = DateTime.now().toUtc().toIso8601String();

    try {
      await http.patch(
        Uri.parse(ApiEndpoints.markConversationRead(conversationId)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'at': nowIso,
        }),
      );

      _socketService.sendRead(
        conversationId: conversationId,
        at: nowIso,
      );
    } catch (e) {
      debugPrint('❌ markConversationRead error: $e');
    }
  }

  void updateTyping(bool isTyping) {
    final conversationId = _conversationId;
    if (conversationId == null) return;

    _typingDebounce?.cancel();
    _typingDebounce = Timer(const Duration(milliseconds: 300), () {
      _socketService.sendTyping(
        conversationId: conversationId,
        isTyping: isTyping,
      );
    });
  }

  void _insertOrReplace(Items incoming) {
    final existingIndex = messages.indexWhere((m) {
      final aId = (m.id ?? '').trim();
      final bId = (incoming.id ?? '').trim();

      if (aId.isNotEmpty && bId.isNotEmpty) {
        return aId == bId;
      }

      return (m.content?.text ?? '').trim() == (incoming.content?.text ?? '').trim() &&
          (m.senderId ?? '').trim() == (incoming.senderId ?? '').trim() &&
          (m.createdAt ?? '').trim() == (incoming.createdAt ?? '').trim() &&
          (m.conversationId ?? '').trim() == (incoming.conversationId ?? '').trim();
    });

    if (existingIndex != -1) {
      messages[existingIndex] = incoming;
      return;
    }

    final localSendingIndex = messages.indexWhere((m) {
      return (m.status == 'sending') &&
          (m.senderId ?? '').trim() == (incoming.senderId ?? '').trim() &&
          (m.content?.text ?? '').trim() == (incoming.content?.text ?? '').trim() &&
          (m.conversationId ?? '').trim() == (incoming.conversationId ?? '').trim();
    });

    if (localSendingIndex != -1) {
      messages[localSendingIndex] = incoming;
      return;
    }

    messages.insert(0, incoming);
  }

  void _sortMessagesDesc() {
    messages.sort((a, b) {
      final aTime = DateTime.tryParse(a.createdAt ?? '');
      final bTime = DateTime.tryParse(b.createdAt ?? '');

      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;

      return bTime.compareTo(aTime);
    });
  }

  void disposeResources() {
    _typingDebounce?.cancel();
    _socketService.offNewMessage();
    _socketService.offMessageAck();
    _socketService.offTyping();
    _socketService.offMessageRead();
    _socketService.offConversationJoined();
    isOtherUserTyping = false;
  }

  @override
  void dispose() {
    disposeResources();
    super.dispose();
  }
}
