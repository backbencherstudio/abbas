import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../cors/theme/app_colors.dart';
import '../../../../cors/theme/app_text_styles.dart';


class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? outlineColor;
  final TextStyle? textStyle;

  const CustomElevatedButton({
    super.key,
    this.text = '',
    this.onPressed,
    this.backgroundColor,
    this.prefixIcon,
    this.suffixIcon,
    this.outlineColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 335.w,
      height: 56.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.activeButtonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: outlineColor != null
                ? BorderSide(color: outlineColor!)
                : BorderSide.none,
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              SizedBox(width: 8.w),
            ],
            Text(
              text,
              style: textStyle ??
                  AppTextStyles.textTheme.bodyLarge?.copyWith(
                    color: AppColors.white,
                  ),
            ),
            if (suffixIcon != null) ...[
              SizedBox(width: 8.w),
              suffixIcon!,
            ],
          ],
        ),
      ),
    );
  }
}
