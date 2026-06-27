import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../cors/routes/route_names.dart';
import '../../../../widgets/secondary_appber.dart';

class ReportListPage extends StatelessWidget {
  final String userId;

  const ReportListPage({super.key, required this.userId});

  static const _reasons = [
    'Hate Speech or Offensive Behavior',
    'Inappropriate Content',
    'Harassment or Bullying',
    'Spam or Scam',
    'False Information',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030C15),
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Report', hasButton: true),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    Text(
                      'Why are you reporting this user?',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Select a reason for reporting this user. Your report will remain confidential.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFFD2D2D5),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ..._reasons.map(
                      (reasonTitle) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Material(
                          color: const Color(0xff0A1A29),
                          borderRadius: BorderRadius.circular(12.r),
                          child: InkWell(
                            onTap: () {
                              if (userId.isEmpty) return;
                              Navigator.pushNamed(
                                context,
                                RouteNames.reportUserScreen,
                                arguments: {
                                  'userId': userId,
                                  'reason': reasonTitle,
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: const Color(0xFF3D4566),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      reasonTitle,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.sp,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
