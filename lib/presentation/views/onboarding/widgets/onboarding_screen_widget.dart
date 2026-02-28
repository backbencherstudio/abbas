import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../cors/theme/app_colors.dart';
import '../../../../cors/theme/app_text_styles.dart';


class OnboardingScreenWidget extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String subtitle1;
  final String subtitle2;

  const OnboardingScreenWidget({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(imageAsset, fit: BoxFit.cover),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w), // responsive padding
          child: Align(
            alignment: const Alignment(0, 0.27),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textTheme.headlineMedium?.copyWith(
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 20.h),

                // Subtitle line 1
                Text(
                  subtitle1,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onBoardingSubHeaderText,
                  ),
                ),
                SizedBox(height: 4.h),

                // Subtitle line 2
                Text(
                  subtitle2,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onBoardingSubHeaderText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

