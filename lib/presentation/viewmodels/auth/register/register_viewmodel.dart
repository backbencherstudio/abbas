import 'package:flutter/cupertino.dart';
import '../../../../domain/usecases/auth/register_user.dart';

class RegisterViewModel extends ChangeNotifier {
  final RegisterUser registerUser;

  RegisterViewModel({required this.registerUser});

  // Form fields
  String _email = '';
  String _password = '';
  bool _isButtonEnabled = false;
  bool _passwordVisible = false;

  // Loading and error states
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isRegisterSuccess = false;

  // Getters
  String get email => _email;

  String get password => _password;

  bool get isButtonEnabled => _isButtonEnabled;

  bool get passwordVisible => _passwordVisible;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  bool get isRegisterSuccess => _isRegisterSuccess;

  // Method to set email
  void setEmail(String email) {
    _email = email;
    _checkFields();
    _clearError();
    notifyListeners();
  }

  // Method to set password
  void setPassword(String password) {
    _password = password;
    _checkFields();
    _clearError();
    notifyListeners();
  }

  // Method to check if all fields are filled
  void _checkFields() {
    _isButtonEnabled = _email.isNotEmpty && _password.isNotEmpty;
  }

  // Password hide/show
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  // Clear error message
  void _clearError() {
    if (_errorMessage.isNotEmpty) {
      _errorMessage = '';
      notifyListeners();
    }
  }

  // Set error message method (called from UI)
  void setError(String message) {
    _errorMessage = message;
    _isRegisterSuccess = false;
    notifyListeners();
  }

  // Register method
  Future<void> register() async {
    if (!_isButtonEnabled || _isLoading) return;

    _isLoading = true;
    _errorMessage = '';
    _isRegisterSuccess = false;
    notifyListeners();

    try {
      final registerResult = await registerUser(_email, _password);

      if (registerResult.success) {
        _isRegisterSuccess = true;
        _errorMessage = '';
      } else {
        _errorMessage = registerResult.message ?? 'Registration failed';
        _isRegisterSuccess = false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isRegisterSuccess = false;

      // Handle specific error cases
      if (_errorMessage.toLowerCase().contains('email already')) {
        _errorMessage = 'Email already exists';
      } else if (_errorMessage.toLowerCase().contains('network')) {
        _errorMessage = 'Network error. Please check your connection';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to clear the form fields and reset state
  void clearForm() {
    _email = '';
    _password = '';
    _isButtonEnabled = false;
    _errorMessage = '';
    _isRegisterSuccess = false;
    notifyListeners();
  }

  // Method to reset error state
  void resetError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Method to reset success state
  void resetSuccess() {
    _isRegisterSuccess = false;
    notifyListeners();
  }

  // Validation methods
  bool get isEmailValid => _email.contains('@') && _email.contains('.');

  bool get isPasswordValid => _password.length >= 8;

  String? get emailError {
    if (_email.isEmpty) return null;
    if (!isEmailValid) return 'Please enter a valid email address';
    return null;
  }

  String? get passwordError {
    if (_password.isEmpty) return null;
    if (!isPasswordValid) return 'Password must be at least 8 characters';
    return null;
  }

  // Check if form is valid for submission
  bool get isFormValid => emailError == null && passwordError == null;
}
