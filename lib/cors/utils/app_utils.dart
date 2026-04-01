import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../services/api_client.dart';

class AppUtils {
  AppUtils._();
  static const String appVersion = '1.0.0';
  static const String contactSupportEmail = "support@example.com";

  static String formattedDate(String? date) {
    if (date == null || date == 'N/A' || date.isEmpty) {
      return 'Date not available';
    }

    try {
      final DateTime parsedDate = DateTime.parse(date).toLocal();
      final DateFormat formatter = DateFormat('MMM dd, yyyy, h:mm a');
      return formatter.format(parsedDate);
    } catch (e) {
      logger.e('Error parsing date: $date, error: $e');
      return 'Invalid date';
    }
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