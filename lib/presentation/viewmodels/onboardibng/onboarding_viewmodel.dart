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
    if (currentPage == totalPages - 1) {
      // Navigator.pushReplacementNamed(context, LoginPage.name);
    } else {
      nextPage();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
