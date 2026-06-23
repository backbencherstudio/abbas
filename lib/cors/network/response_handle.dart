import 'package:dio/dio.dart';

import '../services/api_client.dart';

class ResponseHandle {
  static dynamic handleResponse(Response response) {
    final code = response.statusCode ?? 0;
    if (code >= 200 && code < 300) {
      logger.i("Response Url : ${response.realUri}");
      logger.i("Response Body : ${response.data}");
      return response.data;
    }
    return null;
  }
}
