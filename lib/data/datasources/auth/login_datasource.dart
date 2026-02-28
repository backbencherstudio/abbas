import 'package:dio/dio.dart';

import '../../../cors/constants/api_endpoints.dart';
import '../../../cors/services/api_services.dart';
import '../../models/auth/login_response_model.dart';


abstract class LoginDataSource {
  Future<LoginResponseModel> login(String email, String password);
}

class LoginDataSourceImpl implements LoginDataSource {
  final ApiService _apiService;

  LoginDataSourceImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<LoginResponseModel> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      // Check status code for success (200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponseModel.fromJson(response.data);
      }
      // Handle unauthorized (401)
      else if (response.statusCode == 401) {
        final errorMessage = _extractErrorMessage(response.data);
        throw Exception(errorMessage);
      }
      // Handle other error status codes
      else {
        final errorMessage = _extractErrorMessage(response.data);
        throw Exception('Login failed with status code: ${response.statusCode}. $errorMessage');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle Dio errors with response
        final statusCode = e.response!.statusCode;
        final errorMessage = _extractErrorMessage(e.response!.data);

        if (statusCode == 401) {
          throw Exception(errorMessage);
        } else {
          throw Exception('Server error ($statusCode): $errorMessage');
        }
      } else {
        // Handle network errors
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to extract error message from response
  String _extractErrorMessage(dynamic responseData) {
    if (responseData is Map) {
      if (responseData.containsKey('message')) {
        if (responseData['message'] is Map) {
          return responseData['message']['message'] ?? 'Unauthorized access';
        } else if (responseData['message'] is String) {
          return responseData['message'];
        }
      }
      return responseData.toString();
    }
    return 'Unknown error occurred';
  }
}