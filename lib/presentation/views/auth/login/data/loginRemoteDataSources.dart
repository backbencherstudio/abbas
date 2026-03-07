import 'dart:developer';
import 'loginModel.dart';
import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/services/api_client.dart';

class LoginRemoteDataSource {
  final ApiClient apiClient;

  LoginRemoteDataSource(this.apiClient);

  Future<LoginModel> login(String email, String password) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      headers: {"Content-Type": "application/json"},
      body: {"email": email, "password": password},
    );

    // ApiClient already decoded JSON into Map<String,dynamic>
    if (response['success'] == true && response['authorization'] != null) {
      log("===========Login success=============");
      return LoginModel.fromJson(response);
    } else {
      log("============Login failed============");
      final message = response['message'] ?? "Login failed";
      throw Exception(message);
    }
  }
}