import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../cors/routes/route_names.dart';
import '../../../../widgets/secondary_appber.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  String? selectedReason;


  final reasons = [
    "Hate Speech or Offensive Behavior",
    'Inappropriate Content',
    ' Harassment or Bullying',
    'Spam or Scam',
    ' False Information',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030C15),
      body: Column(
        children: [
          SecondaryAppBar(title: 'Report', hasButton: true),
          SingleChildScrollView(
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
                      color: Color(0xFFD2D2D5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ...reasons.map(
                    (r) => Container(
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xff0A1A29),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Color(0xFF3D4566),
                          width: 1.h,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          r,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.reportUserScreen,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



}
