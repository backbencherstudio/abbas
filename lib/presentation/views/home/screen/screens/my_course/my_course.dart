import 'dart:ui' as BorderType;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../cors/routes/route_names.dart';
class MyCourse extends StatefulWidget {
  const MyCourse({super.key});

  @override
  State<MyCourse> createState() => _MyCourseState();
}

class _MyCourseState extends State<MyCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030C15),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 200.h),
               Image.asset('assets/icons/smile_face.png',scale: 3,),
              SizedBox(height: 40.h,),
              Text('Oops! Content Not Found',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20.sp),),
              SizedBox(height: 5.h,),
              Text("We couldn't find what you're looking for.",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14.sp,color: Color(0xff777980)),),
              SizedBox(height: 40.h,),
              DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  radius: Radius.circular(30.r),
                  color: const Color(0xFF183D62),
                  strokeWidth: 1.5,
                  dashPattern: [6.w, 5.w],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    width: 400.w,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Color(0xff04121F),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What you can do:',
                          style: TextStyle(
                            color:  Color(0xFF8D9CDC),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 5.h,),
                        Row(
                        children: [
                          Icon(Icons.circle,size: 6,color: Color(0xFFB2B5B8),),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "  Go back to the ",
                                  style: TextStyle(
                                    color: const Color(0xFFB2B5B8),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: "Home screen",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          )

                        ],
                      ),Row(
                        children: [
                          Icon(Icons.circle,size: 6,color: Color(0xFFB2B5B8),),
                          Text(
                            '  Enroll course',
                            style: TextStyle(
                              color:  Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),Row(
                        children: [
                          Icon(Icons.circle,size: 6,color: Color(0xFFB2B5B8),),
                          Text(
                            '  Check your internet connection',
                            style: TextStyle(
                              color:  Color(0xFFB2B5B8),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),Row(
                        children: [
                          Icon(Icons.circle,size: 6,color: Color(0xFFB2B5B8),),
                          Text(
                            '  Try again in a few moments',
                            style: TextStyle(
                              color:  Color(0xFFB2B5B8),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.h,),
              GestureDetector(
                onTap: (){Navigator.pushNamed(context, RouteNames.prosHome);},
                child: Text(
                  "Go Back",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xff8D9CDC),     // // underline color
                    decorationThickness: 2,
                    fontSize: 16, // optional
                    fontWeight: FontWeight.w500, // optional
                    color: Color(0xff8D9CDC), // change as needed
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
