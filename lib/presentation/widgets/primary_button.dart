import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color color;
  final Color? textColor;
  final String? icon;
  final bool? hasIcon;
  final Widget? child;

  const PrimaryButton({
    super.key,
   required this.onTap,
    required  this.color,
   this.textColor,
    this.icon,
    this.hasIcon = false,
    this.child
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(child: child)
      ),
    );
  }
}
