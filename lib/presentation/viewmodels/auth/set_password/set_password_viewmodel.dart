import 'package:flutter/foundation.dart';

import '../../../../domain/usecases/auth/set_new_password.dart';

class SetNewPasswordViewModel extends ChangeNotifier {
  final SetNewPasswordUseCase setNewPasswordUseCase;

  SetNewPasswordViewModel({required this.setNewPasswordUseCase});

  String _password = '';
  String _confirmPassword = '';
  String _apiErrorMessage = '';
  bool _showPasswordMismatchError = false;
  bool _isButtonEnable = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;
  bool _isSuccess = false;

  String get password => _password;

  String get confirmPassword => _confirmPassword;

  String get apiErrorMessage => _apiErrorMessage;

  bool get showPasswordMismatchError => _showPasswordMismatchError;

  bool get isButtonEnable => _isButtonEnable;

  bool get passwordVisible => _passwordVisible;

  bool get confirmPasswordVisible => _confirmPasswordVisible;

  bool get isLoading => _isLoading;

  bool get isSuccess => _isSuccess;

  void setPassword(String password) {
    _password = password;
    _validateFields();
    notifyListeners();
  }

  void setConfirmPassword(String confirmPassword) {
    _confirmPassword = confirmPassword;
    _validateFields();
    notifyListeners();
  }

  void _validateFields() {
    _apiErrorMessage = '';
    final bothFieldsFilled =
        _password.isNotEmpty && _confirmPassword.isNotEmpty;
    final passwordsMatch = _password == _confirmPassword;

    _showPasswordMismatchError = bothFieldsFilled && !passwordsMatch;
    _isButtonEnable = bothFieldsFilled && passwordsMatch;
    notifyListeners();
  }

  Future<bool> setNewPassword(String email, String otp) async {
    if (!_isButtonEnable) return false;

    _isLoading = true;
    _apiErrorMessage = '';
    _isSuccess = false;
    notifyListeners();

    try {
      final result = await setNewPasswordUseCase.execute(email, otp, _password);
      return result.fold(
        (error) {
          _apiErrorMessage = error;
          _isSuccess = false;
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (success) {
          if (success.success) {
            _apiErrorMessage = '';
            _isSuccess = true;
          } else {
            _apiErrorMessage = success.message;
            _isSuccess = false;
          }
          _isLoading = false;
          notifyListeners();
          return _isSuccess;
        },
      );
    } catch (e) {
      _apiErrorMessage = 'Failed to update password. Please try again.';
      _isSuccess = false;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearFields() {
    _password = '';
    _confirmPassword = '';
    _apiErrorMessage = '';
    _showPasswordMismatchError = false;
    _isButtonEnable = false;
    _isSuccess = false;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _confirmPasswordVisible = !_confirmPasswordVisible;
    notifyListeners();
  }

  void reset() {
    _password = '';
    _confirmPassword = '';
    _apiErrorMessage = '';
    _showPasswordMismatchError = false;
    _isButtonEnable = false;
    _passwordVisible = false;
    _confirmPasswordVisible = false;
    _isLoading = false;
    _isSuccess = false;
    notifyListeners();
  }
}
