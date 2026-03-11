import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:flutter_riverpod/legacy.dart';

final signUpScreenProvider =
    StateNotifierProvider<SignUpScreenProvider, ResponseModel>(
      (ref) => SignUpScreenProvider(dioClient: DioClient()),
    );

class SignUpScreenProvider extends StateNotifier<ResponseModel> {
  DioClient dioClient;

  SignUpScreenProvider({required this.dioClient})
    : super(ResponseModel(success: false, message: ''));

  /// -------------------------- Register --------------------------------------
  Future<ResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    var body = {'name': name, 'email': email, 'password': password};

    try {
      final res = await dioClient.postHttp(ApiEndpoints.register, body);
      if (res['success']) {
        return ResponseModel(success: true, message: res['message']);
      } else {
        return ResponseModel(success: false, message: res['message']);
      }
    } catch (e) {
      return ResponseModel(success: false, message: '$e');
    }
  }

  /// ----------------- Forgot Password ----------------------------------------
  Future<ResponseModel> forgotPassword({required String email}) async {
    var body = {'email': email};
    try {
      final res = await dioClient.postHttp(ApiEndpoints.changePassword, body);
      if (res['success']) {
        return ResponseModel(success: true, message: res['message']);
      } else {
        return ResponseModel(success: false, message: res['message']);
      }
    } catch (e) {
      return ResponseModel(success: false, message: '$e');
    }
  }

  /// -------------------- Verify Otp ------------------------------------------
  Future<ResponseModel> verifyOtp({
    required String email,
    required String otp,
  }) async {
    var body = {'email': email, 'otp': otp};
    try {
      final res = await dioClient.postHttp(ApiEndpoints.verifyEmail, body);
      if (res['success']) {
        return ResponseModel(success: true, message: res['message']);
      } else {
        return ResponseModel(success: false, message: res['message']);
      }
    } catch (e) {
      return ResponseModel(success: false, message: '$e');
    }
  }
}
