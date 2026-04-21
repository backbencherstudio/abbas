import 'dart:async';
import 'dart:convert';

import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/services/socket_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/dm_all_message_model.dart';

class GroupChatProvider extends ChangeNotifier {
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
  bool _initialized = false;

  Future<void> initGroupChat({
    required String token,
    required String conversationId,
    required String currentUserId,
  }) async {
    if (_initialized &&
        _token == token &&
        _conversationId == conversationId &&
        _currentUserId == currentUserId) {
      return;
    }

    _initialized = true;
    _token = token;
    _conversationId = conversationId;
    _currentUserId = currentUserId;

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
    final token = _token;
    final conversationId = _conversationId;
    if (token == null || conversationId == null) return;

    try {
      final loaded = await _fetchAllMessagesUntilEnd(
        token: token,
        conversationId: conversationId,
      );
      messages = loaded;
      _sortMessagesDesc();
    } catch (e) {
      error = 'Failed to load group messages';
      debugPrint('Group loadInitialMessages error: $e');
    }

    notifyListeners();
  }

  Future<List<Items>> _fetchAllMessagesUntilEnd({
    required String token,
    required String conversationId,
    int take = 50,
  }) async {
    final List<Items> all = [];
    String? cursor;
    bool shouldContinue = true;

    while (shouldContinue) {
      final url = ApiEndpoints.dmAllMessage(conversationId, take, cursor);

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed with code ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final model = DmAllMessageModel.fromJson(decoded);

      all.addAll(model.items ?? []);

      final newCursor = model.nextCursor;
      if (newCursor == null || newCursor.isEmpty) {
        shouldContinue = false;
      } else {
        cursor = newCursor;
      }
    }

    final unique = <String, Items>{};
    for (final msg in all) {
      final id = (msg.id ?? '').trim();
      if (id.isNotEmpty) {
        unique[id] = msg;
      }
    }

    nextCursor = null;
    hasMore = false;

    return unique.values.toList();
  }

  Future<void> loadMoreMessages() async {
    if (isLoadingMore || !hasMore) return;

    final token = _token;
    final conversationId = _conversationId;
    final cursor = nextCursor;

    if (token == null || conversationId == null || cursor == null || cursor.isEmpty) {
      hasMore = false;
      notifyListeners();
      return;
    }

    isLoadingMore = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.dmAllMessage(conversationId, 30, cursor)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final model = DmAllMessageModel.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );

        for (final msg in model.items ?? []) {
          _insertOrReplace(msg);
        }

        nextCursor = model.nextCursor;
        hasMore = nextCursor != null && nextCursor!.isNotEmpty;
        _sortMessagesDesc();
      }
    } catch (e) {
      debugPrint('Group loadMoreMessages error: $e');
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
      debugPrint('Group conversation joined => $data');
    });

    _socketService.onNewMessage((data) {
      try {
        final msg = Items.fromSocket(Map<String, dynamic>.from(data));

        if ((msg.conversationId ?? '').trim() != (_conversationId ?? '').trim()) {
          return;
        }

        _insertOrReplace(msg);
        _sortMessagesDesc();
        notifyListeners();
      } catch (e) {
        debugPrint('Group onNewMessage error: $e');
      }
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
        debugPrint('Group typing parse error: $e');
      }
    });

    _socketService.onMessageRead((data) {
      debugPrint('Group message read => $data');
    });

    _socketService.onMessageAck((data) {
      debugPrint('Group message ack => $data');
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
      sender: Sender(id: _currentUserId),
    );

    messages.insert(0, optimistic);
    notifyListeners();

    _socketService.sendTextMessage(
      conversationId: conversationId,
      text: trimmed,
    );
  }

  Future<void> markConversationRead() async {
    final token = _token;
    final conversationId = _conversationId;
    if (token == null || conversationId == null) return;

    final nowIso = DateTime.now().toUtc().toIso8601String();

    try {
      await http.patch(
        Uri.parse(ApiEndpoints.markConversationRead(conversationId)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'at': nowIso}),
      );

      _socketService.sendRead(
        conversationId: conversationId,
        at: nowIso,
      );
    } catch (e) {
      debugPrint('Group markConversationRead error: $e');
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
      final oldId = (m.id ?? '').trim();
      final newId = (incoming.id ?? '').trim();

      if (oldId.isNotEmpty && newId.isNotEmpty) {
        return oldId == newId;
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

    final optimisticIndex = messages.indexWhere((m) {
      return (m.status == 'sending') &&
          (m.content?.text ?? '').trim() == (incoming.content?.text ?? '').trim() &&
          (m.senderId ?? '').trim() == (incoming.senderId ?? '').trim() &&
          (m.conversationId ?? '').trim() == (incoming.conversationId ?? '').trim();
    });

    if (optimisticIndex != -1) {
      messages[optimisticIndex] = incoming;
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
    _initialized = false;
  }

  @override
  void dispose() {
    disposeResources();
    super.dispose();
  }
}
