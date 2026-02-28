import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubtitleContentCard extends StatelessWidget {
  final String subtitle;
  final String content;

  const SubtitleContentCard({
    super.key,
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
          borderRadius: BorderRadius.circular(12.0.r),
          side: BorderSide(
            color: Color(0xFF3D4566),
            width: 1.w,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
               SizedBox(height: 6.h),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),);
  }
}
