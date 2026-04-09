import 'package:abbas/cors/routes/route_names.dart';
import 'package:flutter/material.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;
  final int totalPages;

  OnboardingViewModel({required this.totalPages});

  void onPageChanged(int index) {
    currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (currentPage < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void skip(BuildContext context) {
    Navigator.pushReplacementNamed(context, RouteNames.loginAndSignUpScreen);
  }

/*  void skip(BuildContext context) {
    if (currentPage < totalPages - 1) {
      pageController.animateToPage(
       currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacementNamed(context, RouteNames.loginAndSignUpScreen);
    }
  }*/

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
