import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppUtils {
  static String extractErrorMessage(dynamic responseData) {
    if (responseData is Map) {
      if (responseData.containsKey('message')) {
        if (responseData['message'] is Map) {
          return responseData['message']['message'] ?? 'Unauthorized access';
        } else if (responseData['message'] is String) {
          return responseData['message'];
        }
      }
      return responseData.toString();
    }
    return 'Unknown error occurred';
  }
}

class Utils {
  static void showToast({
    required String msg,
    required Color backgroundColor,
    required Color textColor,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.sp,
    );
  }
}
