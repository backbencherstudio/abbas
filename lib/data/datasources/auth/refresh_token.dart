

import '../../../cors/constants/api_endpoints.dart';
import '../../../cors/services/api_services.dart';
import '../../../domain/entities/auth/refresh_token_response.dart';
import '../../models/auth/refresh_token_response_model.dart';

abstract class RefreshTokenDataSource {
  Future<RefreshTokenResponse> getNewAccessToken(String refreshToken);
}

class RefreshTokenDataSourceImpl implements RefreshTokenDataSource {
  late final ApiService _apiService;

  RefreshTokenDataSourceImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<RefreshTokenResponse> getNewAccessToken(String refreshToken) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RefreshTokenResponseModel.fromJson(response.data);
      } else {
        throw Exception('Server Error');
      }
    } catch (e) {
      throw Exception('Server Error');
    }
  }
}
