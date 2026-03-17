import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_response_model.dart';
import 'package:abbas/presentation/views/message/model/all_conversation_model.dart';
import 'package:abbas/presentation/views/message/model/create_conversation_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import '../../../../cors/services/api_client.dart';
import '../model/dm_all_message_model.dart';

class CreateChatProvider extends ChangeNotifier {
  CreateChatProvider() {
    getAllConversation();
  }

  final ApiClient _apiClient = ApiClient();
  final Logger logger = Logger();

  CreateConversationModel? _createConversationModel;

  CreateConversationModel? get createConversationModel =>
      _createConversationModel;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<bool> createConversation(String otherId) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final ApiResponseModel response = await _apiClient.post(
        ApiEndpoints.createConversation,
        body: {"otherUserId": otherId},
      );

      logger.i("API Success Status: ${response.success}");
      logger.i("API Message: ${response.message}");
      logger.d("Raw API Data: ${response.data}");

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

  List<AllConversationModel> _allConversationModel = [];

  List<AllConversationModel> get allConversationModel => _allConversationModel;

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

  int _cursor = 0;
  final int _limit = 20;

  int get cursor => _cursor;

  int get limit => _limit;
  DmAllMessageModel? _dmAllMessageModel;

  DmAllMessageModel? get dmAllMessageModel => _dmAllMessageModel;

  Future<void> getDmAllMessageRoom(String conversationId) async {
    _errorMessage = null;
    _isLoading = true;

    notifyListeners();

    try {
      final ApiResponseModel response = await _apiClient.get(
        ApiEndpoints.dmAllMessage(conversationId, _cursor, _limit),
      );

      if (response.success) {
        _dmAllMessageModel = DmAllMessageModel.fromJson(response.data);
        logger.i("API Success Status=======: ${response.success}");
        logger.i("API Message:========== ${response.message}");
        logger.d("Raw API Data:========= ${response.data}");
        // update cursor for next pagination
        _cursor += _limit;
      }
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> dmSendMessage(String conversationId) async {
    _errorMessage = null;
    _isLoading = true;

    notifyListeners();

    try {
      final ApiResponseModel response = await _apiClient.post(
        ApiEndpoints.dmSendMessage(conversationId),
      );
      if (response.success) {
        logger.i("API Success Status=======: ${response.success}");
        logger.i("API Message:========== ${response.message}");
        logger.d("Raw API Data:========= ${response.data}");
        _cursor += _limit;
      }
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
