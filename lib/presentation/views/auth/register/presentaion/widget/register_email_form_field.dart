import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../../cors/theme/app_text_styles.dart';
import '../../../../../viewmodels/auth/register/register_viewmodel.dart';

class RegisterEmailFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const RegisterEmailFormField({
    super.key,
    required this.controller,
    this.hintText = 'Your Email',
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterViewModel>(
      builder: (context, formProvider, child) {
        return TextFormField(
          controller: controller,
          onChanged: onChanged ?? formProvider.setEmail,
          style: TextStyle(color: AppColors.white),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: validator ?? (String? value) {
            String emailValue = value ?? '';
            if (emailValue.isEmpty) {
              return 'Please enter your email';
            }
            if (!EmailValidator.validate(emailValue)) {
              return 'Enter a valid email address';
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
            // ADD THIS LINE for real-time error display
            errorText: formProvider.emailError,
          ),
        );
      },
    );
  }
}