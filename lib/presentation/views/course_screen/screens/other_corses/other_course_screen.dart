import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../cors/routes/route_names.dart';
import '../../../../../cors/theme/app_colors.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/secondary_appber.dart';

class OtherCourseScreen extends StatelessWidget {
  const OtherCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030D15),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SecondaryAppBar(title: "Other Courses / Course Details"),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "2 year program (adult)",
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Color(0xff0A1A2A),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Course Overview",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "This course consists of a 2-year period trajectory that runs 1 day a week on Sunday takes place.",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),

                      Divider(color: Color(0xff232E47), thickness: 0.8),
                      SizedBox(height: 9),

                      Row(
                        children: [
                          Icon(Icons.calendar_month, color: Color(0xffE9201D)),
                          SizedBox(width: 6),

                          Text(
                            "Every Monday",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.access_time, color: Color(0xffE9201D)),
                          SizedBox(width: 6.w),
                          Text(
                            "10:00 AM - 12:00 PM",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 9),

                      Divider(color: Color(0xff232E47), thickness: 0.8),

                      SizedBox(height: 9),
                      Text(
                        "Course Module",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "The lessons consist of 4 modules",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.star_rate_outlined,
                            color: Color(0xffE9201D),
                            size: 12,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Module 1: Personal development",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rate_outlined,
                            color: Color(0xffE9201D),
                            size: 12,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Module 2: Script Analysis",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rate_outlined,
                            color: Color(0xffE9201D),
                            size: 12,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Module 3: Meisner",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rate_outlined,
                            color: Color(0xffE9201D),
                            size: 12,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Module 4: Auditioning",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      Text(
                        "In addition to the lessons, this package also\nincludes:",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 10),

                      SizedBox(width: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rate_outlined,
                            color: Color(0xffE9201D),
                            size: 12,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "A certificate of the training completed",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.star_rate_outlined,
                            color: Color(0xffE9201D),
                            size: 12,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "1 scene that you can add to your portfolio",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),

                      Divider(),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/instructor.svg',
                            height: 20.h,
                            width: 20.w,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "Instructor",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),

                      ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.r),
                            color: Color(0xff142331),
                            border: Border.all(
                              color: Color(0xff142331),
                              width: 1.w,
                            ),
                          ),
                          child: Icon(Icons.person_2, color: AppColors.grey),
                        ),
                        title: Text(
                          "Sophie Lambert",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                          ),
                        ),
                        subtitle: Text(
                          "20+ years experience in theater and film. Trained at Royal Academy of Dramatic Art.",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),
                      PrimaryButton(
                        onTap: () {
                          //  Navigator.pushNamed(context, RouteNames.courseModuleScreens);
                          Navigator.pushNamed(
                            context,
                            RouteNames.myCourseScreen,
                          );
                        },
                        color: Color(0xFFE9201D),
                        textColor: Colors.white,
                        icon: '',
                        child: Text("Enroll Now"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
