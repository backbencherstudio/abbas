import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_screen_provider.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ReportUserScreen extends StatefulWidget {
  final String userId;
  final String reason;

  const ReportUserScreen({
    super.key,
    required this.userId,
    required this.reason,
  });

  @override
  State<ReportUserScreen> createState() => _ReportUserScreenState();
}

class _ReportUserScreenState extends State<ReportUserScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    final description = _messageController.text.trim();

    if (widget.userId.isEmpty) {
      Utils.showToast(
        msg: 'User not found. Please try again.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (description.isEmpty) {
      Utils.showToast(
        msg: 'Please describe the reason for your report.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final res = await context.read<CommunityScreenProvider>().report(
          reason: widget.reason,
          description: description,
          userId: widget.userId,
        );

    if (!mounted) return;

    if (res.success == true) {
      Utils.showToast(
        msg: res.message,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Utils.showToast(
        msg: res.message,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<CommunityScreenProvider>().isLoading;

    return Scaffold(
      backgroundColor: const Color(0xff030C15),
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Report User', hasButton: true),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xff0A1A29),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xff3D4566)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reason for reporting:',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xff8C9196),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          widget.reason,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Reason',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFFB2B5B8),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xff3D4566)),
                    ),
                    child: TextField(
                      controller: _messageController,
                      maxLines: 6,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Describe the reason...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF8C9196),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xff030C15),
                        disabledBackgroundColor: Colors.white54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 22.h,
                              width: 22.w,
                              child: const CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Submit Report',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
