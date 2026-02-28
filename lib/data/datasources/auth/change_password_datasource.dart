import 'package:dio/dio.dart';

import '../../../../cors/constants/api_endpoints.dart';
import '../../../../cors/services/api_services.dart';
import '../../models/auth/change_password_response_model.dart';

abstract class ChangePasswordDataSource {
  Future<ChangePasswordResponseModel> changePassword(
      String email,
      String oldPassword,
      String newPassword,
      );
}

class ChangePasswordDataSourceImpl implements ChangePasswordDataSource {
  final ApiService apiService;

  ChangePasswordDataSourceImpl({required this.apiService});

  @override
  Future<ChangePasswordResponseModel> changePassword(
      String email,
      String oldPassword,
      String newPassword,
      ) async {
    try {
      final response = await apiService.post(
        ApiEndpoints.changePassword,
        data: {
          'email': email,
          'old_password': oldPassword,
          'new_password': newPassword,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChangePasswordResponseModel.fromJson(response.data);
      } else {
        final errorData = response.data ?? {};
        final errorMessage = errorData['message'] ?? 'Failed to change password';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data ?? {};
        final errorMessage = errorData['message'] ?? e.response!.statusMessage ?? 'Failed to change password';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }
}