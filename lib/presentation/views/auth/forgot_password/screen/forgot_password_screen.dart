import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/presentation/views/auth/login/presentaion/widgets/custom_textfield.dart';
import 'package:abbas/presentation/views/auth/view_model/signup_screen_provider.dart';
import 'package:abbas/presentation/widgets/primary_button.dart';
import 'package:abbas/presentation/widgets/validator.dart';
import 'package:abbas/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../cors/theme/app_colors.dart';
import '../../../../../cors/theme/app_text_styles.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitForgotPassword() async {
    if (_formKey.currentState!.validate()) {
      final res = await ref
          .read(authProvider.notifier)
          .forgotPassword(email: _emailController.text.trim());

      if (res.success) {
        Utils.showToast(
          msg: res.message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        if (context.mounted) {
          Navigator.pushNamed(context, RouteNames.otpVerifyScreen);
        }
      } else {
        Utils.showToast(
          msg: res.message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),

            Text(
              'Forgot Password?',
              style: AppTextStyles.textTheme.headlineMedium?.copyWith(
                color: AppColors.white,
              ),
            ),

            SizedBox(height: 32.h),

            Text(
              'Email',
              style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                color: AppColors.lightGreyTextColor,
              ),
            ),

            SizedBox(height: 8.h),

            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: AppTextField(
                controller: _emailController,
                hintText: 'Enter your email',
                validator: emailValidator,
              ),
            ),
            SizedBox(height: 24.h),
            PrimaryButton(
              onTap: ref.watch(authProvider).isLoading
                  ? null
                  : _submitForgotPassword,
              color: AppColors.activeButtonColor,
              child: ref.watch(authProvider).isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Send",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
