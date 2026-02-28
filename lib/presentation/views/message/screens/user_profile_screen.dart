import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/secondary_appber.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: Column(
        children: [
          SecondaryAppBar(title: "User"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 12.h),
                ClipOval(
                  child: Image.asset(
                    "assets/images/profile.png",
                    width: 100.w,
                    height: 100.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Cameron Williamson",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff0A1A2A),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "@cameron_williamson",
                    style: TextStyle(
                      color: const Color(0xff5F6CA0),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    mainSection(title: "Audio", icon: Icons.call),
                    SizedBox(width: 20.w),
                    mainSection(title: "Video", icon: Icons.videocam),
                    SizedBox(width: 20.w),
                    mainSection(
                      title: "Mute",
                      icon: Icons.notification_important,
                    ),
                    SizedBox(width: 20.w),

                    mainSection(title: "Profile", icon: Icons.person),
                  ],
                ),
                SizedBox(height: 20),

                Divider(thickness: 0.7),
                SizedBox(height: 0),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Action",
                    style: TextStyle(color: Color(0xffB2B5B8)),
                  ),
                ),

                SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    action(title: "View media & file", icon: Icons.file_copy),
                    SizedBox(height: 20.h),
                    action(title: "Share contact", icon: Icons.share),
                    SizedBox(height: 20.h),

                    action(
                      title: "Report",
                      icon: Icons.report_problem_outlined,
                    ),
                    SizedBox(height: 20.h),

                    action(
                      title: "Delete conversations",
                      icon: Icons.delete_outline,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget action({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(
          icon,
          color: title == "Delete conversations"
              ? Colors.red
              : Color(0xff8D9CDC),
          size: 20.sp,
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget mainSection({required String title, required IconData icon}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: const Color(0xff0A1A2A),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Icon(icon, color: const Color(0xff8D9CDC), size: 24.sp),
        ),
        SizedBox(height: 5.h),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
      ],
    );
  }
}
