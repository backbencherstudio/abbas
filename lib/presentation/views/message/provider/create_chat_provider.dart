import 'dart:async';
import 'package:abbas/presentation/views/message/model/all_conversation_model.dart';
import 'package:abbas/presentation/views/message/model/create_conversation_model.dart';
import 'package:abbas/presentation/views/message/model/dm_all_message_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../../cors/constants/api_endpoints.dart';
import '../../../../cors/network/api_response_model.dart';
import '../../../../cors/services/api_client.dart';
import '../../../../cors/services/socket_service.dart';

class CreateChatProvider extends ChangeNotifier {
  CreateChatProvider() {
    getAllConversation();
  }

  final ApiClient _apiClient = ApiClient();
  final SocketService _socketService = SocketService();
  final Logger logger = Logger();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  CreateConversationModel? _createConversationModel;
  CreateConversationModel? get createConversationModel =>
      _createConversationModel;

  List<AllConversationModel> _allConversationModel = [];
  List<AllConversationModel> get allConversationModel => _allConversationModel;

  DmAllMessageModel? _dmAllMessageModel;
  DmAllMessageModel? get dmAllMessageModel => _dmAllMessageModel;

  String? _cursor;
  final int _limit = 40;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String? _activeConversationId;
  StreamSubscription<Map<String, dynamic>>? _messageSubscription;

  String selectedFilter = 'All';
  String? statusValue = 'all';
  String? dateValue = 'today';

  void toggleFilter(String value) {
    selectedFilter = value;
    notifyListeners();
  }

  void toggleStatus(String value) {
    statusValue = value;
    notifyListeners();
  }

  void toggleDate(String value) {
    dateValue = value;
    notifyListeners();
  }

  Future<bool> createConversation(String otherId) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final ApiResponseModel response = await _apiClient.post(
        ApiEndpoints.createConversation,
        body: {"otherUserId": otherId},
      );

      if (response.success) {
        _createConversationModel = CreateConversationModel.fromJson(
          response.data,
        );
        return true;
      }

      _errorMessage = response.message;
      return false;
    } catch (error) {
      _errorMessage = error.toString();
      logger.e("Create conversation error: $error");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> getAllConversation() async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final ApiResponseModel response = await _apiClient.get(
        ApiEndpoints.allConversationList,
      );

      if (response.success) {
        final data = response.data as List;
        _allConversationModel = data
            .map((e) => AllConversationModel.fromJson(e))
            .toList();
        return true;
      }

      _errorMessage = response.message;
      return false;
    } catch (error) {
      _errorMessage = error.toString();
      logger.e("Get all conversation error: $error");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getDmAllMessageRoom(
      String conversationId, {
        bool isLoadMore = false,
      }) async {
    if (conversationId.trim().isEmpty) return;
    if (isLoadMore && (!_hasMore || _isLoading)) return;

    _errorMessage = null;
    _isLoading = true;

    if (!isLoadMore) {
      _cursor = null;
      _hasMore = true;
    }

    notifyListeners();

    try {
      final ApiResponseModel response = await _apiClient.get(
        ApiEndpoints.dmAllMessage(conversationId, _limit, _cursor),
      );

      if (!response.success) {
        _errorMessage = response.message;
        return;
      }

      final newData = DmAllMessageModel.fromJson(response.data);
      final newItems = List<Items>.from(newData.items ?? []);

      if (!isLoadMore || _dmAllMessageModel == null) {
        _dmAllMessageModel = newData;
      } else {
        final existingIds =
        (_dmAllMessageModel!.items ?? []).map((e) => e.id).toSet();

        final filtered = newItems
            .where((e) => e.id != null && !existingIds.contains(e.id))
            .toList();

        _dmAllMessageModel!.items = [
          ...(_dmAllMessageModel!.items ?? []),
          ...filtered,
        ];
      }

      _cursor = newData.nextCursor;
      _hasMore = newData.nextCursor != null && newItems.isNotEmpty;

      _sortMessagesAsc();
    } catch (error) {
      _errorMessage = error.toString();
      logger.e("Get DM messages error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initializeRealtime(String token, String conversationId) async {
    if (conversationId.trim().isEmpty) return;

    try {
      _activeConversationId = conversationId;

      await _socketService.connect(token);
      _socketService.joinConversation(conversationId);

      await _messageSubscription?.cancel();
      _messageSubscription = _socketService.messageStream.listen((data) {
        _handleIncomingRealtimeMessage(data, conversationId);
      });

      logger.i("Realtime initialized for $conversationId");
    } catch (e) {
      logger.e("Realtime init error: $e");
    }
  }

  void _handleIncomingRealtimeMessage(
      Map<String, dynamic> data,
      String currentConversationId,
      ) {
    final incomingConversationId =
    (data['conversationId'] ??
        data['conversation_id'] ??
        data['conversation']?['id'])
        ?.toString();

    if (incomingConversationId != currentConversationId) return;

    try {
      final newMessage = Items.fromJson(data);

      _dmAllMessageModel ??= DmAllMessageModel(items: []);

      final list = _dmAllMessageModel!.items ?? [];

      final exists = list.any((m) {
        if (m.id != null && newMessage.id != null) {
          return m.id == newMessage.id;
        }

        return m.senderId == newMessage.senderId &&
            m.createdAt == newMessage.createdAt &&
            m.content?.text == newMessage.content?.text;
      });

      if (!exists) {
        list.add(newMessage);
        _dmAllMessageModel!.items = list;
        _sortMessagesAsc();
        notifyListeners();
      }
    } catch (e) {
      logger.e("Realtime message parse error: $e");
    }
  }

  Future<void> sendMessageRealtime({
    required String conversationId,
    required String kind,
    required String text,
  }) async {
    final trimmedText = text.trim();
    if (conversationId.trim().isEmpty || trimmedText.isEmpty) return;

    try {
      if (_socketService.isConnected) {
        _socketService.sendMessage(
          conversationId: conversationId,
          kind: kind,
          content: {'text': trimmedText},
        );
      } else {
        await dmSendMessage(
          kind: kind,
          text: trimmedText,
          conversationId: conversationId,
        );
      }
    } catch (e) {
      await dmSendMessage(
        kind: kind,
        text: trimmedText,
        conversationId: conversationId,
      );
    }
  }

  void sendTyping(String conversationId, bool isTyping) {
    _socketService.sendTyping(conversationId, isTyping);
  }

  void leaveConversation(String conversationId) {
    if (_activeConversationId == conversationId) {
      _activeConversationId = null;
    }

    _socketService.leaveConversation(conversationId);
    _messageSubscription?.cancel();
    _messageSubscription = null;
  }

  void clearMessages() {
    _dmAllMessageModel = null;
    _cursor = null;
    _hasMore = true;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> dmSendMessage({
    required String kind,
    required String text,
    required String conversationId,
  }) async {
    final body = {
      'kind': kind,
      'content': {'text': text},
    };

    try {
      final response = await _apiClient.post(
        ApiEndpoints.dmSendMessage(conversationId),
        body: body,
      );

      if (!response.success) {
        _errorMessage = response.message;
        notifyListeners();
        return;
      }

      final payload = response.data;
      if (payload is Map<String, dynamic>) {
        _handleIncomingRealtimeMessage(payload, conversationId);
      } else {
        await getDmAllMessageRoom(conversationId);
      }
    } catch (error) {
      _errorMessage = error.toString();
      logger.e("HTTP send error: $error");
      notifyListeners();
    }
  }

  void _sortMessagesAsc() {
    final items = _dmAllMessageModel?.items;
    if (items == null) return;

    items.sort((a, b) {
      final aTime = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(1970);
      final bTime = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(1970);
      return aTime.compareTo(bTime);
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }
}

