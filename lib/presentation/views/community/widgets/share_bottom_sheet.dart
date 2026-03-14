import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../cors/theme/app_colors.dart';
import '../../../widgets/primary_button.dart';

class ShareBottomSheet extends StatelessWidget {
  const ShareBottomSheet({
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
          spacing: 16.h,
          children: [
            Container(
              height: 4.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: AppColors.subContainerColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 48.h),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 8.h),
            Row(
              spacing: 16.w,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildOption('assets/images/facebook.png', 'Facebook'),
                _buildOption('assets/images/linkedin.png', 'Linkedin'),
                _buildOption('assets/images/whatsapp.png', 'WhatsApp'),
                _buildOption('assets/images/copy_link.png', 'Copy Link'),
              ],
            ),
            PrimaryButton(
              onTap: () {},
              color: Color(0xFF07121D),
              textColor: Color(0xff8D9CDC),
              icon: 'assets/icons/arrow_back.svg',
              hasIcon: true,
              child: Text("Back To Home"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String iconPath, String title) {
    return Column(
      children: [
        Image.asset(iconPath, scale: 3),
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: Color(0xff8C9196),
          ),
        ),
      ],
    );
  }
}
