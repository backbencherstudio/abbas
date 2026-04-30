import 'dart:developer';
import 'package:abbas/cors/services/token_storage.dart';
import '../../../../../cors/network/api_response_model.dart';
import 'loginModel.dart';
import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/services/api_client.dart';
class LoginRemoteDataSource {
  final ApiClient apiClient;

  LoginRemoteDataSource(this.apiClient);

  final _tokenStorage = TokenStorage();

  Future<LoginModel> login(String email, String password) async {
    try {
      final ApiResponseModel response = await apiClient.post(
        ApiEndpoints.login,
        headers: {"Content-Type": "application/json"},
        body: {"email": email, "password": password},
      );

      if (response.success && response.data != null) {
        final data = response.data;

        final tokenSave = data['authorization']?['refresh_token'];
        if (tokenSave != null) {
          SocketCall().connect(tokenSave);

          await _tokenStorage.saveToken(tokenSave);
          log("========= Login Token Saved: $tokenSave");
        } else {
          log("========= Save token failed ==========");
        }

        return LoginModel.fromJson(data as Map<String, dynamic>);
      } else {
        final message = response.message.isNotEmpty ? response.message : "Login failed";
        throw Exception(message);
      }
    } catch (e) {
      log("LoginRemoteDataSource Error: $e");
      rethrow;
    }
  }
}