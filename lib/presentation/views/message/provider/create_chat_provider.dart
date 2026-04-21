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
  bool _hasMore = true;
  bool get hasMore => _hasMore;

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


  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }
}

