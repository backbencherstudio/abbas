import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../../cors/theme/app_text_styles.dart';

class AuthFormContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool showDivider;

  const AuthFormContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              Text(
                subtitle,
                style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                title,
                style: AppTextStyles.textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 25.h),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}