
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../cors/routes/route_names.dart';
import '../../../../widgets/secondary_appber.dart';

class CourseModuleScreen extends StatelessWidget {
  const CourseModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030D15),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SecondaryAppBar(title: "Module-1"),
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Module: Personal Development",
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Divider(color: Color(0xff3D4566), thickness: 0.7),
                Text(
                  "Module OverView",
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 10.h),
                Text(
                  "This module develops the actor’s self-awareness, confidence, and creativity as a foundation for authentic performance.",
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Key Learning Outcomes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                Row(
                  children: [
                    Icon(Icons.star_rate_outlined, color: Colors.red, size: 14),
                    SizedBox(width: 7.w),
                    Text(
                      "Gain self-awareness",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.star_rate_outlined, color: Colors.red, size: 14),
                    SizedBox(width: 7.w),
                    Text(
                      "Boost creativity and focus",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.star_rate_outlined, color: Colors.red, size: 14),
                    SizedBox(width: 7.w),
                    Text(
                      "Improve communication skills",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),
                Row(
                  children: [
                    Text(
                      "All Classes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xff1E273D),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Text(
                        "Module-1",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),
                Column(
                  spacing: 12.h,
                  children: List.generate(
                    3,
                    (index) => _buildClassContainer(
                      title: 'Class-${index + 1}',
                      subtitle: 'Script Analysis',
                      onTap: () => Navigator.pushNamed(context, RouteNames.myClassScreen),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassContainer({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Color(0xff8D9CDC), width: 3.w),
          ),
          color: Color(0xff0A1A2A),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color(0xff8D9CDC),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
