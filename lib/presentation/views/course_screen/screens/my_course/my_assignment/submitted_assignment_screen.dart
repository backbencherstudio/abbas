
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../widgets/secondary_appber.dart';
import '../../../../profile/widgets/download_receipt_card.dart';

class SubmittedAssignmentScreen extends StatelessWidget {
  const SubmittedAssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030D15),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SecondaryAppBar(title: "Assignment 6"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  Text(
                    "Class 3 : Scene Analysis Report",
                    style: TextStyle(
                      color: Color(0xffFFFFFF),
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "Module 1: Personal Development",
                    style: TextStyle(
                      color: Color(0xff8C9196),
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.red),
                      SizedBox(width: 6.w),
                      Text(
                        "Due : 2 days",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 0.7, color: Color(0xff8C9196)),

                  Text(
                    "Assignment",
                    style: TextStyle(color: Color(0xffFFFFFF)),
                  ),

                  SizedBox(height: 12),
                  Text(
                    "Write a 2-page analysis of your assigned scene focusing on character objectives, obstacles, and tactics. Include your personal approach to the character.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.containerColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.subContainerColor, width: 1.5.w),
                    ),
                    child: Column(
                      spacing: 8.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Assignment Submitted', style: Theme.of(context).textTheme.titleLarge),
                        Divider(),
                        Text('Science 1', style: Theme.of(context).textTheme.titleLarge),
                        Text('This is assignment'),
                        SizedBox(height: 8.h),
                        LediKhadashProtiva(title: 'class-1-assignment.pdf', hasIcon: false,),

                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, RouteNames.parentScreen),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/arrow_back.svg', height: 22.w, width: 22.w),
                          SizedBox(width: 7),
                          Text(
                            "Back to Home",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: Color(0xff8D9CDC),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
