import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:io';
import '../../../../../../cors/constants/api_endpoints.dart';
import '../../../../../../cors/network/api_response_model.dart';
import '../../../../../../cors/services/api_client.dart';
import '../../../../../../cors/services/token_storage.dart';

class CreatePostProvider extends ChangeNotifier {

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final ApiClient _apiClient = ApiClient();
  final Logger logger = Logger();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<bool> createPost(String content, File? imageFile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _tokenStorage.getToken();
      if (token == null) {
        _errorMessage = "Please login again";
        return false;
      }

      final fields = {
        'content': content,
        'mediaType': 'PHOTO',
        'visibility': 'PUBLIC',
      };

      ApiResponseModel response;

      if (imageFile != null) {
        response = await _apiClient.postMultipart(
          ApiEndpoints.createPost,
          fields: fields,
          fileField: 'media',
          filePath: imageFile.path,
        );
      } else {
        fields['mediaType'] = 'TEXT';
        response = await _apiClient.post(ApiEndpoints.createPost, body: fields);
      }

      if (!response.success) {
        _errorMessage = response.message;
        return false;
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
