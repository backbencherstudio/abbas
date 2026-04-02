import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../network/api_error_handle.dart';
import '../network/api_response_handle.dart';
import '../network/api_response_model.dart';
import 'token_storage.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ApiClient {
  final TokenStorage _tokenStorage = TokenStorage();

  ApiClient();

  /// ================== HEADER ==================
  Future<Map<String, String>> _buildHeaders(
    Map<String, String>? headers,
  ) async {
    final baseHeaders = {"Content-Type": "application/json"};

    final token = await _tokenStorage.getToken(); // Access Token
    if (token != null) baseHeaders['Authorization'] = 'Bearer $token';

    if (headers != null) baseHeaders.addAll(headers);
    return baseHeaders;
  }

  /// ================== REFRESH TOKEN ==================
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();

      if (refreshToken == null) return false;

      final response = await http.post(
        Uri.parse(
          "YOUR_REFRESH_API",
        ), // Replace with your backend refresh endpoint
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refresh_token": refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String newAccess = data["access_token"];
        String newRefresh = data["refresh_token"];

        // Save new tokens
        await _tokenStorage.saveToken(newAccess);
        await _tokenStorage.saveRefreshToken(newRefresh);

        return true;
      } else {
        // Session expired
        await _tokenStorage.clearAllTokens();
        return false;
      }
    } catch (e) {
      logger.e("Refresh token error: $e");
      return false;
    }
  }

  Future<http.Response> _handleRequestWithRetry(
    Future<http.Response> Function() request,
  ) async {
    http.Response response = await request();

    if (response.statusCode == 401) {
      logger.w("Access token expired. Refreshing...");
      final refreshed = await _refreshToken();
      if (refreshed) {
        logger.i("Token refreshed. Retrying request...");
        response = await request();
      } else {
        throw Exception("Session expired. Please login again.");
      }
    }

    return response;
  }

  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      final response = await _handleRequestWithRetry(() async {
        final builtHeaders = await _buildHeaders(headers);
        return await http.get(Uri.parse(url), headers: builtHeaders);
      });

      return ApiResponseHandle.handleResponse(response);
    } catch (e) {
      final message = ApiErrorHandle.handleError(e);
      logger.e(message);
      throw Exception(message);
    }
  }

  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _handleRequestWithRetry(() async {
        final builtHeaders = await _buildHeaders(headers);
        return await http.post(
          Uri.parse(url),
          headers: builtHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      });

      return ApiResponseHandle.handleResponse(response);
    } catch (e) {
      final message = ApiErrorHandle.handleError(e);
      logger.e(message);
      throw Exception(message);
    }
  }

  Future<ApiResponseModel> patch(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _handleRequestWithRetry(() async {
        final builtHeaders = await _buildHeaders(headers);
        return await http.patch(
          Uri.parse(url),
          headers: builtHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      });

      return ApiResponseHandle.handleResponse(response);
    } catch (e) {
      final message = ApiErrorHandle.handleError(e);
      logger.e(message);
      throw Exception(message);
    }
  }

  Future<dynamic> delete(String url, {Map<String, String>? headers}) async {
    try {
      final response = await _handleRequestWithRetry(() async {
        final builtHeaders = await _buildHeaders(headers);
        return await http.delete(Uri.parse(url), headers: builtHeaders);
      });

      return ApiResponseHandle.handleResponse(response);
    } catch (e) {
      final message = ApiErrorHandle.handleError(e);
      logger.e(message);
      throw Exception(message);
    }
  }

  Future<ApiResponseModel> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    required String fileField,
    required String filePath,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final response = await _handleRequestWithRetry(() async {
        var request = http.MultipartRequest('POST', Uri.parse(endpoint));
        final headers = await _buildHeaders(additionalHeaders);
        request.headers.addAll(headers);
        request.fields.addAll(fields);

        if (filePath.isNotEmpty) {
          File file = File(filePath);
          if (await file.exists()) {
            String mimeType = _getMimeType(file.path);
            var multipartFile = await http.MultipartFile.fromPath(
              fileField,
              filePath,
              contentType: http.MediaType.parse(mimeType),
            );
            request.files.add(multipartFile);
          }
        }

        var streamed = await request.send();
        return await http.Response.fromStream(streamed);
      });

      return ApiResponseHandle.handleResponse(response);
    } catch (e) {
      final message = ApiErrorHandle.handleError(e);
      logger.e("Multipart POST error: $message");
      return ApiResponseModel(success: false, message: message, data: null);
    }
  }

  Future<ApiResponseModel> patchMultipart(
    String endpoint, {
    required Map<String, String> fields,
    required String fileField,
    required String filePath,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      final response = await _handleRequestWithRetry(() async {
        var request = http.MultipartRequest('PATCH', Uri.parse(endpoint));
        final headers = await _buildHeaders(additionalHeaders);
        request.headers.addAll(headers);
        request.fields.addAll(fields);

        if (filePath.isNotEmpty) {
          File file = File(filePath);
          if (await file.exists()) {
            String mimeType = _getMimeType(file.path);
            var multipartFile = await http.MultipartFile.fromPath(
              fileField,
              filePath,
              contentType: http.MediaType.parse(mimeType),
            );
            request.files.add(multipartFile);
          }
        }

        var streamed = await request.send();
        return await http.Response.fromStream(streamed);
      });

      return ApiResponseHandle.handleResponse(response);
    } catch (e) {
      final message = ApiErrorHandle.handleError(e);
      logger.e("Multipart PATCH error: $message");
      return ApiResponseModel(success: false, message: message, data: null);
    }
  }

  String _getMimeType(String filePath) {
    String extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }
}
