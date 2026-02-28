import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../../cors/theme/app_text_styles.dart';

class PasswordField extends StatelessWidget {
  final String label;
  final String hintText;
  final String value;
  final bool obscureText;
  final bool showError;
  final ValueChanged<String> onChanged;
  final VoidCallback onToggleVisibility;

  const PasswordField({
    super.key,
    required this.label,
    required this.hintText,
    required this.value,
    required this.obscureText,
    required this.showError,
    required this.onChanged,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.textTheme.bodyMedium?.copyWith(
            color: AppColors.lightGreyTextColor,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          onChanged: onChanged,
          obscureText: obscureText,
          style: TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            hintText: hintText,
            hintStyle: AppTextStyles.textTheme.bodyMedium?.copyWith(
              color: AppColors.greyTextColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: showError ? Colors.red : AppColors.borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: showError ? Colors.red : AppColors.primary,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: showError ? Colors.red : AppColors.borderColor,
              ),
            ),
            suffixIcon: value.isNotEmpty
                ? IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.white,
              ),
              onPressed: onToggleVisibility,
            )
                : null,
          ),
        ),
      ],
    );
  }
}