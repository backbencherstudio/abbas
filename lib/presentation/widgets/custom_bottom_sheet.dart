import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../cors/routes/route_names.dart';
import '../../cors/services/refresh_token_storage.dart';
import '../../cors/services/token_storage.dart';
import '../../cors/theme/app_colors.dart';
import 'custom_button.dart';
import 'custom_outline_button.dart';

class CustomBottomSheet extends StatelessWidget {
  CustomBottomSheet({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.buttonTitle,
    required this.buttonIconPath,
    this.onTap,
  });

  final String title;
  final String description;
  final String iconPath;
  final String buttonTitle;
  final String buttonIconPath;
  final VoidCallback? onTap;

  final TokenStorage _tokenStorage = TokenStorage();
  final RefreshTokenStorage _refreshTokenStorage = RefreshTokenStorage();

  Future<void> _logout(BuildContext context) async {
    await _tokenStorage.clearToken();
    await _refreshTokenStorage.clearRefreshToken();
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.loginAndSignUpScreen,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.h,
      padding: EdgeInsets.all(16.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 4.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: AppColors.subContainerColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(10.w),
            height: 50.h,
            width: 50.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(45.r),
              border: Border.all(color: const Color(0xFF463E46), width: 4.w),
            ),
            child: SvgPicture.asset(iconPath),
          ),
          SizedBox(height: 16.h),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 16.h),
          Text(description, textAlign: TextAlign.center),
          SizedBox(height: 16.h),
          const Spacer(),
          CustomButton(
            title:buttonTitle,
            hasIcon: true,
            iconWidget: SvgPicture.asset(
              buttonIconPath,
              height: 20.h,
              width: 20.w,
            ),
            onTap: onTap ?? () => _logout(context),
          ),
          SizedBox(height: 8.h),
          CustomOutlineButton(
            title: 'Cancel',
            hasIcon: true,
            iconWidget: Icon(Icons.close, color: Colors.white, size: 20.w),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
