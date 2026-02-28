import 'package:flutter/material.dart';

import '../../domain/loginEntity.dart';
import '../../domain/loginUseCase.dart';

class LoginScreenProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  LoginScreenProvider({required this.loginUseCase});

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // State
  bool _isLoading = false;
  String? _errorMessage;
  LoginEntity? _user;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isButtonEnabled =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  LoginEntity? get user => _user;

  // Login function
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _errorMessage = "Please enter email and password";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await loginUseCase(
        emailController.text.trim(),
        passwordController.text,
      );

      _user = result;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Dispose controllers
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}