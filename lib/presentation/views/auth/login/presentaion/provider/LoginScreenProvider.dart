import 'dart:developer';

import 'package:abbas/cors/services/api_client.dart';
import 'package:flutter/material.dart';
import '../../domain/loginEntity.dart';
import '../../domain/loginUseCase.dart';

class LoginScreenProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  LoginScreenProvider({required this.loginUseCase}) {
    _emailController.addListener(_onTextChanged);
    _passwordController.addListener(_onTextChanged);
  }

  /// ------------------- TextEditingController --------------------------------
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  TextEditingController get emailController => _emailController;

  TextEditingController get passwordController => _passwordController;

  GlobalKey<FormState> get formKey => _formKey;

  /// ------------------------ Loading State -----------------------------------
  bool _isLoading = false;
  String? _errorMessage;
  LoginEntity? _user;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get isButtonEnabled =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  LoginEntity? get user => _user;

  void _onTextChanged() {
    notifyListeners();
  }

  /// ------------------------- Toggle Password Visible ------------------------
  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  void setIsPasswordVisible() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
    logger.d("Toggle Password Visibility $_isPasswordVisible");
  }

  /// ------------------------- Function to call (Login) -----------------------
  Future<void> login() async {
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
        _emailController.text.trim(),
        _passwordController.text.trim(),
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
