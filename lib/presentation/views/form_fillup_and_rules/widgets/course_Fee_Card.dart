import 'package:abbas/presentation/views/form_fillup_and_rules/widgets/subtitle_Content_Row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/course_module/screen/course_module.dart';
class CourseFeeCard extends StatelessWidget {
  const CourseFeeCard({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Course Fee:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Image.asset('assets/icons/amount.png',scale:2.sp)
              ],
            ),
             SizedBox(height: 16.h),
            const Text(
              'Installment Process:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
             SizedBox(height: 8.h),
            const Text(
              'One-time',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF8D9CDC),
              ),
            ),
            SubtitleContentRow( subtitle: '⊹', content:
            'You pay the full amount at once.'
            ), SubtitleContentRow( subtitle: '⊹', content:
            'No recurring payments or extra charges.'
            ),
             SizedBox(height: 8.h),
            Text('Monthly Installments',style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xFF8D9CDC),
            ),),
            SubtitleContentRow( subtitle: '⊹', content:
            'You pay the total amount in smaller,\nrecurring monthly payments.'
            ), SubtitleContentRow( subtitle: '⊹', content:
            'Extra charges may apply, as noted by the\nline: "Monthly plans include extra charges".'
            ),
          ],
        ),
      ),
    );
  }
}
