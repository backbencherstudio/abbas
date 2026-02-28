
import 'package:abbas/presentation/widgets/primary_button.dart';
import 'package:abbas/presentation/widgets/transparent_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cors/routes/route_names.dart';

class CustomCard extends StatelessWidget {
  final String title; // main course title
  final String subtitle; // subtitle like "by Prof. Anderson"
  final String date; // "12 July, Monday"
  final String time; // "1:30 PM"
  final IconData dateIcon; // calendar icon
  final IconData timeIcon; // time icon

  const CustomCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.dateIcon,
    required this.timeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color(0xFF030C15), Color(0xFFFF1B1B)],
          stops: [0.2989, 0.9353],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),

          Text(
            subtitle,
            style: TextStyle(
              color: Color(0xFFD2D2D5),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 12.h),

          Row(
            children: [
              Icon(dateIcon, color: Color(0xFFE9201D), size: 16.sp),
              SizedBox(width: 6.w),
              Text(
                date,
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
              SizedBox(width: 20.w),
              Icon(timeIcon, color: Color(0xFFE9201D), size: 16.sp),
              SizedBox(width: 6.w),
              Text(
                time,
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          TransparentTextField(
            title: 'Course Module',
            onTap: () {
              Navigator.pushNamed(context, RouteNames.courseModules);
            },
          ),
          SizedBox(height: 15.h),
          PrimaryButton(
            onTap: () {},
            title: 'Enroll Now',
            color: Colors.white,
            textColor: Colors.black87,
          ),
        ],
      ),
    );
  }
}
