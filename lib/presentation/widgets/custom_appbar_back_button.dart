import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cors/theme/app_colors.dart';

class CustomAppbarBackButton extends StatelessWidget {
  const CustomAppbarBackButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.borderColor,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w,vertical:14.h),
          child: Center(
            child: Transform.translate(
              offset: Offset(2.5, 0),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 14.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
