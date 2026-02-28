
import '../../entities/auth/refresh_token_response.dart';
import '../../repositories/auth/refresh_token_repository.dart';

class GetNewAccessToken {
  late final RefreshTokenRepository refreshTokenRepository;

  GetNewAccessToken({required this.refreshTokenRepository});

  Future<RefreshTokenResponse> call(String accessToken) {
    return refreshTokenRepository.getAccessToken(accessToken);
  }
}
