import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../cors/theme/app_colors.dart';
import '../../../../../cors/theme/app_text_styles.dart';
import '../../../../viewmodels/auth/otp_verify/otp_verify_viewmodel.dart';

class ResendOtpSectionWidget extends StatelessWidget {
  final String email;

  const ResendOtpSectionWidget({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Consumer<OtpVerifyViewmodel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            // Resend OTP section
            Center(
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Didn't get the OTP?  ",
                          style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        TextSpan(
                          text: 'Resend',
                          style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                            color: viewModel.canResend && !viewModel.isLoading
                                ? AppColors.radishTextColor
                                : AppColors.greyTextColor,
                          ),
                          recognizer: viewModel.canResend && !viewModel.isLoading
                              ? (TapGestureRecognizer()
                            ..onTap = () async {
                              await viewModel.resendOTP(email);
                            })
                              : null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    viewModel.resendCountdown > 0
                        ? "You can resend code in ${viewModel.resendCountdown}s"
                        : "You can resend code now",
                    style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
