import 'package:abbas/cors/services/api_client.dart';
import 'package:dio/dio.dart';

class ErrorHandle {
  static String handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.badCertificate:
        logger.e("Error : ${e.message}");
        return "Bad Certificate. Please try again";

      case DioExceptionType.badResponse:
        logger.e("BadResponse : ${e.message}");
        if (e.response != null) {
          logger.e("Status Code : ${e.response?.statusCode}");
          logger.e("Response Data : ${e.response?.data}");
        }

        if (e.response != null && e.response?.data != null) {
          final data = e.response?.data;
          if (data is Map<String, dynamic> && data['message'] != null) {
            return data['message'].toString();
          }
          return "Server Error : ${e.response?.statusCode}";
        }
        return "Server error : ${e.message}";

      case DioExceptionType.cancel:
        logger.e("Error : ${e.message}");
        return "Request was cancelled";

      case DioExceptionType.connectionError:
        logger.e("Error : ${e.message}");
        return "Connection error. Please check your internet";
      case DioExceptionType.connectionTimeout:
        logger.e("Error : ${e.message}");
        return "Connection timeout. Please try again";
      case DioExceptionType.sendTimeout:
        logger.e("Error : ${e.message}");
        return "Send timeout. Please try again";
      case DioExceptionType.receiveTimeout:
        logger.e("Error : ${e.message}");
        return "Receive timeout. Please try again";
      case DioExceptionType.unknown:
        logger.e("Error : ${e.message}");
        return "Unknown error occurred. Please try again";
    }
  }
}
