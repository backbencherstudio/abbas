import 'package:dio/dio.dart';

import '../../../../cors/constants/api_endpoints.dart';
import '../../../../cors/services/api_services.dart';
import '../../models/auth/set_new_password_response_model.dart';

abstract class SetNewPasswordDataSource {
  Future<SetNewPasswordResponseModel> setNewPassword(
      String email,
      String otp,
      String newPassword,
      );
}

class SetPasswordDataSourceImpl implements SetNewPasswordDataSource {
  final ApiService apiService;

  SetPasswordDataSourceImpl({required this.apiService});

  @override
  Future<SetNewPasswordResponseModel> setNewPassword(
      String email,
      String otp,
      String newPassword,
      ) async {
    try {
      final response = await apiService.post(
        ApiEndpoints.resetPassword,
        data: {'email': email, 'otp': otp, 'new_password': newPassword},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SetNewPasswordResponseModel.fromJson(response.data);
      } else {
        final errorData = response.data ?? {};
        String errorMessage;

        switch (response.statusCode) {
          case 401:
            errorMessage = errorData['message'] ?? 'OTP verification failed or expired. Please request a new OTP.';
            break;
          case 400:
            errorMessage = errorData['message'] ?? 'Invalid request. Please check your input.';
            break;
          case 404:
            errorMessage = errorData['message'] ?? 'User not found.';
            break;
          default:
            errorMessage = errorData['message'] ?? 'Failed to reset password. Please try again.';
        }
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data ?? {};
        final errorMessage = errorData['message'] ?? e.response!.statusMessage ?? 'Failed to reset password. Please try again.';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }
}