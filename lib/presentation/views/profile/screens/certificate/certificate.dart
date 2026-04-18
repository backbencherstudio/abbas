import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../cors/theme/app_colors.dart';
import '../../../../widgets/secondary_appber.dart';
import '../../widgets/download_receipt_card.dart';

class Certificate extends StatelessWidget {
  const Certificate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SecondaryAppBar(title: 'Certificate'),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                spacing: 16.h,
                children: List.generate(1, (index) {
                  return _buildReceiptContainer(context);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.containerColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.subContainerColor, width: 1.5.w),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.subContainerColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: SvgPicture.asset('assets/icons/invoice.svg', height: 24.h, width: 24.w,),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text('1 year program ( adult) - Monthly Payment'),
              ),
            ],
          ),
          SizedBox(height: 16.h),
         Row(children: [
           Text('Issued: ',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14.sp,color: Color(0xFF8C9196)),),
           SizedBox(width: 5.h),
           Text('2024-01-20 ',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14.sp),),

         ],),
          SizedBox(height: 16.h),
          LediKhadashProtiva(title: 'Download Certificate',),
        ],
      ),
    );
  }
}
