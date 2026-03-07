import 'dart:developer';
import 'package:abbas/cors/services/token_storage.dart';

import 'loginModel.dart';
import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/services/api_client.dart';

class LoginRemoteDataSource {
  final ApiClient apiClient;

  LoginRemoteDataSource(this.apiClient);

  final _tokenStorage = TokenStorage();

  Future<LoginModel> login(String email, String password) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      headers: {"Content-Type": "application/json"},
      body: {"email": email, "password": password},
    );

    // ApiClient already decoded JSON into Map<String,dynamic>
    if (response['success'] == true && response['authorization'] != null) {
      final tokenSave = response['authorization']['access_token'];
      log(
        "=============== Save Login $tokenSave==========",
      );

      if(tokenSave != null){
        await _tokenStorage.saveToken(tokenSave);
        log(
          "=============== Save token Login $tokenSave==========",
        );
      }else{
        log(
          "=============== Save token Login failed ==========",
        );
      }


      return LoginModel.fromJson(response);
    } else {
      final message = response['message'] ?? "Login failed";
      throw Exception(message);
    }
  }
}
