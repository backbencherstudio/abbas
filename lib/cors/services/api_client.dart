import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final Map<String, String> defaultHeaders;
  final String? token;

  ApiClient({this.token, this.defaultHeaders = const {"Content-Type": "application/json"}});

  Map<String, String> _buildHeaders(Map<String, String>? headers) {
    final allHeaders = {...defaultHeaders, ...?headers};
    if (token != null) {
      allHeaders['Authorization'] = 'Bearer $token';
    }
    return allHeaders;
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      if (kDebugMode) print('[API GET] URL: $endpoint');
      final response = await http.get(Uri.parse(endpoint), headers: _buildHeaders(headers));
      return _processResponse(response, endpoint);
    } catch (e) {
      if (kDebugMode) print('[API GET ERROR] $e');
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    try {
      if (kDebugMode) print('[API POST] URL: $endpoint, BODY: ${jsonEncode(body)}');
      final response = await http.post(
        Uri.parse(endpoint),
        headers: _buildHeaders(headers),
        body: body != null ? jsonEncode(body) : null,
      );
      return _processResponse(response, endpoint);
    } catch (e) {
      if (kDebugMode) print('[API POST ERROR] $e');
      rethrow;
    }
  }

  dynamic _processResponse(http.Response response, String url) {
    final statusCode = response.statusCode;
    final responseBody = response.body;

    if (kDebugMode) {
      print('[API RESPONSE] URL: $url, Status: $statusCode, Body: $responseBody');
    }

    if (statusCode >= 200 && statusCode < 300) {
      if (responseBody.isNotEmpty) {
        try {
          return jsonDecode(responseBody);
        } catch (e) {
          if (kDebugMode) print('[JSON DECODE ERROR] $e');
          throw Exception('Invalid JSON from $url');
        }
      }
      return {};
    } else {
      throw Exception('API Error: $statusCode ${responseBody.isNotEmpty ? responseBody : "No Body"}');
    }
  }
}