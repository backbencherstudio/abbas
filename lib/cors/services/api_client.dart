
import 'dart:convert';
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

  // Changed return type to Future<dynamic>
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final response = await http.get(Uri.parse(endpoint), headers: _buildHeaders(headers));
    return _processResponse(response, endpoint);
  }

  Future<dynamic> post(String endpoint, {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: _buildHeaders(headers),
      body: body != null ? jsonEncode(body) : null,
    );
    return _processResponse(response, endpoint);
  }

  // The critical fix is here
  dynamic _processResponse(http.Response response, String url) {
    final statusCode = response.statusCode;
    final responseBody = response.body;

    if (statusCode >= 200 && statusCode < 300) {
      if (responseBody.isNotEmpty) {
        // We REMOVED "as Map<String, dynamic>" to allow Lists
        return jsonDecode(responseBody);
      }
      return {};
    } else {
      throw Exception('API Error: $statusCode $responseBody');
    }
  }
}