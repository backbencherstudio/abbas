import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetNewPasswordScreenUtils {
  static void showSuccessToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _buildToastContent(
            Icons.check_circle,
            'Password updated successfully!',
            Colors.black, // Black background
            Colors.white  // White text color
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          right: 20.w,
          left: 20.w,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  static void showErrorToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _buildToastContent(
            Icons.error_outline,
            message,
            Colors.red,    // Red background for error
            Colors.white   // White text color
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          right: 20.w,
          left: 20.w,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  static Widget _buildToastContent(IconData icon, String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 24.sp), // Use textColor for icon
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: textColor, // Use textColor parameter
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}