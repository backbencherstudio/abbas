import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../cors/theme/app_colors.dart';
import '../../../../widgets/secondary_appber.dart';
import '../../widgets/download_receipt_card.dart';

class PaymentHistory extends StatelessWidget {
  const PaymentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SecondaryAppBar(title: 'Payment History'),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                spacing: 16.h,
                children: List.generate(3, (index) {
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
          DottedBorder(
            color: Colors.grey,
            strokeWidth: 1,
            dashPattern: const [10, 5],
            borderType: BorderType.RRect,
            radius: Radius.circular(12.r),
            child: SizedBox(
              height: 100.h,
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: AppColors.background,
                ),
                child: Column(
                  spacing: 4.h,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoRow(context, 'Transaction ID:', '81724829345'),
                    _buildInfoRow(context, 'Amount:', '\$150'),
                    //_buildInfoRow(context, 'Payment Date', '17 june 2025'),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          LediKhadashProtiva(title: 'Payment Receipt',),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String title, String value) {
    return Row(
      children: [
        Text(
          '$title  ',
          style: Theme.of(context,).textTheme.bodyMedium?.copyWith(color: AppColors.greyTextColor),
        ),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
