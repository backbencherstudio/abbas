import 'dart:convert';
import 'package:http/http.dart' as http;
import '../network/api_error_handle.dart';
import '../network/api_response_handle.dart';
import 'token_storage.dart';
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

  /// GET request
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      final builtHeaders = await _buildHeaders(headers);
      final response = await http.get(Uri.parse(url), headers: builtHeaders);
      return ApiResponseHandle.handleResponse(response);
    } catch (e) {
      final message = ApiErrorHandle.handleError(e);
      logger.e(message);
      throw Exception(message);
    }
  }

  /// POST request
  Future<dynamic> post(String url, {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    try {
      final builtHeaders = await _buildHeaders(headers);
      final response = await http.post(
        Uri.parse(url),
        headers: builtHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
      return ApiResponseHandle.handleResponse(response);
    } catch (e) {
      final message = ApiErrorHandle.handleError(e);
      logger.e(message);
      throw Exception(message);
    }
  }
}