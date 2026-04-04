import 'dart:async';
import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/cors/services/socket_call.dart';
import 'package:abbas/cors/services/token_storage.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/auth/model/auth_model.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../cors/services/user_id_storage.dart';


final authProvider = StateNotifierProvider<AuthProvider, AuthModel>(
  (ref) => AuthProvider(dioClient: DioClient()),
);

/// -------------------- Otp Text Provider -------------------------------------
final otpTextProvider = StateProvider<String>((ref) => '');

class AuthProvider extends StateNotifier<AuthModel> {
  DioClient dioClient;

  AuthProvider({required this.dioClient}) : super(AuthModel());

  /// -------------------- Toggle Password Visibility --------------------------
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
    logger.d("Toggle Password Visibility : ${state.isPasswordVisible}");
  }

  /// -------------------- Toggle Confirm Password Visibility ------------------
  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }

  /// --------------------- Check Is Loading -----------------------------------
  Future<void> checkIsLoading() async {
    state = state.copyWith(isLoading: !state.isLoading);
    logger.d("Loading : ${state.isLoading}");
  }

  /// ----------------------- Page Loading -------------------------------------
  void setIsPageLoading() {
    state = state.copyWith(isPageLoading: !state.isPageLoading);
  }

  final _tokenStorage = TokenStorage();
  final _userIdStorage = UserIdStorage();

  /// -------------------------- Register --------------------------------------
  Future<ResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    var body = {'name': name, 'email': email, 'password': password};

    logger.d("Body : $body");
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

  /// ------------------------- Login ------------------------------------------
  Future<ResponseModel> login({
    required String email,
    required String password,
  }) async {
    var body = {'email': email, 'password': password};
    try {
      final res = await dioClient.postHttp(ApiEndpoints.login, body);
      if (res['success']) {
        final token = res['authorization']['access_token'];
        final refreshToken = res['authorization']['refresh_token'];
        final userId = res['userId'];
        if (token != null) {
          SocketCall().connect(token);
          await _tokenStorage.saveRefreshToken(refreshToken);
          await _tokenStorage.saveToken(token);
        }
        if (userId != null) {
          await _userIdStorage.saveUserId(userId);
        }
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
      final res = await dioClient.postHttp(ApiEndpoints.forgotPassword, body);
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

  /// ----------------------- Resend Verification ------------------------------
  Future<ResponseModel> resendVerification({required String email}) async {
    var body = {'email': email};
    try {
      final res = await dioClient.postHttp(
        ApiEndpoints.resendVerification,
        body,
      );
      if (res['success']) {
        return ResponseModel(success: true, message: res['message']);
      } else {
        return ResponseModel(success: false, message: res['message']);
      }
    } catch (e) {
      return ResponseModel(success: false, message: '$e');
    }
  }

  /// ----------------------- Reset password -----------------------------------
  Future<ResponseModel> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    var body = {'email': email, 'otp': otp, 'new_password': newPassword};
    try {
      final res = await dioClient.postHttp(ApiEndpoints.resetPassword, body);
      if (res['success']) {
        return ResponseModel(success: true, message: res['message']);
      } else {
        return ResponseModel(success: false, message: res['message']);
      }
    } catch (e) {
      return ResponseModel(success: false, message: '$e');
    }
  }

  /// ----------------------- Change Password ----------------------------------
  Future<ResponseModel> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    var body = {
      'email': email,
      'old_password': oldPassword,
      'new_password': newPassword,
    };
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

  /// ------------------------ Change email ------------------------------------
  Future<ResponseModel> changeEmail({
    required String email,
    required String token,
  }) async {
    var body = {'email': email, 'token': token};
    try {
      final res = await dioClient.postHttp(ApiEndpoints.changeEmail, body);
      if (res['success']) {
        return ResponseModel(success: true, message: res['message']);
      } else {
        return ResponseModel(success: false, message: res['message']);
      }
    } catch (e) {
      return ResponseModel(success: false, message: '$e');
    }
  }

  /// ---------------------- Request Change Email ------------------------------
  Future<ResponseModel> requestChangeEmail({required String email}) async {
    var body = {'email': email};
    try {
      final res = await dioClient.postHttp(
        ApiEndpoints.requestChangeEmail,
        body,
      );
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

/// ------------------------- Time Provider ------------------------------------
final timeProvider = StateNotifierProvider<TimeNotifier, int>(
  (ref) => TimeNotifier(),
);

class TimeNotifier extends StateNotifier<int> {
  TimeNotifier() : super(20);
  Timer? _timer;

  /// Start the timer
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        state = state - 1;
      } else {
        timer.cancel();
      }
    });
  }

  /// Restart Timer
  void restart() {
    state = 20;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    // Convert seconds to minutes and seconds
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
