import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/auth/login/presentaion/widgets/custom_textfield.dart';
import 'package:abbas/presentation/views/auth/view_model/signup_screen_provider.dart';
import 'package:abbas/presentation/widgets/social_button.dart';
import 'package:abbas/presentation/widgets/validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../../cors/theme/app_text_styles.dart';
import '../../../../../widgets/primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    if (_formKey.currentState!.validate()) {

      final res = await ref
          .read(authProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      if (res.success) {
        Utils.showToast(
          msg: res.message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        if (context.mounted) {
          Navigator.pushNamed(context, RouteNames.startEnrollment);
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
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hey! Welcome',
                style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                ),
              ),

              SizedBox(height: 20.h),

              Text(
                'Login to your Account',
                style: AppTextStyles.textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                ),
              ),

              SizedBox(height: 30.h),

              /// --------------------- Form Field -----------------------------
              Column(
                children: [
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                            color: AppColors.lightGreyTextColor,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        AppTextField(
                          controller: _emailController,
                          hintText: 'Enter your email',
                          validator: emailValidator,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Password',
                          style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                            color: AppColors.lightGreyTextColor,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        AppTextField(
                          controller: _passwordController,
                          hintText: 'Enter your password',
                          isPassword: !ref
                              .watch(authProvider)
                              .isPasswordVisible,
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
                        SizedBox(height: 10.h),

                        /// ------------ Forgot Password -----------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.forgotPasswordScreen,
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: AppTextStyles.textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        /// --------------- Primary Button --------------------
                        PrimaryButton(
                          color: AppColors.activeButtonColor,

                          textColor: AppColors.white,
                          onTap: ref.watch(authProvider).isLoading
                              ? null
                              : _submitLogin,
                          child: ref.watch(authProvider).isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),

                        SizedBox(height: 16.h),

                        /// -------------------- Divider -----------------------
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: AppColors.cardBackground,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                'Or Join With',
                                style: AppTextStyles.textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.greyTextColor),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: AppColors.cardBackground,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        ///----------------- Social Button ---------------------
                        SocialButton(
                          imageText: "assets/icons/apple.png",
                          text: "Sign in with Apple",
                        ),
                        SizedBox(height: 16.h),
                        SocialButton(
                          imageText: 'assets/icons/google_icon.png',
                          text: 'Sign in with Google',
                        ),
                        SizedBox(height: 24.h),

                        /// --------------- Don't have an account --------------
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Don't have an account? ",
                                  style: AppTextStyles.textTheme.bodyMedium
                                      ?.copyWith(color: AppColors.white),
                                ),
                                TextSpan(
                                  text: 'Sign Up',
                                  style: AppTextStyles.textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.radishTextColor,
                                      ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                        context,
                                        RouteNames.registerScreen,
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
