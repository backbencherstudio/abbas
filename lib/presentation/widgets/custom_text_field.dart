import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cors/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType keyboardType;
  final int? maxLines;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.maxLines,
    this.obscureText = false,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(

        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.borderColor, fontSize: 14.sp, fontWeight: FontWeight.w500),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.borderColor)
            : null,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: AppColors.borderColor)
            : null,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(16.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }
}
