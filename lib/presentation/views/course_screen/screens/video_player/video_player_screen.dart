import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../cors/theme/app_colors.dart';
import '../../../../widgets/secondary_appber.dart';

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SecondaryAppBar(title: 'Videos',),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Text('Class-01.mp4'),
                SizedBox(height: 16.h),
                Container(
                  height: 300.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
