import 'package:dio/dio.dart';
import '../constants/api_endpoints.dart';
import '../services/token_storage.dart';

class Network {
  static final Network _instance = Network._internal();
  factory Network() => _instance;
  late Dio dio;

  Network._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // Remove Authorization from here
      },
    );

    dio = Dio(options);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenStorage().getToken();
        print('Injected Token: $token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));

    // For debug logging
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
    ));
  }

}