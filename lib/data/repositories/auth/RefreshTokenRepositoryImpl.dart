import '../../../domain/entities/auth/refresh_token_response.dart';
import '../../../domain/repositories/auth/refresh_token_repository.dart';
import '../../datasources/auth/refresh_token.dart';

class RefreshTokenRepositoryImpl implements RefreshTokenRepository {
  late final RefreshTokenDataSource refreshTokenDataSource;

  RefreshTokenRepositoryImpl({required this.refreshTokenDataSource});

  @override
  Future<RefreshTokenResponse> getAccessToken(String refreshToken) async {
    try {
      final newAccessToken = await refreshTokenDataSource.getNewAccessToken(
        refreshToken,
      );
      return newAccessToken;
    } catch (e) {
      rethrow;
    }
  }
}
