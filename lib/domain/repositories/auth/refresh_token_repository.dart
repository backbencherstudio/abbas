import '../../entities/auth/refresh_token_response.dart';

abstract class RefreshTokenRepository{
  Future<RefreshTokenResponse> getAccessToken(String refreshToken);
}