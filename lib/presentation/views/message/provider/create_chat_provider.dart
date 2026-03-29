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

  int _cursor = 0;
  final int _limit = 400;

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

  /// **Improved**: Now properly clears old messages when loading a new conversation
  Future<void> getDmAllMessageRoom(String conversationId) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final ApiResponseModel response = await _apiClient.get(
        ApiEndpoints.dmAllMessage(conversationId, _cursor, _limit),
      );

      if (response.success) {
        final newData = DmAllMessageModel.fromJson(response.data);

        // IMPORTANT: Replace messages instead of appending when loading a new chat
        _dmAllMessageModel = newData;
        _cursor = _limit; // Reset cursor for future pagination if needed
      } else {
        _dmAllMessageModel = DmAllMessageModel(items: []);
      }
    } catch (error) {
      _errorMessage = error.toString();
      logger.e("Get DM Messages Error: $error");
      _dmAllMessageModel = DmAllMessageModel(items: []);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ====================== REAL-TIME METHODS ======================

  /// Initialize Real-time Socket + Join Room
  Future<void> initializeRealtime(String token, String conversationId) async {
    try {
      logger.i("Starting socket connection for conversation: $conversationId");

      await _socketService.connect(token);

      // Join the specific conversation room
      _socketService.joinConversation(conversationId);

      // Listen for new messages (only once)
      _socketService.messageStream.listen((data) {
        _handleIncomingRealtimeMessage(data, conversationId);
      });

      logger.i(
        "✅ Real-time chat initialized successfully for conversation: $conversationId",
      );
    } catch (e) {
      logger.e("Failed to initialize real-time: $e");
    }
  }

  /// Handle incoming real-time message
  void _handleIncomingRealtimeMessage(
    Map<String, dynamic> data,
    String currentConversationId,
  ) {
    // Ignore messages from other conversations
    if (data['conversationId'] != currentConversationId) {
      return;
    }

    try {
      if (_dmAllMessageModel == null) {
        _dmAllMessageModel = DmAllMessageModel(items: []);
      }

      final newMessage = Items.fromSocket(data);

      // Insert at the beginning (newest first)
      _dmAllMessageModel!.items?.insert(0, newMessage);

      notifyListeners();
      logger.i("✅ Real-time message added: ${newMessage.content?.text}");
    } catch (e) {
      logger.e("Error processing realtime message: $e");
    }
  }

  /// Send Message using WebSocket
  void sendMessageRealtime({
    required String conversationId,
    required String kind,
    required String text,
  }) {
    if (!_socketService.isConnected) {
      logger.w("⚠️ Socket is not connected yet.");
      return;
    }

    _socketService.sendMessage(
      conversationId: conversationId,
      kind: kind,
      content: {'text': text},
    );
  }

  /// Send Typing Event
  void sendTyping(String conversationId, bool isTyping) {
    _socketService.sendTyping(conversationId, isTyping);
  }

  /// Leave conversation (Call this when user leaves the chat screen)
  void leaveConversation(String conversationId) {
    _socketService.leaveConversation(conversationId);
    logger.i("Left conversation: $conversationId");
  }

  /// Clear current chat data (Very Important to prevent duplicate messages)
  void clearMessages() {
    _dmAllMessageModel = null;
    _cursor = 0;
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
    // Clean up if needed
    _socketService.dispose(); // If your SocketService has dispose method
    super.dispose();
  }
}
