
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LediKhadashProtiva extends StatelessWidget {
  const LediKhadashProtiva({
    super.key, required this.title, this.hasIcon = true, this.isVideo = false,
  });

  final String title;
  final bool hasIcon;
  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Color(0xFF0D2136),
        borderRadius: BorderRadius.circular(12.r),
        border: BoxBorder.fromLTRB(left: BorderSide(color: Color(0xFF5F6CA0), width: 1.5.w),),
      ),
      child: Row(
        children: [
          SvgPicture.asset(isVideo ? 'assets/icons/video_stroke.svg' : 'assets/icons/pdf.svg', height: 24.h, width: 24.w,),
          SizedBox(width: 16.w),
          Text(title, style: Theme.of(context).textTheme.bodyMedium,),
          Spacer(),
          hasIcon ? isVideo ? Icon(Icons.play_arrow_outlined, color: Colors.red, size: 28.h,) : SvgPicture.asset('assets/icons/download.svg', height: 24.h, width: 24.w,) : SizedBox(),
        ],
      ),
    );
  }
}