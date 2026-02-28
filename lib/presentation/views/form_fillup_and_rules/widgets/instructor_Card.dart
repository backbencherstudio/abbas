import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructorCard extends StatelessWidget {
  final String mainTitle;
  final String details;
  final String iconpath;
  final String icon;
  final String name;


  const InstructorCard({
    super.key,
    required this.mainTitle,
    required this.iconpath,
    required this.icon,
    required this.name,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF0A1A29),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0.r),
        side: BorderSide(
          color: Color(0xFF3D4566),
          width: 1.w,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
        Expanded(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (iconpath != null && iconpath!.isNotEmpty) ...[
                    Image.asset(iconpath!, scale: 3.sp),
                     SizedBox(width: 12.w),
                  ],
                  Text(
                    mainTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                child:  Row(
                  children: [
                    if (icon != null && icon!.isNotEmpty) ...[
                      Image.asset(icon!, scale: 2.sp),

                      SizedBox(width: 15.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                           SizedBox(height: 4.h),
                          Text(
                            details,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],)
                    ],
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
