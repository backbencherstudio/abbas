import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'notification_bell_button.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? image;
  final String? image2;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showNotificationIcon;

  const CustomAppbar({
    super.key,
    required this.title,
    this.subtitle,
    this.image,
    this.image2,
    this.onTap,
    this.trailing,
    this.showNotificationIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [Color(0xffC11819), Color(0xff030D15)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 48.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
              if (image != null)
                GestureDetector(onTap: onTap, child: Image.asset(image!)),
              if (image2 != null) ...[
                SizedBox(width: 12.w),
                Image.asset(image2!),
              ],
              if (showNotificationIcon) ...[
                SizedBox(width: 12.w),
                const NotificationBellButton(),
              ],
            ],
          ),
        ],
      ),
    ),
  );
  }
}
