
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../cors/routes/route_names.dart';
import '../../../../cors/theme/app_colors.dart';

class SelectCourse extends StatelessWidget {
  const SelectCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Text(
                  'Select Course',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    CourseCard(title: '1 year program ( adult )'),
                    SizedBox(height: 8.h),
                    CourseCard(title: '2 year program ( adult )'),
                    SizedBox(height: 8.h),
                    CourseCard(title: '2 year program ( Kids )'),
                    SizedBox(height: 8.h),
                    CourseCard(title: 'Full package ( Kids )'),
                    SizedBox(height: 8.h),
                    CourseCard(title: 'Full package ( adults )'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String title;

  const CourseCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF0A1A29),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: const Color(0xFF3D4566),
          width: 2.w,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18.sp),
        onTap: () {
          Navigator.pushNamed(context, RouteNames.courseModule);
        },
      ),
    );
  }
}
