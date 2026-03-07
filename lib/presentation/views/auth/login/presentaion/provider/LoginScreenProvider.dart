import 'dart:developer';

import 'package:flutter/material.dart';
import '../../domain/loginEntity.dart';
import '../../domain/loginUseCase.dart';

class LoginScreenProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  LoginScreenProvider({required this.loginUseCase}) {
    emailController.addListener(_onTextChanged);
    passwordController.addListener(_onTextChanged);
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  LoginEntity? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isButtonEnabled =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  LoginEntity? get user => _user;

  void _onTextChanged() {
    notifyListeners();
  }

  Future<void> login() async {

    log("you cliek the login method");
    if (!isButtonEnabled) {
      _errorMessage = "Please enter email and password";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      log("you enter  the try block");

      final result = await loginUseCase(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      _user = result;
    } catch (e) {
      log("you enter  the cath block $e");

      _errorMessage = e.toString().replaceAll("Exception: ", "");
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}