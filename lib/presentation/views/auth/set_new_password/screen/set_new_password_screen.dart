import 'package:abbas/presentation/views/auth/view_model/signup_screen_provider.dart';
import 'package:abbas/presentation/widgets/custom_text_field.dart';
import 'package:abbas/presentation/widgets/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../cors/theme/app_colors.dart';
import '../../../../../cors/theme/app_text_styles.dart';

class SetNewPasswordScreen extends ConsumerStatefulWidget {
  final String email;

  const SetNewPasswordScreen({super.key, required this.email});

  @override
  ConsumerState<SetNewPasswordScreen> createState() =>
      _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends ConsumerState<SetNewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, size: 24.sp, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          children: [
            Text(
              'Set New Password',
              style: AppTextStyles.textTheme.headlineMedium?.copyWith(
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "Password",
              style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xFFB2B5B8),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 7.h),
            CustomTextField(
              controller: _confirmPasswordController,
              hintText: 'Enter a new password',
              obscureText: ref.watch(authProvider).isPasswordVisible,
              suffixIcon: GestureDetector(
                onTap: ref.read(authProvider.notifier).togglePasswordVisibility,
                child: ref.watch(authProvider).isPasswordVisible
                    ? Icon(Icons.visibility_outlined)
                    : Icon(Icons.visibility_off_outlined),
              ),
              validator: passwordValidator,
            ),
            SizedBox(height: 16.h),
            Text(
              "Confirm Password",
              style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xFFB2B5B8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
