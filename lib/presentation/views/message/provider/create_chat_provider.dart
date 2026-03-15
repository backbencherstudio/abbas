import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_response_handle.dart';
import 'package:abbas/cors/network/api_response_model.dart';
import 'package:abbas/presentation/views/message/model/all_conversation_model.dart';
import 'package:abbas/presentation/views/message/model/create_conversation_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import '../../../../cors/services/api_client.dart';

class CreateChatProvider extends ChangeNotifier {
  CreateChatProvider(){
    getAllConversation();
  }
  final ApiClient _apiClient = ApiClient();
  final Logger logger = Logger();

  CreateConversationModel? _createConversationModel;
  CreateConversationModel? get createConversationModel =>
      _createConversationModel;

  AllConversationModel? _allConversationModel;
  AllConversationModel? get allConversationModel => _allConversationModel;

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
        _allConversationModel = AllConversationModel.fromJson(response.data);
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
}
