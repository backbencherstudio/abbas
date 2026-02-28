import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopToast {
  static void showSuccess({
    required BuildContext context,
    required String message,
    int durationSeconds = 2,
  }) {
    _showToast(
      context: context,
      message: message,
      backgroundColor: Colors.black,
      icon: Icons.check_circle,
      durationSeconds: durationSeconds,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    int durationSeconds = 2,
  }) {
    _showToast(
      context: context,
      message: message,
      backgroundColor: Colors.red[700]!,
      icon: Icons.error,
      durationSeconds: durationSeconds,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    int durationSeconds = 2,
  }) {
    _showToast(
      context: context,
      message: message,
      backgroundColor: Colors.orange[700]!,
      icon: Icons.warning,
      durationSeconds: durationSeconds,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    int durationSeconds = 2,
  }) {
    _showToast(
      context: context,
      message: message,
      backgroundColor: Colors.blue[700]!,
      icon: Icons.info,
      durationSeconds: durationSeconds,
    );
  }

  static void _showToast({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    int durationSeconds = 2,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 24.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: durationSeconds),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100.h,
          left: 20.w,
          right: 20.w,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}