import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../../../domain/usecases/auth/send_otp.dart';
import '../../../../domain/usecases/auth/verify_otp.dart';

class OtpVerifyViewmodel extends ChangeNotifier {
  final SendOTPUseCase sendOTPUseCase;
  final VerifyOTPUseCase verifyOTPUseCase;

  Timer? _resendTimer;
  int _resendCountdown = 0;

  OtpVerifyViewmodel({
    required this.sendOTPUseCase,
    required this.verifyOTPUseCase,
  });

  String _otp = '';

  String get otp => _otp;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _otpVerified = false;

  bool get otpVerified => _otpVerified;

  int get resendCountdown => _resendCountdown;

  bool get canResend => _resendCountdown == 0;

  bool _hasError = false;

  bool get hasError => _hasError;

  bool get isButtonEnable => _otp.length == 4 && !_hasError && !_isLoading;

  void setOtp(String value) {
    _otp = value;
    if (_hasError && value.isNotEmpty) {
      _hasError = false;
      _errorMessage = null;
    }
    notifyListeners();
  }

  void clearError() {
    _hasError = false;
    _errorMessage = null;
    notifyListeners();
  }

  void startResendTimer() {
    _resendCountdown = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        _resendCountdown--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> verifyOTP(String email, String otp) async {
    if (!isButtonEnable) return;

    _isLoading = true;
    _errorMessage = null;
    _hasError = false;
    _otpVerified = false;
    notifyListeners();

    final result = await verifyOTPUseCase.execute(email, otp);

    result.fold(
      (error) {
        _errorMessage = error;
        _hasError = true;
        _isLoading = false;

        _otpVerified = false;
        notifyListeners();
      },
      (success) {
        _otpVerified = success.success;
        _isLoading = false;
        if (success.success) {
          _errorMessage = null;
          _hasError = false;
        } else {
          _errorMessage = 'Invalid OTP code';
          _hasError = true;
        }
        notifyListeners();
      },
    );
  }

  Future<void> resendOTP(String email) async {
    if (!canResend) return;

    _isLoading = true;
    _errorMessage = null;
    _hasError = false;
    notifyListeners();

    final result = await sendOTPUseCase.execute(email);

    result.fold(
      (error) {
        _errorMessage = error;
        _hasError = true;
        _isLoading = false;
        notifyListeners();
      },
      (success) {
        _isLoading = false;
        if (success.success) {
          _errorMessage = null;
          _hasError = false;
          _otp = '';
          startResendTimer();
        } else {
          _errorMessage = 'Failed to resend OTP';
          _hasError = true;
        }
        notifyListeners();
      },
    );
  }

  void reset() {
    _otp = '';
    _errorMessage = null;
    _hasError = false;
    _isLoading = false;
    _otpVerified = false;
    _resendTimer?.cancel();
    _resendCountdown = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}
