import 'package:dio/dio.dart';

import '../../../cors/constants/api_endpoints.dart';
import '../../../cors/services/api_services.dart';
import '../../models/auth/register_response_model.dart';


abstract class RegisterDataSource {
  Future<RegisterResponseModel> register(String email, String password);
}

class RegisterDataSourceImpl implements RegisterDataSource {
  final ApiService _apiService;

  RegisterDataSourceImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<RegisterResponseModel> register(String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
        },
      );

      // Check status code for success (200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponseModel.fromJson(response.data);
      }
      // Handle conflict (409) - email already exists
      else if (response.statusCode == 409) {
        final errorMessage = response.data['message'] ?? 'Email already exists';
        throw Exception(errorMessage);
      }
      // Handle other error status codes
      else {
        final errorMessage = response.data['message'] ?? 'Registration failed';
        throw Exception('Registration failed with status code: ${response.statusCode}. $errorMessage');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Handle Dio errors with response
        final statusCode = e.response!.statusCode;
        final errorMessage = e.response!.data['message'] ?? 'Registration failed';

        if (statusCode == 409) {
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
}