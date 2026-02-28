import 'package:abbas/presentation/views/auth/register/presentaion/widget/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialAuthButtons extends StatelessWidget {
  final VoidCallback? onApplePressed;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;

  const SocialAuthButtons({
    super.key,
    this.onApplePressed,
    this.onGooglePressed,
    this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        RegisterFormButton(
          title: 'Sign Up With Apple',
          image: 'assets/icons/apple_icon.png',
          onTap: onApplePressed,
        ),
        SizedBox(height: 10.h),
        RegisterFormButton(
          title: 'Sign Up With Google',
          image: 'assets/icons/google_icon.png',
          onTap: onGooglePressed,
        ),
        SizedBox(height: 10.h),
        RegisterFormButton(
          title: 'Sign Up With Facebook',
          image: 'assets/icons/facebook_icon.png',
          onTap: onFacebookPressed,
        ),
      ],
    );
  }
}