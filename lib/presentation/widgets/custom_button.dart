import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cors/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.title, this.onTap, this.color, this.textColor, this.hasIcon = false, this.iconWidget});

  final Widget title;
  final Widget? iconWidget;
  final VoidCallback? onTap;
  final Color? color;
  final Color? textColor;
  final bool? hasIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: color ?? AppColors.radishTextColor,
          borderRadius: BorderRadius.circular(16.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            title,
          ],
        ),
      ),
    );
  }
}