import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Bryant',
      fontSize: 48.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Bryant',
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Bryant',
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Bryant',
      fontSize: 18.sp,
      fontWeight: FontWeight.normal,
      color: AppColors.white,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Bryant',
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.white,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Bryant',
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.white,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Bryant',
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.white,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Bryant',
      fontSize: 10.sp,
      fontWeight: FontWeight.normal,
      color: AppColors.white,
    ),
  );

  static final TextStyle bottomNavSelected = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  static final TextStyle bottomNavUnselected = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );
}