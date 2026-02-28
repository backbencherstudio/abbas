import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../../cors/theme/app_text_styles.dart';

class PasswordMismatchError extends StatelessWidget {
  const PasswordMismatchError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Text(
            "Don't match!",
            style: AppTextStyles.textTheme.titleLarge?.copyWith(
              color: AppColors.radishTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            "Try Again",
            style: AppTextStyles.textTheme.titleMedium?.copyWith(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}