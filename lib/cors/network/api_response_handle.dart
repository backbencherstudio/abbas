import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'api_response_model.dart';

final logger = Logger();

class ApiResponseHandle {
  /// Handles http.Response and logs URL and body
  static ApiResponseModel handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final url = response.request?.url.toString() ?? 'Unknown URL';
    dynamic body;

    try {
      body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
    } catch (_) {
      body = response.body;
    }

    logger.i("Response URL: $url");
    logger.i("Response Status: $statusCode");
    logger.i("Response Body: $body");

    /// Check both HTTP status code and the 'success' field in the response body
    bool success = statusCode >= 200 && statusCode < 300;
    if (body is Map<String, dynamic> && body.containsKey('success')) {
      success = body['success'] == true;
    }

    String parseMessage(dynamic msg) {
      if (msg == null) return '';
      if (msg is List) return msg.join(', ');
      return msg.toString();
    }

    if (success) {
      return ApiResponseModel(
        success: true,
        data: body,
        message: body is Map<String, dynamic> && body.containsKey('message')
            ? parseMessage(body['message'])
            : 'Success',
      );
    } else {
      return ApiResponseModel(
        success: false,
        data: body,
        message: body is Map<String, dynamic> && body.containsKey('message')
            ? parseMessage(body['message'])
            : (body is Map<String, dynamic> && body.containsKey('error')
                ? body['error'].toString()
                : 'Error $statusCode'),
      );
    }
  }
}
