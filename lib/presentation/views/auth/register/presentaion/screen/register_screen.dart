import 'package:abbas/presentation/views/auth/view_model/signup_screen_provider.dart';
import 'package:abbas/presentation/widgets/validator.dart';
import 'package:abbas/utils/app_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../../cors/theme/app_text_styles.dart';
import '../../../../../widgets/primary_button.dart';
import '../../../../../widgets/social_button.dart';
import '../../../login/presentaion/widgets/custom_textfield.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                'New to CINACT?',
                style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Create an Account',
                style: AppTextStyles.textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: 25.h),

              /// --------------------- Form -----------------------------------
              Column(
                children: [
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                            color: AppColors.lightGreyTextColor,
                          ),
                        ),
                        SizedBox(height: 6.h),

                        AppTextField(
                          controller: _nameController,
                          hintText: 'Enter your name',
                          validator: nameValidator,
                        ),
                        SizedBox(height: 16.h),

                        Text(
                          'Email',
                          style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                            color: AppColors.lightGreyTextColor,
                          ),
                        ),
                        SizedBox(height: 6.h),

                        AppTextField(
                          controller: _emailController,
                          hintText: 'Your Email',
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
                          hintText: 'Your Password',
                          isPassword: !ref
                              .watch(authProvider)
                              .isPasswordVisible,
                          textInputAction: TextInputAction.done,
                          validator: passwordValidator,
                          suffixIcon: GestureDetector(
                            onTap: ref
                                .read(authProvider.notifier)
                                .togglePasswordVisibility,
                            child: Icon(
                              ref.watch(authProvider).isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              ///---------------------------------------------------------------
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Text(
                  '',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),

              PrimaryButton(
                onTap: () async {
                  if (!_formKey.currentState!.validate()) return;

                  if (!mounted) return;

                  final res = await ref
                      .read(authProvider.notifier)
                      .register(
                        name: _nameController.text.trim(),
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
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteNames.loginScreen,
                        (route) => false,
                      );
                    }
                  } else {
                    Utils.showToast(
                      msg: res.message,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                  _nameController.clear();
                  _emailController.clear();
                  _passwordController.clear();
                },
                color: AppColors.activeButtonColor,
                textColor: AppColors.white,
                icon: '',
                child: ref.watch(authProvider).isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),

              SizedBox(height: 16.h),

              ///---------------------------------------------------------------
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: AppColors.cardBackground),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'Or Join With',
                      style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                        color: AppColors.greyTextColor,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: AppColors.cardBackground),
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
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      TextSpan(
                        text: 'Sign In',
                        style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                          color: AppColors.radishTextColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushNamed(
                            context,
                            RouteNames.loginScreen,
                          ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
