import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: AppTextStyles.bottomNavSelected,
      unselectedLabelStyle: AppTextStyles.bottomNavUnselected,
    ),
    textTheme: AppTextStyles.textTheme,
  );
}