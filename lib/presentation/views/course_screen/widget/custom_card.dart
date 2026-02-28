import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String time;
  final IconData dateIcon;
  final IconData timeIcon;
  final VoidCallback click;

  const CourseCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.dateIcon,
    required this.timeIcon,
    required this.click,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: click,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 8,vertical: 7),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Color(0xff0A1A2A),
        ),
        child: Row(
          children: [
            Image.asset('assets/images/face.png'),
            SizedBox(width: 20,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 16,color: Colors.white,),
                    ],
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
