import 'package:flutter/foundation.dart';
import '../../../../domain/usecases/auth/change_password_usecase.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final ChangePasswordUseCase changePasswordUseCase;

  ChangePasswordViewModel({required this.changePasswordUseCase});

  String _currentPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';
  String _apiErrorMessage = '';
  bool _showPasswordMismatchError = false;
  bool _isButtonEnable = false;
  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;
  bool _isSuccess = false;

  String get currentPassword => _currentPassword;
  String get newPassword => _newPassword;
  String get confirmPassword => _confirmPassword;
  String get apiErrorMessage => _apiErrorMessage;
  bool get showPasswordMismatchError => _showPasswordMismatchError;
  bool get isButtonEnable => _isButtonEnable;
  bool get currentPasswordVisible => _currentPasswordVisible;
  bool get newPasswordVisible => _newPasswordVisible;
  bool get confirmPasswordVisible => _confirmPasswordVisible;
  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;

  void setCurrentPassword(String password) {
    _currentPassword = password;
    _validateFields();
    notifyListeners();
  }

  void setNewPassword(String password) {
    _newPassword = password;
    _validateFields();
    notifyListeners();
  }

  void setConfirmPassword(String password) {
    _confirmPassword = password;
    _validateFields();
    notifyListeners();
  }

  void _validateFields() {
    _apiErrorMessage = '';
    final allFieldsFilled = _currentPassword.isNotEmpty &&
        _newPassword.isNotEmpty &&
        _confirmPassword.isNotEmpty;
    final passwordsMatch = _newPassword == _confirmPassword;

    _showPasswordMismatchError = allFieldsFilled && !passwordsMatch;
    _isButtonEnable = allFieldsFilled && passwordsMatch;
    notifyListeners();
  }

  Future<bool> changePassword(String email) async {
    if (!_isButtonEnable) return false;

    _isLoading = true;
    _apiErrorMessage = '';
    _isSuccess = false;
    notifyListeners();

    try {
      final result = await changePasswordUseCase.execute(email, _currentPassword, _newPassword);
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
      _apiErrorMessage = 'Failed to change password. Please try again.';
      _isSuccess = false;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearFields() {
    _currentPassword = '';
    _newPassword = '';
    _confirmPassword = '';
    _apiErrorMessage = '';
    _showPasswordMismatchError = false;
    _isButtonEnable = false;
    _isSuccess = false;
    notifyListeners();
  }

  void toggleCurrentPasswordVisibility() {
    _currentPasswordVisible = !_currentPasswordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    _newPasswordVisible = !_newPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _confirmPasswordVisible = !_confirmPasswordVisible;
    notifyListeners();
  }

  void reset() {
    _currentPassword = '';
    _newPassword = '';
    _confirmPassword = '';
    _apiErrorMessage = '';
    _showPasswordMismatchError = false;
    _isButtonEnable = false;
    _currentPasswordVisible = false;
    _newPasswordVisible = false;
    _confirmPasswordVisible = false;
    _isLoading = false;
    _isSuccess = false;
    notifyListeners();
  }
}