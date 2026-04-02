// lib/presentation/views/message/provider/create_chat_provider.dart

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
  final int _limit = 40; // initial batch size
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  String selectedFilter = 'All';
  String? statusValue = 'all';
  String? dateValue = 'today';

  // ====================== FILTER METHODS ======================

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

  // ====================== CONVERSATION & MESSAGE METHODS ======================

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
      } else {
        _errorMessage = response.message;
        return false;
      }
    } catch (error) {
      _errorMessage = error.toString();
      logger.e("Create Conversation Error: $error");
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
        List data = response.data;
        _allConversationModel = data
            .map((e) => AllConversationModel.fromJson(e))
            .toList();
        return true;
      } else {
        _errorMessage = response.message;
        return false;
      }
    } catch (error) {
      _errorMessage = error.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Cursor-based message loader
  Future<void> getDmAllMessageRoom(
    String conversationId, {
    bool isLoadMore = false,
  }) async {
    if (isLoadMore && !_hasMore) return;

    _errorMessage = null;

    if (!isLoadMore) {
      _isLoading = true;
      _cursor = null; // reset cursor
    }

    notifyListeners();

    try {
      final ApiResponseModel response = await _apiClient.get(
        ApiEndpoints.dmAllMessage(conversationId, _limit, _cursor),
      );

      if (response.success) {
        final newData = DmAllMessageModel.fromJson(response.data);
        final newItems = newData.items ?? [];

        if (!isLoadMore) {
          // ✅ Initial load
          _dmAllMessageModel = newData;
        } else {
          // ✅ Pagination: prepend older messages (reverse:true)
          final existingIds =
              _dmAllMessageModel?.items?.map((e) => e.id).toSet() ?? <String>{};
          final filteredNewItems = newItems
              .where((e) => !existingIds.contains(e.id))
              .toList();

          _dmAllMessageModel?.items = [
            ..._dmAllMessageModel!.items ?? [],
            ...filteredNewItems,
          ];
        }

        // ✅ Set cursor to oldest message id of this batch
        if (newItems.isNotEmpty) {
          _cursor = newItems.last.id;
        } else {
          _hasMore = false;
        }

        _hasMore = newData.nextCursor != null;
      } else {
        _errorMessage = response.message;
      }
    } catch (error) {
      _errorMessage = error.toString();
      logger.e("Pagination Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ====================== REAL-TIME METHODS ======================

  Future<void> initializeRealtime(String token, String conversationId) async {
    try {
      logger.i("Starting socket connection for conversation: $conversationId");

      await _socketService.connect(token);

      // Join conversation room
      _socketService.joinConversation(conversationId);

      // Listen for incoming messages
      _socketService.messageStream.listen((data) {
        _handleIncomingRealtimeMessage(data, conversationId);
      });

      logger.i(
        "✅ Real-time chat initialized for conversation: $conversationId",
      );
    } catch (e) {
      logger.e("Failed to initialize real-time: $e");
    }
  }

  void _handleIncomingRealtimeMessage(
    Map<String, dynamic> data,
    String currentConversationId,
  ) {
    if (data['conversationId'] != currentConversationId) return;

    try {
      _dmAllMessageModel ??= DmAllMessageModel(items: []);

      final newMessage = Items.fromSocket(data);

      // Insert newest at bottom if reverse:true
      _dmAllMessageModel!.items?.insert(0, newMessage);

      notifyListeners();
      logger.i("✅ Real-time message added: ${newMessage.content?.text}");
    } catch (e) {
      logger.e("Error processing realtime message: $e");
    }
  }

  void sendMessageRealtime({
    required String conversationId,
    required String kind,
    required String text,
  }) {
    if (!_socketService.isConnected) {
      logger.w("Socket not connected yet.");
      return;
    }

    _socketService.sendMessage(
      conversationId: conversationId,
      kind: kind,
      content: {'text': text},
    );
  }

  void sendTyping(String conversationId, bool isTyping) {
    _socketService.sendTyping(conversationId, isTyping);
  }

  void leaveConversation(String conversationId) {
    _socketService.leaveConversation(conversationId);
    logger.i("Left conversation: $conversationId");
  }

  void clearMessages() {
    _dmAllMessageModel = null;
    _cursor = null;
    _hasMore = true;
    notifyListeners();
  }

  // ====================== BACKUP HTTP SEND ======================
  Future<void> dmSendMessage({
    required String kind,
    required String text,
    required String conversationId,
  }) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    final body = {
      'kind': kind,
      'content': {'text': text},
    };

    try {
      final response = await _apiClient.post(
        ApiEndpoints.dmSendMessage(conversationId),
        body: body,
      );

      if (response.success) {
        logger.i("Message sent via HTTP backup");
      } else {
        _errorMessage = response.message;
      }
    } catch (error) {
      _errorMessage = error.toString();
      logger.e("HTTP Send Error: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _socketService.dispose();
    super.dispose();
  }
}
