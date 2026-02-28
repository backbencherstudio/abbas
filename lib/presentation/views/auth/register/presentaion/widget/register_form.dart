import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../cors/theme/app_colors.dart';

class RegisterFormButton extends StatelessWidget {
  const RegisterFormButton({
    super.key,
    required this.title,
    this.onTap,
    this.color,
    required this.image,
  });

  final String title;
  final VoidCallback? onTap;
  final Color? color;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: color ?? Colors.transparent,
          borderRadius: BorderRadius.circular(16.sp),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Align the image and text properly
          children: [
            Image.asset(
              image, // Display the image
              width: 20.w, // Customize the image size if needed
              height: 20.h, // Customize the image size if needed
            ),
            SizedBox(width: 10.w), // Add some space between the image and text
            Text(
              title,
              style: TextStyle(
                color: Color(0xffffffff),
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
