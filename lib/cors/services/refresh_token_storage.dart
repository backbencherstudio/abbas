import 'package:shared_preferences/shared_preferences.dart';

class RefreshTokenStorage {
  static const _key = "refresh_token";

  Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  Future<void> clearRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}