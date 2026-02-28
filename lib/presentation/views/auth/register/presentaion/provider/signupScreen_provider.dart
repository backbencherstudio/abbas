import 'package:flutter/material.dart';
import 'package:abbas/presentation/views/auth/register/domain/signUpUseCase.dart';

class SignupScreenProvider extends ChangeNotifier {
  final SignUpUseCase signUpUseCase;

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  SignupScreenProvider(this.signUpUseCase);

  Future<void> signUp() async {
    if (nameCtrl.text.trim().isEmpty ||
        emailCtrl.text.trim().isEmpty ||
        passwordCtrl.text.isEmpty) {
      errorMessage = "Please fill all fields";
      notifyListeners();
      return;
    }

    errorMessage = null;
    successMessage = null;
    isLoading = true;
    notifyListeners();

    try {
      final result = await signUpUseCase(
        nameCtrl.text.trim(),
        emailCtrl.text.trim(),
        passwordCtrl.text,
      );
      successMessage = result.message;
    } catch (e) {
      errorMessage = _simpleErrorMessage(e);
    }

    isLoading = false;
    notifyListeners();
  }

  String _simpleErrorMessage(dynamic e) {
    final msg = e.toString().toLowerCase();

    debugPrint("The errro message ${msg}");
    if (msg.contains("socket") || msg.contains("host")) {
      return "No internet connection";
    }
    if (msg.contains("email") && msg.contains("already")) {
      return "Email already registered";
    }
    return "Something went wrong";
  }

  bool get canSubmit =>
      nameCtrl.text.trim().isNotEmpty &&
          emailCtrl.text.trim().isNotEmpty &&
          passwordCtrl.text.isNotEmpty &&
          !isLoading;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }
}