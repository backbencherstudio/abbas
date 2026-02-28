import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cors/theme/app_colors.dart';

class TransparentTextField extends StatelessWidget {
  const TransparentTextField({
    super.key,
    required this.title,
    this.onTap,
    this.color,
    this.textColor,
    this.alignment,
  });

  final String title;
  final VoidCallback? onTap;
  final Color? color;         // Border color
  final Color? textColor;     // Dynamic text color
  final Alignment? alignment; // Dynamic alignment

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.sp),
          border: Border.all(
            color: color ?? AppColors.borderColor,
            width: 1.5,
          ),
        ),
        child: Align(
          alignment: alignment ?? Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: textColor ?? AppColors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}
