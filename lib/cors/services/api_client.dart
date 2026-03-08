import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:abbas/cors/services/token_storage.dart';
import 'package:logger/logger.dart';
final logger = Logger();
class ApiClient {
  final TokenStorage _tokenStorage = TokenStorage();

  ApiClient();

  Future<Map<String, String>> _buildHeaders(Map<String, String>? headers) async {
    final baseHeaders = {"Content-Type": "application/json"};
    final token = await _tokenStorage.getToken();
    if (token != null) baseHeaders['Authorization'] = 'Bearer $token';
    if (headers != null) baseHeaders.addAll(headers);
    return baseHeaders;
  }

  /// Returns dynamic: can be Map or List
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    final builtHeaders = await _buildHeaders(headers);
    final response = await http.get(Uri.parse(url), headers: builtHeaders);
    return _handleResponse(response);
  }

  Future<dynamic> post(String url, {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    final builtHeaders = await _buildHeaders(headers);
    final response = await http.post(
      Uri.parse(url),
      headers: builtHeaders,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : {};
    } else {
      throw Exception('API Error ${response.statusCode}: ${response.body}');
    }
  }
}