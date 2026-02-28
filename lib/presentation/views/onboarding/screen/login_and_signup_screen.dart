import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../cors/routes/route_names.dart';
import '../../../../cors/theme/app_colors.dart';
import '../widgets/custom_elevated_button.dart';  // Import ScreenUtil


class LoginAndSignupScreen extends StatelessWidget {
  const LoginAndSignupScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Centered Logo Image
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 160.w,  // Responsive width using ScreenUtil
              fit: BoxFit.contain,
            ),
          ),

          // Positioned Buttons at the bottom
          Positioned(
            bottom: 50.h,  // Responsive bottom position using ScreenUtil
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Login Button
                CustomElevatedButton(
                  text: 'Login',
                  backgroundColor: Colors.transparent,
                  outlineColor: AppColors.borderColor,
                  onPressed: () {
                    // Handle login button press
                    Navigator.pushNamed(
                      context,
                      RouteNames.loginScreen,
                    );
                  },
                ),
                SizedBox(height: 10.h),  // Responsive spacing between buttons using ScreenUtil

                // Sign Up Button
                CustomElevatedButton(
                  text: 'SignUp',
                  backgroundColor: AppColors.activeButtonColor,
                  onPressed: () {
                    // Handle signup button press
                    Navigator.pushNamed(context, RouteNames.registerScreen);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
