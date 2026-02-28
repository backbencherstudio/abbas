import 'package:dio/dio.dart';
import '../../../../data/models/profile/profile_edit_response/profile_edit_response.dart';

class UserApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://similarly-widely-refer-cigarettes.trycloudflare.com/api",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  Future<UserResponse> getUserProfile() async {
    try {
      final response = await _dio.get("/api/auth/me");

      if (response.statusCode == 200) {
        return UserResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to load profile. Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching profile: $e");
    }
  }
}
