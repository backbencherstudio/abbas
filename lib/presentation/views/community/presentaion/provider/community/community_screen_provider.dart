import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../../../../../cors/constants/api_endpoints.dart';
import '../../../../../../cors/network/api_response_model.dart';
import '../../../../../../cors/services/api_client.dart';
import '../../../domain/community/community_entity.dart';
import '../../../domain/community/community_usecase.dart';

class CommunityScreenProvider extends ChangeNotifier {
  final GetCommunityFeedUseCase getCommunityFeedsUseCase;

  CommunityScreenProvider({required this.getCommunityFeedsUseCase});

  List<CommunityEntity> _feeds = [];
  List<CommunityEntity> get feeds => _feeds;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

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

  final ApiClient _apiClient = ApiClient();
  final Logger logger = Logger();

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<void> createPost() async {
    logger.i("========== PROFILE API START ==========");

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponseModel response = await _apiClient.get(
        ApiEndpoints.createPost,
      );

      logger.i("API Success Status: ${response.success}");
      logger.i("API Message: ${response.message}");
      logger.d("Raw API Data: ${response.data}");

      if (response.success) {
        logger.i("Profile Parsed Successfully");
        logger.d("User ID: ");
        logger.d("User Email:");
      } else {
        _errorMessage = response.message;
        logger.e("API Returned Error: $_errorMessage");
      }
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      logger.e("Exception Occurred");
      logger.e(e);
      logger.e(stackTrace);
    }

    _isLoading = false;
    notifyListeners();

    logger.i("========== PROFILE API END ==========");
  }


  Future<void> getOtherProfile(String userId)async{
    _errorMessage =null;
    _isLoading=true;
    notifyListeners();
    try{
      ApiResponseModel response = await _apiClient.get(ApiEndpoints.getOtherProfile(userId));
      logger.i("API Success Status: ${response.success}");
      logger.i("API Message: ${response.message}");
      logger.d("Raw API Data: ${response.data}");
      if(response.success){

      }
    }catch(e, stackTrace){
      _errorMessage = e.toString();

      logger.e("Exception Occurred");
      logger.e(e);
      logger.e(stackTrace);

    }



  }

}
