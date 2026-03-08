import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

class ApiErrorHandle {
  static String handleError(dynamic error) {
    logger.e("HTTP Error: $error");

    if (error is http.ClientException) {
      // Network-level error
      return 'Network error: ${error.message}';
    } else if (error is SocketException) {
      // No internet connection
      return 'No internet connection. Please check your network.';
    } else if (error is TimeoutException) {
      // Request timeout
      return 'Connection timeout. Please try again.';
    } else if (error is FormatException) {
      // Invalid JSON / response format
      return 'Invalid response format from server.';
    } else if (error is HttpException) {
      // Other HTTP errors
      return 'HTTP error occurred: ${error.message}';
    } else {
      // Unknown error
      return 'Unknown error occurred. Please try again.';
    }
  }
}