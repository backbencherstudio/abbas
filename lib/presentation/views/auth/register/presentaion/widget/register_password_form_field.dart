import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../../cors/theme/app_text_styles.dart';
import '../../view_model/signupScreen_provider.dart';

class RegisterPasswordFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputAction textInputAction;

  const RegisterPasswordFormField({
    super.key,
    required this.controller,
    this.hintText = 'Password',
    this.validator,
    this.onChanged,
    this.textInputAction = TextInputAction.done,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupScreenProvider>(
      builder: (context, formProvider, child) {
        return TextFormField(
          controller: controller,
          onChanged: onChanged,
          obscureText: true,
          textInputAction: textInputAction,
          style: TextStyle(color: AppColors.white),
          validator: validator ?? (String? value) {
            if ((value?.length ?? 0) < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            hintText: hintText,
            hintStyle: AppTextStyles.textTheme.bodyMedium?.copyWith(
              color: AppColors.greyTextColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
          ),
        );
      },
    );
  }
}