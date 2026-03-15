import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialButton extends StatelessWidget {
  final String imageText;
  final String text;
  final VoidCallback? onTap;

  const SocialButton({
    super.key,
    required this.imageText,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Color(0xFF3D4566), width: 1.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imageText, width: 20.w, height: 20.h),
            SizedBox(width: 10.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
