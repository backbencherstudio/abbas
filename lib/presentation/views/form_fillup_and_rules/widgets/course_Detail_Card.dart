import 'package:abbas/presentation/views/form_fillup_and_rules/widgets/subtitle_Content_Row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseDetailCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String content;

  const CourseDetailCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: const Color(0xFF0A1A29),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(
            color: const Color(0xFF3D4566),
            width: 1.w,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'The lessons consist of 4 modules:',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SubtitleContentRow(
                  subtitle: '⊹', content: 'Module 1: Personal development'),
              SubtitleContentRow(subtitle: '⊹', content: 'Module 2: Script Analysis'),
              SubtitleContentRow(subtitle: '⊹', content: 'Module 3: Meisner'),
              SubtitleContentRow(subtitle: '⊹', content: 'Module 4: Auditioning'),
              SizedBox(height: 20.h),
              Text(
                'In addition to the lessons, this package also\nincludes:',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SubtitleContentRow(
                  subtitle: '⊹', content: 'A certificate of the training completed'),
              SubtitleContentRow(
                  subtitle: '⊹', content: '1 scene that you can add to your portfolio'),
              SubtitleContentRow(subtitle: '', content: '     access to casting platform Spotlight'),
            ],
          ),
        ),
      ),
    );
  }
}
