import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/primary_button.dart';

class InstallmentCard extends StatelessWidget {
  final String installmentTitle;
  final String date;
  final String amount;
  final String nextPaymentImage;
  final String buttonTitle;
  final VoidCallback onTapCard;
  final VoidCallback onTapButton;
  final bool showPrimaryButton;
  final Color buttonColor;
  final Color buttonTextColor;

  const InstallmentCard({
    Key? key,
    required this.installmentTitle,
    required this.date,
    required this.amount,
    required this.nextPaymentImage,
    required this.buttonTitle,
    required this.onTapCard,
    required this.onTapButton,
    this.showPrimaryButton = true,
    required this.buttonColor,
    required this.buttonTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.w),
      child: GestureDetector(
        onTap: onTapCard,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [const Color(0xff030C15), const Color(0xff0A1A29)],
              stops: const [0.09, 12],
            ),
            border: Border.all(
              color: Color(0xff3D4566),
              width: 0.5.w,
            ),
            boxShadow: const [
              BoxShadow(offset: Offset(0, 0)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    installmentTitle,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Image.asset(
                    nextPaymentImage,
                    height: 40.h,
                    width: 50.w,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Image.asset(
                    'assets/icons/credit_card.png',
                    scale: 3,
                    color: Color(0xff3D4566),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    date,
                    style: TextStyle(
                      color: const Color(0xffA5A5AB),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Image.asset(
                    'assets/icons/coins_dollar.png',
                    scale: 3,
                    color: Color(0xff3D4566),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.attach_money,
                    size: 20.sp,
                    color: Color(0xffA5A5AB),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    amount,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              if (showPrimaryButton)
                PrimaryButton(
                  onTap: onTapButton,
                  title: buttonTitle,
                  color: buttonColor,
                  textColor: buttonTextColor,
                  icon: '',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
