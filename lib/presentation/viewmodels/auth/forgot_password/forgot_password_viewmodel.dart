import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';

import '../../../../domain/repositories/auth/otp_repository.dart';



class ForgotPasswordViewModel with ChangeNotifier {
  final OTPRepository repository;

  // Remove GetIt from here and use constructor injection
  ForgotPasswordViewModel({required this.repository});

  String _email = '';
  String get email => _email;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _otpSent = false;
  bool get otpSent => _otpSent;

  bool get isButtonEnable => _email.isNotEmpty;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  Future<void> sendOTP() async {
    _isLoading = true;
    _errorMessage = null;
    _otpSent = false;
    notifyListeners();

    final result = await repository.sendOTP(_email);

    result.fold(
          (error) {
        _errorMessage = error;
        _isLoading = false;
        _otpSent = false;
      },
          (success) {
        _otpSent = success.success;
        _isLoading = false;
        if (success.success) {
          _errorMessage = null;
        }
      },
    );

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void reset() {
    _email = '';
    _errorMessage = null;
    _isLoading = false;
    _otpSent = false;
    notifyListeners();
  }
}