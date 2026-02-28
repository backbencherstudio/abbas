import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';
import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../../cors/theme/app_text_styles.dart';


class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isRequired;
  final bool isEmail;
  final bool isPassword;
  final TextInputAction textInputAction;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isRequired = false,
    this.isEmail = false,
    this.isPassword = false,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType:
      isEmail ? TextInputType.emailAddress : TextInputType.text,
      textInputAction: textInputAction,
      style: TextStyle(color: AppColors.white),

      validator: (value) {
        final text = value?.trim() ?? '';

        if (isRequired && text.isEmpty) {
          return 'This field is required';
        }

        if (isEmail && text.isNotEmpty && !EmailValidator.validate(text)) {
          return 'Enter a valid email address';
        }

        if (isPassword && text.length < 6) {
          return 'Password must be at least 6 characters';
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
      ),
    );
  }
}