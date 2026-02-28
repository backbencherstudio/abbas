import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../widgets/primary_button.dart';

class CourseWidget extends StatelessWidget {
  const CourseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff0A1A2A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xff1E2B42),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Text("Next Class"),
                  ),

                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 40,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.red, width: 3),
                      ),
                      color: Colors.transparent,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Class-4: Boost creativity and focus",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Module-1: Personal Development",
                          style: TextStyle(
                            color: Color(0xff8D9CDC),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month, color: Colors.red, size: 20),
                        SizedBox(width: 7),
                        Text("Monday", style: TextStyle(color: Colors.white)),
                        SizedBox(width: 10),
                        Icon(Icons.access_time, color: Colors.red, size: 20),
                        SizedBox(width: 7),
                        Text("10:00 AM", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  DottedBorder(
                    padding: EdgeInsets.all(16),
                    borderType: BorderType.RRect,
                    radius: Radius.circular(16.r),
                    color: Color(0xFF3D4566),
                    strokeWidth: 1.5,
                    dashPattern: [6, 5],
                    child: Text(
                      'Today’s class will start from 11:00 AM.',
                      style: TextStyle(
                        color: Color(0xffF9C80E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => Navigator.pushNamed(context, RouteNames.assetsScreen),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/folder.svg'),
                                SizedBox(width: 4.w),
                                TextButton(
                                  onPressed: (){Navigator.pushNamed(context, RouteNames.assetsScreen);}, 
                                  child: Text("Assets",
                                    style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/video.svg'),
                                SizedBox(width: 4.w),
                                Text("Join Class", style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500), ),
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
          ),

          Padding(
            padding: EdgeInsets.only(left: 16.w, top: 16.h, bottom: 16),
            child: Text(
              "All Module",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.courseModuleScreen);
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,

                          end: Alignment.bottomLeft,
                          colors: [Color(0xff3D151E), Color(0xff071220)],
                        ),
                        borderRadius: BorderRadius.circular(6),
                        border: Border(
                          left: BorderSide(color: Color(0xffE9201D), width: 2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Module-1",
                                style: TextStyle(color: Colors.white),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed:() {Navigator.pushNamed(context,RouteNames.courseModuleScreen);},
                                icon: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                          Text(
                            "Personal Development",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Color(0xff0A1A2A),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.borderColor)
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/instructor.svg', height: 20.h, width: 20.w,),
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
                        child: Icon(Icons.person_2, color: AppColors.grey,)
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
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                  color: Color(0xff0A1A2A),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.borderColor)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
