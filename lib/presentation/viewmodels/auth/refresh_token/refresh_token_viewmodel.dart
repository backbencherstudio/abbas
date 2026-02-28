import 'package:flutter/material.dart';
import '../../../../cors/services/refresh_token_storage.dart';
import '../../../../cors/services/token_storage.dart';
import '../../../../domain/entities/auth/refresh_token_response.dart';
import '../../../../domain/usecases/auth/get_new_accesstoken.dart';

class RefreshTokenViewModel extends ChangeNotifier {
  final GetNewAccessToken getNewAccessToken;
  final RefreshTokenStorage refreshTokenStorage;
  final TokenStorage tokenStorage;

  // State variables
  bool isLoading = false;
  String? errorMessage;
  RefreshTokenResponse? refreshTokenResponse;

  RefreshTokenViewModel({
    required this.getNewAccessToken,
    required this.refreshTokenStorage,
    required this.tokenStorage,
  });

  // Fetch the new access token
  Future<void> fetchNewAccessToken() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Get the refresh token from storage
      String? refreshToken = await refreshTokenStorage.getRefreshToken();
      if (refreshToken == null) {
        throw Exception("No refresh token found");
      }

      // Call the use case to get a new access token
      refreshTokenResponse = await getNewAccessToken(refreshToken);

      debugPrint("New AccessToken ${refreshTokenResponse?.authorization?.accessToken}");

      // Save the new access token to storage
      if (refreshTokenResponse?.authorization?.accessToken != null) {
        await tokenStorage.saveToken(refreshTokenResponse!.authorization!.accessToken!);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to get new access token: $e";
      notifyListeners();
    }
  }
}
