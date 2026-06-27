import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_response_model.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:flutter/material.dart';

class SupportProvider extends ChangeNotifier {
  final DioClient _dioClient = DioClient();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<ApiResponseModel> submitSupport({
    required String reason,
    required String message,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _dioClient.postHttp(
        ApiEndpoints.profileSupport,
        {
          'resoan': reason,
          'message': message,
        },
      );

      if (res is ResponseModel) {
        return ApiResponseModel(success: false, message: res.message);
      }

      if (res is Map && res['success'] == true) {
        return ApiResponseModel(
          success: true,
          message: res['message']?.toString() ?? 'Support request submitted',
        );
      }

      return ApiResponseModel(
        success: false,
        message: res is Map
            ? (res['message']?.toString() ?? 'Failed to submit support request')
            : 'Failed to submit support request',
      );
    } catch (e) {
      return ApiResponseModel(success: false, message: '$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
