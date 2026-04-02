import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _key = "token";
  static const _refreshKey = "refresh_token";
  /// ================= Get access Token =================

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }
  /// ================= Get access Token =================

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
  /// ================= Get access Token =================

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshKey, token);
  }

  /// ================= Get Refresh Token =================
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshKey);
  }

  /// ================= Clear Refresh Token =================
  Future<void> clearRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refreshKey);
  }

  /// ================= Clear Both Tokens =================
  Future<void> clearAllTokens() async {
    await clearToken();
    await clearRefreshToken();
  }
}