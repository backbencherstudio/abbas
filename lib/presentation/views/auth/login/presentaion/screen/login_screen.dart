import 'package:abbas/presentation/views/auth/login/presentaion/widgets/custom_textfield.dart';
import 'package:abbas/presentation/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../../cors/theme/app_text_styles.dart';
import '../../../../../widgets/primary_button.dart';
import '../provider/LoginScreenProvider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginScreenProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),

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

              /// Email Field
              _buildEmailField(provider),

              SizedBox(height: 16.h),

              /// Password Field
              _buildPasswordField(provider, context),

              SizedBox(height: 16.h),

              /// Error Message
              _buildErrorMessage(),

              SizedBox(height: 16.h),

              /// Login Button
              _buildLoginButton(context),

              SizedBox(height: 25.h),

              /// Divider
              _buildOrJoinWithDivider(),

              SizedBox(height: 15.h),

              /// Social Button
              const CustomButton(
                title: 'Sign In With Facebook',
              ),

              SizedBox(height: 30.h),

              /// Signup Link
              _buildSignUpLink(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Email Field
  Widget _buildEmailField(LoginScreenProvider provider) {
    return Column(
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
          controller: provider.emailController,
          hintText: 'Enter your email',
          isRequired: true,
        ),
      ],
    );
  }

  /// Password Field
  Widget _buildPasswordField(
      LoginScreenProvider provider, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: AppTextStyles.textTheme.bodyMedium?.copyWith(
            color: AppColors.lightGreyTextColor,
          ),
        ),
        SizedBox(height: 6.h),
        AppTextField(
          controller: provider.passwordController,
          hintText: 'Enter your password',
          isRequired: true,
          //obscureText: true,
        ),
        SizedBox(height: 6.h),
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
                style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Error Message
  Widget _buildErrorMessage() {
    return Consumer<LoginScreenProvider>(
      builder: (context, viewModel, child) {
        return viewModel.errorMessage != null
            ? Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Text(
            viewModel.errorMessage!,
            style: AppTextStyles.textTheme.bodyMedium?.copyWith(
              color: Colors.red,
            ),
          ),
        )
            : const SizedBox.shrink();
      },
    );
  }

  /// Login Button
  Widget _buildLoginButton(BuildContext context) {
    return Consumer<LoginScreenProvider>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return PrimaryButton(
          title: 'Login',
          color: viewModel.isButtonEnabled
              ? AppColors.activeButtonColor
              : AppColors.inactiveButtonColor,
          textColor: AppColors.white,
          onTap: () async {
            await viewModel.login();

            if (viewModel.user != null) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.parentScreen,
                    (route) => false,
              );
            }
          },
        );
      },
    );
  }

  /// Divider
  Widget _buildOrJoinWithDivider() {
    return Row(
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
            style: AppTextStyles.textTheme.bodyMedium?.copyWith(
              color: AppColors.greyTextColor,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.cardBackground,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  /// SignUp Link
  Widget _buildSignUpLink(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Don't have an account? ",
              style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: AppTextStyles.textTheme.bodyMedium?.copyWith(
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
    );
  }
}