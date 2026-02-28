
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../cors/routes/route_names.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../../../widgets/primary_button.dart';
import '../../../../../widgets/secondary_appber.dart';

class DueAssignmentScreen extends StatelessWidget {
  const DueAssignmentScreen({super.key});

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
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffF9C80E)),
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xff0A1A2A),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Submit Assignment",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                        Divider(thickness: 0.7, color: Color(0xff3D4566)),
                        Text(
                          "Assignment Title",
                          style: TextStyle(color: Color(0xffB2B5B8)),
                        ),
                        SizedBox(height: 10),
                        CustomTextField(hintText: "Enter assignment title"),

                        SizedBox(height: 10.h),
                        Text(
                          "Description",
                          style: TextStyle(color: Color(0xffB2B5B8)),
                        ),
                        SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Enter description",
                          maxLines: 5,
                        ),
                        SizedBox(height: 20),
                        DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(16.r),
                          color: Color(0xFF3D4566),
                          strokeWidth: 1.5,
                          dashPattern: [6, 5],
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 80,
                              vertical: 30,
                            ),
                            child: Column(
                              children: [
                                SvgPicture.asset("assets/icons/upload.svg"),
                                SizedBox(height: 10),
                                Text(
                                  "Drag & drop files here",
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Drag & drop files here",
                                  style: TextStyle(color: Color(0xff8C9196), fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        PrimaryButton(title: "Submit", onTap: () {
                          Navigator.pushNamed(context, RouteNames.submittedAssignmentScreen);
                        },color: Color(0xFFE9201D),textColor: Colors.white, icon: '',),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
