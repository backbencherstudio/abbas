import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/auth/view_model/signup_screen_provider.dart';
import 'package:abbas/presentation/widgets/custom_text_field.dart';
import 'package:abbas/presentation/widgets/primary_button.dart';
import 'package:abbas/presentation/widgets/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../cors/theme/app_colors.dart';
import '../../../../../cors/theme/app_text_styles.dart';

class SetNewPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  final String otp;

  const SetNewPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  ConsumerState<SetNewPasswordScreen> createState() =>
      _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends ConsumerState<SetNewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

   String _email = '';
   String _otp = '';
   @override
  void initState() {
   _email = widget.email;
   _otp = widget.otp;
    super.initState();
  }

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set New Password',
                style: AppTextStyles.textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 24.h),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      controller: _passwordController,
                      hintText: 'Enter a new password',
                      obscureText: !ref.watch(authProvider).isPasswordVisible,
                      suffixIcon: GestureDetector(
                        onTap: ref
                            .read(authProvider.notifier)
                            .togglePasswordVisibility,
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
                    SizedBox(height: 7.h),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Enter a confirm password',
                      obscureText: !ref
                          .watch(authProvider)
                          .isConfirmPasswordVisible,
                      suffixIcon: GestureDetector(
                        onTap: ref
                            .read(authProvider.notifier)
                            .toggleConfirmPasswordVisibility,
                        child: ref.watch(authProvider).isConfirmPasswordVisible
                            ? Icon(Icons.visibility_outlined)
                            : Icon(Icons.visibility_off_outlined),
                      ),
                      validator: (value) => confirmPasswordValidator(
                        value,
                        _passwordController.text,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    PrimaryButton(
                      onTap: () async {
                        if (_passwordController.text ==
                            _confirmPasswordController.text) {
                          logger.d("Email : $_email");
                          logger.d("Otp : $_otp");
                          logger.d(
                            "New Password : ${_passwordController.text}",
                          );
                          final res = await ref
                              .read(authProvider.notifier)
                              .resetPassword(
                                email: _email,
                                otp: _otp,
                                newPassword: _passwordController.text,
                              );
                          if (res.success) {
                            Utils.showToast(
                              msg: res.message,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );
                            if(context.mounted){
                              Navigator.pushNamed(context, RouteNames.loginScreen);
                            }
                          } else {
                            Utils.showToast(
                              msg: res.message,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          }
                        }
                      },
                      color: AppColors.activeButtonColor,
                      child: Text(
                        "Update Password",
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
            ],
          ),
        ),
      ),
    );
  }
}
