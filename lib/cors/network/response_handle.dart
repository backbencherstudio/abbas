import 'package:dio/dio.dart';

import '../services/api_client.dart';

class ResponseHandle {
  static dynamic handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      logger.i("Response Url : ${response.realUri}");
      logger.i("Response Body : ${response.data}");
      return response.data;
    }
  }
}
