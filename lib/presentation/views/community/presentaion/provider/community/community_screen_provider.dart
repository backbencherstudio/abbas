import 'dart:io';
import 'package:abbas/presentation/views/community/model/get_post_like_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../../../../../cors/constants/api_endpoints.dart';
import '../../../../../../cors/network/api_response_model.dart';
import '../../../../../../cors/services/api_client.dart';
import '../../../../../../cors/services/token_storage.dart';
import '../../../domain/community/community_entity.dart';
import '../../../domain/community/community_usecase.dart';

class CommunityScreenProvider extends ChangeNotifier {
  final GetCommunityFeedUseCase getCommunityFeedsUseCase;

  CommunityScreenProvider({required this.getCommunityFeedsUseCase});

  List<CommunityEntity> _feeds = [];

  List<CommunityEntity> get feeds => _feeds;

  /// ---------------- Get Post Like Model -------------------------------------
  GetPostLikeModel? _getPostLikeModel;

  GetPostLikeModel? get getPostLikeModel => _getPostLikeModel;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  final ApiClient _apiClient = ApiClient();
  final Logger logger = Logger();
  final TokenStorage _tokenStorage = TokenStorage();

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  /// ----------------- Fetch Feeds --------------------------------------------
  Future<void> fetchFeeds() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await getCommunityFeedsUseCase();
      _feeds = result;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ------------------- Create Post -----------------------------------------
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

  /// ------------------ Create Post Like --------------------------------------

  Future<ApiResponseModel> createPostLike(String postId) async {
    var body = {'postId': postId};
    try {
      final response = await _apiClient.post(
        ApiEndpoints.createPostLike,
        body: body,
      );
      if (response['success']) {
        logger.d(response['message']);
        return ApiResponseModel(success: true, message: response['message']);
      } else {
        return ApiResponseModel(success: false, message: response['message']);
      }
    } catch (e) {
      return ApiResponseModel(success: false, message: e.toString());
    }
  }

  /// ------------------- Get Post Like ---------------------------------------
  Future<void> getPostLike(String postId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.getPostLike);
      if (response) {
        _getPostLikeModel = GetPostLikeModel.fromJson(response);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
    }
  }
}
