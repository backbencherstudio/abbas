import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../../../cors/theme/app_colors.dart';
import '../../../../../cors/theme/app_text_styles.dart';
import '../../../../viewmodels/auth/otp_verify/otp_verify_viewmodel.dart';

class PinputWidget extends StatelessWidget {
  const PinputWidget({
    super.key,
    required TextEditingController pinController,
    required this.context,
  }) : _pinController = pinController;

  final TextEditingController _pinController;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Consumer<OtpVerifyViewmodel>(
      builder: (context, viewModel, child) {
        final hasError = viewModel.hasError;
        final pinTheme = PinTheme(
          width: 65.w,
          height: 65.h,
          textStyle: AppTextStyles.textTheme.bodyLarge?.copyWith(color: AppColors.white),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: hasError ? Colors.red : AppColors.borderColor),
            borderRadius: BorderRadius.circular(16.r),
          ),
        );

        return Column(
          children: [
            Pinput(
              onChanged: (value) {
                viewModel.setOtp(value);
              },
              length: 4,
              controller: _pinController,
              defaultPinTheme: pinTheme,
              focusedPinTheme: pinTheme.copyWith(
                decoration: pinTheme.decoration!.copyWith(
                  border: Border.all(color: hasError ? Colors.red : AppColors.primary),
                ),
              ),
              submittedPinTheme: pinTheme.copyWith(
                decoration: pinTheme.decoration!.copyWith(
                  border: Border.all(color: hasError ? Colors.red : AppColors.primary),
                ),
              ),
              onCompleted: (pin) => viewModel.setOtp(pin),
              separatorBuilder: (index) => SizedBox(width: 14.w),
            ),

            // Show error message if exists
            if (hasError) ...[
              SizedBox(height: 16.h),
              Text(
                viewModel.errorMessage ?? 'Invalid OTP',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        );
      },
    );
  }
}