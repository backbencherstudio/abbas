import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_screen_provider.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../profile/view_model/profile_screen_provider.dart';

class ReportUserScreen extends StatefulWidget {
  final String reason;

  const ReportUserScreen({super.key, required this.reason});

  @override
  State<ReportUserScreen> createState() => _ReportUserScreenState();
}

class _ReportUserScreenState extends State<ReportUserScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileScreenProvider>(context);
    final data = profileProvider.otherProfileModel?.data;
    final userId = data?.id ?? "N/A";
    return Scaffold(
      backgroundColor: Color(0xff030C15),
      body: Column(
        children: [
          SecondaryAppBar(title: 'Report User', hasButton: true),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Color(0xff0A1A29),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Color(0xff3D4566), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reason for Reporting',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xff8C9196),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        widget.reason,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Reason",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xFFB2B5B8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  margin: EdgeInsets.only(bottom: 24.h),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Color(0xff3D4566), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _messageController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Describe the occasion...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[400],
                      ),
                    ),
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final message = _messageController.text;
                      final res = await context
                          .read<CommunityScreenProvider>()
                          .report(
                            reason: widget.reason,
                            description: message,
                            userId: userId,
                          );

                      if (res.success == true) {
                        Utils.showToast(
                          msg: res.message,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteNames.parentScreen,
                            (route) => false,
                          );
                        }
                      } else {
                        Utils.showToast(
                          msg: res.message,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xff030C15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child:
                        context.watch<CommunityScreenProvider>().isLoading ==
                            true
                        ? const CircularProgressIndicator(color: Colors.black)
                        : Text(
                            'Submit Report',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
