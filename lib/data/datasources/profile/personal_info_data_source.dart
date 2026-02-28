import 'package:dio/dio.dart';
import '../../../cors/constants/api_endpoints.dart';
import '../../../cors/services/api_services.dart';
import '../../../cors/services/token_storage.dart';

abstract class PersonalInfoDataSource {
  Future<Map<String, dynamic>> getPersonalInfo();
}

class PersonalInfoDataSourceImpl implements PersonalInfoDataSource {
  final ApiService apiService;
  final TokenStorage tokenStorage;

  PersonalInfoDataSourceImpl({
    required this.apiService,
    required this.tokenStorage,
  });

  @override
  Future<Map<String, dynamic>> getPersonalInfo() async {
    try {
      final token = await tokenStorage.getToken();

      final response = await apiService.get(
        ApiEndpoints.getProfile,
      );

      print('API Response Status: ${response.statusCode}');
      print('API Response Data: ${response.data}');

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        // ADD THIS CHECK HERE:
        if (response.data['success'] == true) {
          return response.data['data']; // Return the nested 'data' object
        } else {
          final errorMessage = response.data['message'] ?? 'API request was not successful';
          throw Exception(errorMessage);
        }
      } else {
        final errorData = response.data ?? {};
        final errorMessage = errorData['message'] ?? 'Failed to fetch personal info';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data ?? {};
        final errorMessage = errorData['message'] ??
            e.response!.statusMessage ??
            'Failed to fetch personal info';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch personal info: $e');
    }
  }
}