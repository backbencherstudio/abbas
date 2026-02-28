import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../profile/widgets/download_receipt_card.dart';


class VideoWidget extends StatelessWidget {
  const VideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Module 1: Personal Development",
              //       style: TextStyle(
              //         color: Color(0xffB2B5B8),
              //         fontWeight: FontWeight.w600,
              //         fontSize: 16.sp,
              //       ),
              //     ),
              //     Icon(Icons.arrow_drop_down, color: Colors.white),
              //   ],
              // ),
              SizedBox(height: 10.h),
              Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                child: ExpansionTile(
                  //   spacing: 8.h,
                  title: Text('Module 1: Personal Development',
                    style: TextStyle(
                      color: const Color(0xffB2B5B8),
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),),
                  children: List.generate(4, (index) {
                    return LediKhadashProtiva(title: 'Class-0${index + 1}.mp4', isVideo: true);
                  }),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Module 2: Script Analysis",
                    style: TextStyle(
                      color: Color(0xffB2B5B8),
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
              SizedBox(height: 10.h),
              Column(
                spacing: 8.h,
                children: List.generate(4, (index) {
                  return LediKhadashProtiva(title: 'Class-0${index + 1}.mp4', isVideo: true);
                }),
              ),
              SizedBox(height: 30.h,)
            ],
          ),
        ),
      ),
    );
  }
}
