import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color color;
  final Color textColor;
  final String? icon;
  final bool? hasIcon;

  const PrimaryButton({
    super.key,
   required this.onTap,
    required this.title,
    required  this.color,
    required this.textColor,
    this.icon,
    this.hasIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        decoration: BoxDecoration(
          // color: Color(0xffE9201D),
          color: color,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          spacing: 16.w,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            hasIcon ?? false ? SvgPicture.asset(icon!,height: 30,): SizedBox(),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
      ),
    );
  }
}
