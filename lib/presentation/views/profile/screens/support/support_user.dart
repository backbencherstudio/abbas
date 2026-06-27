import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/profile/view_model/support_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/secondary_appber.dart';

class SupportUser extends StatefulWidget {
  final String reason;

  const SupportUser({super.key, required this.reason});

  @override
  State<SupportUser> createState() => _SupportUserState();
}

class _SupportUserState extends State<SupportUser> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitSupport() async {
    final message = _messageController.text.trim();

    if (message.isEmpty) {
      Utils.showToast(
        msg: 'Please describe your issue before submitting.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final res = await context.read<SupportProvider>().submitSupport(
          reason: widget.reason,
          message: message,
        );

    if (!mounted) return;

    if (res.success) {
      Utils.showToast(
        msg: res.message,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
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
    final isLoading = context.watch<SupportProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Support'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          'Reason for Support:',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF8C9196),
                            fontWeight: FontWeight.w500,
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
                    'Message',
                    style: TextStyle(
                      color: const Color(0xFF8C9196),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _messageController,
                    maxLines: 6,
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Describe the reason...',
                      hintStyle: TextStyle(
                        color: const Color(0xFF8C9196),
                        fontSize: 16.sp,
                      ),
                      contentPadding: EdgeInsets.all(16.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: Color(0xff3D4566)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: Color(0xff3D4566)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: Color(0xff3D4566)),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitSupport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xff030C15),
                        disabledBackgroundColor: Colors.white54,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
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
                              'Submit',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
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
