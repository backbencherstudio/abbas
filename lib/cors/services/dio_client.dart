import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/error_handle.dart';
import 'package:abbas/cors/network/response_handle.dart';
import 'package:abbas/cors/services/token_storage.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:dio/dio.dart';

import 'api_client.dart';

class DioClient {
  final _tokenStorage = TokenStorage();
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  /// -------------------- Get Http --------------------------------------------
  Future<dynamic> getHttp(String path) async {
    final token = await _tokenStorage.getToken();
    logger.d("================ $token");

    try {
      final response = await _dio.get(
        path,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return ResponseHandle.handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        return ResponseModel(
          success: false,
          message: ErrorHandle.handleError(e),
        );
      } else {
        return ResponseModel(success: false, message: "$e");
      }
    }
  }

  /// -------------------------- Post Http -------------------------------------
  Future<dynamic> postHttp(
    String path,
    Object? data,
  ) async {
    final token = await _tokenStorage.getToken();
    logger.d("\n\n\n\n\n\n\n\n\n\\n\n url ${ ApiEndpoints.baseUrl + path}");
    try {
      final response = await _dio.post(
        path,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json' ,
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return ResponseHandle.handleResponse(response);
    } catch (e) {
      if (e is DioException) {
        return ResponseModel(
          success: false,
          message: ErrorHandle.handleError(e),
        );
      } else {
        return ResponseModel(success: false, message: "$e");
      }
    }
  }
}
