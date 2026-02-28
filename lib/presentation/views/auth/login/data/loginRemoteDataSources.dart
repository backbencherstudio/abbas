import 'dart:convert';
import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/services/api_client.dart';
import 'package:http/http.dart' as http;
import 'loginModel.dart';

class LoginRemoteDataSource {
  final ApiClient apiClient;

  LoginRemoteDataSource(this.apiClient);

  @override
  Future<LoginModel> login(String email, String password) async {
    final response = await apiClient.post(ApiEndpoints.login,
      headers: {"Content-Type": "application/json"},
      body: {"email": email, "password": password},
    );

    if (response.statusCode == 200) {
      return LoginModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Login failed");
    }
  }
}