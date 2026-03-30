import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/auth/view_model/signup_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../../cors/theme/app_text_styles.dart';
import '../../../../widgets/primary_button.dart';
import '../widgets/pinput_widget.dart';

class OtpVerifyScreen extends ConsumerStatefulWidget {
  final String email;

  const OtpVerifyScreen({super.key, required this.email});

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  final TextEditingController _pinController = TextEditingController();

  String _email = '';

  @override
  void initState() {
    _email = widget.email;
    ref.read(timeProvider.notifier).restart();
    super.initState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, size: 24.sp, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter OTP Code',
                  style: AppTextStyles.textTheme.headlineMedium?.copyWith(
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Code sent to your email $_email',
                  style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightGreyTextColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            PinPutWidget(context: context, pinController: _pinController),
            SizedBox(height: 32.h),

            /// -------------------------------------- Verify Button ----------
            PrimaryButton(
              onTap: () async {
                if (_pinController.text.length == 4) {
                  final result = await ref
                      .read(authProvider.notifier)
                      .verifyOtp(
                        email: _email,
                        otp: _pinController.text.trim(),
                      );

                  if (result.success) {
                    Utils.showToast(
                      msg: result.message,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    );
                    if (context.mounted) {
                      logger.d("Otp Email $_email");
                      logger.d("Otp code ${_pinController.text.trim()}");
                      Navigator.pushNamed(
                        context,
                        RouteNames.setNewPasswordScreen,
                        arguments: {
                          'email': _email,
                          'otp': _pinController.text.trim(),
                        },
                      );
                    }
                  } else {
                    Utils.showToast(
                      msg: result.message,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                } else {
                  Utils.showToast(
                    msg: "Please enter a valid 4-digit OTP",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              color: AppColors.activeButtonColor,
              child: Text(
                "Verify OTP",
                style: TextStyle(color: AppColors.white),
              ),
            ),

            /// ----------------- Resend OTP section ---------------------------
            SizedBox(height: 16.h),
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't get the OTP?  ",
                        style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: ref.watch(timeProvider) == 0
                            ? () async {
                                var res = await ref
                                    .read(authProvider.notifier)
                                    .resendVerification(email: _email);
                                if (res.success) {
                                  Utils.showToast(
                                    msg: res.message,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                  );
                                } else {
                                  Utils.showToast(
                                    msg: res.message,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                }
                                ref.read(timeProvider.notifier).restart();
                              }
                            : null,
                        child: Text(
                          ref.watch(timeProvider) == 0
                              ? 'Resend Code'
                              : ref
                                    .read(timeProvider.notifier)
                                    .formatTime(ref.watch(timeProvider)),
                          style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                            color: AppColors.splashRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "You can resend code now",
                    style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
