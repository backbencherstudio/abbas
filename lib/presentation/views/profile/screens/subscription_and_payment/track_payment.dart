import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../cors/routes/route_names.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/secondary_appber.dart';
import '../../widgets/card_widget.dart';

class TrackPayment extends StatefulWidget {
  const TrackPayment({super.key});

  @override
  State<TrackPayment> createState() => _TrackPaymentState();
}

class _TrackPaymentState extends State<TrackPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SecondaryAppBar(title: 'Track Payment'),

            Padding(
              padding: EdgeInsets.all(16.0.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.all(0.0.sp),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteNames.myCourseScreen,
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color(0xff9A1E21),
                                    Color(0xff0A192A),
                                  ],
                                  stops: [0.09, 12],
                                ),
                                boxShadow: [BoxShadow(offset: Offset(0, 0.sp))],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/icons/payment.png",
                                              height: 40.h,
                                              width: 40.w,
                                            ),
                                            SizedBox(width: 12.w),
                                            Text(
                                              "1 year program ( adult) - Monthly\nPayment",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        Row(
                                          children: [
                                            SizedBox(width: 45.w),
                                            Icon(
                                              Icons.attach_money,
                                              size: 20.sp,
                                              color: Color(0xffA5A5AB),
                                            ),
                                            Text(
                                              "150.OO/month • 12 months",
                                              style: TextStyle(
                                                color: Color(0xffA5A5AB),
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),

                                        Row(
                                          children: [
                                            Text(
                                              "Installment Progress",
                                              style: TextStyle(
                                                color: Color(0xffA5A5AB),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              "3 of 12 paid",
                                              style: TextStyle(
                                                color: Color(0xffE9E9EA),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.h),
                                        LinearProgressIndicator(
                                          value: 0.35,
                                          minHeight: 10,
                                          backgroundColor: Color(0xff212D44),
                                          color: Color(0xffE9201D),
                                          borderRadius:
                                              BorderRadiusDirectional.circular(
                                                10.r,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Installment Payment',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.all(0.0.sp),
                    child: GestureDetector(
                      onTap: () {
                        //Navigator.pushNamed(context, RouteNames.myCourseScreen);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Color(0xff030C15), Color(0xff0A1A29)],
                            stops: [0.09, 12],
                          ),
                          border: Border.all(color: Colors.red, width: 0.5.w),
                          boxShadow: [BoxShadow(offset: Offset(0, 0.sp))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Installment #6',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                                Image.asset(
                                  "assets/icons/next_payment.png",
                                  height: 80.h,
                                  width: 100.w,
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Image.asset(
                                  'assets/icons/credit_card.png',
                                  scale: 3,
                                ),
                                SizedBox(width: 8.h),
                                Text(
                                  "August 15, 2025",
                                  style: TextStyle(
                                    color: Color(0xffA5A5AB),
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
                                ),
                                SizedBox(width: 2.h),
                                Icon(
                                  Icons.attach_money,
                                  size: 20,
                                  color: Color(0xffA5A5AB),
                                ),
                                Text(
                                  "150.OO",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            PrimaryButton(
                              onTap: () {},
                              color: Color(0xFFE9201D),
                              textColor: Colors.white,
                              icon: '',
                              child: Text("Payment Now"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: GestureDetector(
                      onTap: () {
                        //Navigator.pushNamed(context, RouteNames.myCourseScreen);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Color(0xFF091725),
                          border: Border.all(color: Colors.red, width: 0.5.w),
                          boxShadow: [BoxShadow(offset: Offset(0, 0.sp))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Installment #5',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                                Image.asset(
                                  "assets/icons/due.png",
                                  height: 40.h,
                                  width: 50.h,
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Image.asset(
                                  'assets/icons/credit_card.png',
                                  scale: 3,
                                ),
                                SizedBox(width: 8.h),
                                Text(
                                  "August 15, 2025",
                                  style: TextStyle(
                                    color: Color(0xffA5A5AB),
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
                                ),
                                SizedBox(width: 2.h),
                                Icon(
                                  Icons.attach_money,
                                  size: 20,
                                  color: Color(0xffA5A5AB),
                                ),
                                Text(
                                  "150.OO",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            PrimaryButton(
                              onTap: () {},
                              color: Color(0xFFE9201D),
                              textColor: Colors.white,
                              icon: '',
                              child: Text("Payment Now"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Completed Installments',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  InstallmentCard(
                    installmentTitle: 'Installment #4',
                    date: 'August 15, 2025',
                    amount: '150.00',
                    nextPaymentImage: 'assets/icons/paid.png',
                    buttonTitle: '',
                    onTapCard: () {},
                    onTapButton: () {},
                    showPrimaryButton: false,
                    buttonColor: Colors.transparent,
                    buttonTextColor: Colors.white,
                  ),
                  SizedBox(height: 15.h),
                  InstallmentCard(
                    installmentTitle: 'Installment #3',
                    date: 'August 15, 2025',
                    amount: '150.00',
                    nextPaymentImage: 'assets/icons/paid.png',
                    buttonTitle: '',
                    onTapCard: () {},
                    onTapButton: () {},
                    showPrimaryButton: false,
                    buttonColor: Colors.transparent,
                    buttonTextColor: Colors.white,
                  ),
                  SizedBox(height: 15.h),
                  InstallmentCard(
                    installmentTitle: 'Installment #2',
                    date: 'August 15, 2025',
                    amount: '150.00',
                    nextPaymentImage: 'assets/icons/paid.png',
                    buttonTitle: '',
                    onTapCard: () {},
                    onTapButton: () {},
                    showPrimaryButton: false,
                    buttonColor: Colors.transparent,
                    buttonTextColor: Colors.white,
                  ),
                  SizedBox(height: 15.h),
                  InstallmentCard(
                    installmentTitle: 'Installment #1',
                    date: 'August 15, 2025',
                    amount: '150.00',
                    nextPaymentImage: 'assets/icons/paid.png',
                    buttonTitle: '',
                    onTapCard: () {},
                    onTapButton: () {},
                    showPrimaryButton: false,
                    buttonColor: Colors.transparent,
                    buttonTextColor: Colors.white,
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
