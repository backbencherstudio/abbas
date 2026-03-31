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

  Future<Map<String, String>> _buildHeaders(
    Map<String, String>? headers,
  ) async {
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
  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
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

  Future<ApiResponseModel> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    required String fileField,
    required String filePath,
    Map<String, String>? additionalHeaders,
  }) async {
    try {
      var uri = Uri.parse(endpoint);
      var request = http.MultipartRequest('POST', uri);

      final builtHeaders = await _buildHeaders(additionalHeaders);
      request.headers.addAll(builtHeaders);

      // Add text fields
      request.fields.addAll(fields);

      // Add file if exists
      if (filePath.isNotEmpty) {
        File file = File(filePath);
        if (await file.exists()) {
          // Determine MIME type based on file extension
          String mimeType = _getMimeType(file.path);

          var multipartFile = await http.MultipartFile.fromPath(
            fileField,
            filePath,
            contentType: http.MediaType.parse(mimeType),
          );
          request.files.add(multipartFile);
        } else {
          logger.w('File not found at path: $filePath');
          return ApiResponseModel(
            success: false,
            message: 'File not found',
            data: null,
          );
        }
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Use the existing handleResponse method for consistent response handling
      return ApiResponseHandle.handleResponse(response);
    } catch (e) {
      final message = ApiErrorHandle.handleError(e);
      logger.e('Multipart request error: $message');
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
      var uri = Uri.parse(endpoint);
      var request = http.MultipartRequest('PATCH', uri);

      final builtHeaders = await _buildHeaders(additionalHeaders);
      request.headers.addAll(builtHeaders);

      // Add text fields
      request.fields.addAll(fields);

      // Add file if exists
      if (filePath.isNotEmpty) {
        File file = File(filePath);
        if (await file.exists()) {
          // Determine MIME type based on file extension
          String mimeType = _getMimeType(file.path);

          var multipartFile = await http.MultipartFile.fromPath(
            fileField,
            filePath,
            contentType: http.MediaType.parse(mimeType),
          );
          request.files.add(multipartFile);
        } else {
          logger.w('File not found at path: $filePath');
          return ApiResponseModel(
            success: false,
            message: 'File not found',
            data: null,
          );
        }
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Use the existing handleResponse method for consistent response handling
      return ApiResponseHandle.handleResponse(response);
    } catch (e) {
      final message = ApiErrorHandle.handleError(e);
      logger.e('Multipart request error: $message');
      return ApiResponseModel(success: false, message: message, data: null);
    }
  }

  /// ----------------------- patch without file --------------------------------------
  Future<ApiResponseModel> patch(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final builtHeaders = await _buildHeaders(headers);
      final response = await http.patch(
        Uri.parse(endpoint),
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

  /// ------------------- Delete --------------------------------------
  Future<dynamic> delete(String url, {Map<String, String>? headers}) async {
    try {
      final builtHeaders = await _buildHeaders(headers);
      final response = await http.delete(Uri.parse(url), headers: builtHeaders);
      return ApiResponseHandle.handleResponse(response);
    } catch (e) {
      final message = ApiErrorHandle.handleError(e);
      logger.e(message);
      throw Exception(message);
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
      case 'gif':
        return 'image/gif';
      case 'mp4':
        return 'video/mp4';
      case 'mp3':
        return 'audio/mpeg';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }
}
