import 'package:dio/dio.dart';

import '../../../../cors/constants/api_endpoints.dart';
import '../../../../cors/services/api_services.dart';
import '../../../cors/services/token_storage.dart';
import '../../models/profile/edit_personal_info_response_model.dart';

abstract class EditPersonalInfoDataSource {
  Future<EditPersonalInfoResponseModel> updatePersonalInfo(
    String name,
    String phoneNumber,
    String dateOfBirth,
    String experienceLevels,
    String actingGoals,
  );


}

class EditPersonalInfoDataSourceImpl implements EditPersonalInfoDataSource {
  final ApiService apiService;
  final TokenStorage tokenStorage;

  EditPersonalInfoDataSourceImpl({
    required this.apiService,
    required this.tokenStorage,
  });

  @override
  Future<EditPersonalInfoResponseModel> updatePersonalInfo(
    String name,
    String phoneNumber,
    String dateOfBirth,
      String experienceLevels,
    String actingGoals,
  ) async {
    try {
      final token = await tokenStorage.getToken();

      // Create headers manually since your ApiService.put doesn't accept options
      final Map<String, dynamic> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await apiService.patch(
        ApiEndpoints.updateProfile,
        data: {
          'name': name,
          'phone_number': phoneNumber,
          'date_of_birth': dateOfBirth,
          'experience_levels': experienceLevels,
          'acting_goals': actingGoals,
        },
      );

      // Manually check status code since validateStatus isn't available
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return EditPersonalInfoResponseModel.fromJson(response.data);
      } else {
        final errorData = response.data ?? {};
        final errorMessage =
            errorData['message'] ?? 'Failed to update personal info';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response!.data ?? {};
        final errorMessage =
            errorData['message'] ??
            e.response!.statusMessage ??
            'Failed to update personal info';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to update personal info: $e');
    }
  }


}


