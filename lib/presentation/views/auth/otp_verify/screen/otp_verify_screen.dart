import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../../cors/theme/app_text_styles.dart';
import '../../../../viewmodels/auth/otp_verify/otp_verify_viewmodel.dart';
import '../../../../widgets/primary_button.dart';
import '../widgets/pinput_widget.dart';
import '../widgets/resend_otp_section_widget.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
            SizedBox(height: 20.h),
            _buildHeader(),
            SizedBox(height: 32.h),
            PinputWidget(context: context, pinController: _pinController),
            SizedBox(height: 60.h),
            ResendOtpSectionWidget(email: email),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
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
          'Code sent to your email',
          style: AppTextStyles.textTheme.bodyMedium?.copyWith(
            color: AppColors.lightGreyTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton(BuildContext context, String email) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
      child: Consumer<OtpVerifyViewmodel>(
        builder: (context, viewModel, child) {
          return PrimaryButton(
            onTap: viewModel.isButtonEnable
                ? () async {
                    await viewModel.verifyOTP(email, viewModel.otp);
                    if (viewModel.otpVerified) {
                      Navigator.pushNamed(
                        context,
                        RouteNames.setNewPasswordScreen,
                        arguments: {'email': email, 'otp': viewModel.otp},
                      );
                    }
                  }
                : () {},
            color: viewModel.isButtonEnable
                ? AppColors.activeButtonColor
                : AppColors.inactiveButtonColor,
            textColor: AppColors.white,
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Consumer<OtpVerifyViewmodel>(
      builder: (context, viewModel, child) {
        return viewModel.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : const SizedBox();
      },
    );
  }
}
