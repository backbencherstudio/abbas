import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../cors/theme/app_colors.dart';

class CommentWidget extends StatelessWidget {
  final Map<String, dynamic> comment;

  const CommentWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final bool isSender = comment['isSender'] ?? false;
    final String senderName = comment['senderName'] ?? 'Unknown';
    final String message = comment['message'] ?? '';
    final String time = comment['time'] ?? '';

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/background_img.png'),
          ),
          SizedBox(width: 12.w),
          SizedBox(
            width: 210.w,
            child: Column(
              crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  width: 210.w,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.subContainerColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(senderName, style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4.h),
                      Text(message),
                      SizedBox(height: 4.h),
                      Text(time, style: TextStyle(fontSize: 10, color: Colors.grey[400])),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(Icons.favorite, size: 16, color: Colors.redAccent),
                    SizedBox(width: 6.w),
                    Text('4.8k'),
                    SizedBox(width: 16.w),
                    Icon(Icons.reply_outlined, size: 16.sp, color: Colors.white),
                    SizedBox(width: 6.w),
                    Text('Reply'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
