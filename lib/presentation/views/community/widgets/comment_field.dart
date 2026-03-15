import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../cors/theme/app_colors.dart';
import '../../../widgets/custom_text_field.dart';

class CommentField extends StatefulWidget {
  const CommentField({super.key});

  @override
  State<CommentField> createState() => _CommentFieldState();
}

class _CommentFieldState extends State<CommentField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: TextEditingController(),
              hintText: 'Comment Here...',
              maxLines: 1,
              suffixIcon: Icon(Icons.emoji_emotions_outlined,)
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.splashRed,
              borderRadius: BorderRadius.circular(90.r),
            ),
            child: SvgPicture.asset('assets/icons/send.svg', height: 28.h, width: 28.w,),
          )
        ],
      ),
    );
  }
}
