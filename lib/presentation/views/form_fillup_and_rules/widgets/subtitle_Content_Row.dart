import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class SubtitleContentRow extends StatelessWidget {
  final String subtitle;
  final String content;

  const SubtitleContentRow({
    super.key,
    required this.subtitle,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE9201D),
          ),
        ),
         SizedBox(width: 6.w),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
