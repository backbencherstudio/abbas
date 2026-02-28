import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../cors/di/injection.dart';
import '../../../../../cors/routes/route_names.dart';
import '../../../../../cors/theme/app_colors.dart';
import '../../../../../cors/theme/app_text_styles.dart';
import '../../../../viewmodels/auth/forgot_password/forgot_password_viewmodel.dart';
import '../../../../widgets/custom_appbar_back_button.dart';
import '../../../../widgets/primary_button.dart';
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ForgotPasswordViewModel>(
        create: (_) => getIt<ForgotPasswordViewModel>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(
                      children: [
                        CustomAppbarBackButton(
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),

                          Text(
                            'Forgot Password?',
                            style: AppTextStyles.textTheme.headlineMedium?.copyWith(
                              color: AppColors.white,
                            ),
                          ),

                          SizedBox(height: 32.h),

                          Text(
                            'Email',
                            style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                              color: AppColors.lightGreyTextColor,
                            ),
                          ),

                          SizedBox(height: 8.h),

                          Consumer<ForgotPasswordViewModel>(
                            builder: (context, viewModel, child) {
                              return TextField(
                                onChanged: (value) {
                                  viewModel.setEmail(value);
                                },
                                style: TextStyle(color: AppColors.white),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  hintText: 'Enter Email',
                                  hintStyle: AppTextStyles.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.greyTextColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                    borderSide: BorderSide(color: AppColors.borderColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                    borderSide: BorderSide(color: AppColors.primary),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                    borderSide: BorderSide(color: AppColors.borderColor),
                                  ),
                                ),
                              );
                            },
                          ),

                          Consumer<ForgotPasswordViewModel>(
                            builder: (context, viewModel, child) {
                              if (viewModel.errorMessage != null) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Text(
                                    viewModel.errorMessage!,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              }
                              return SizedBox();
                            },
                          ),

                          // Consumer<ForgotPasswordViewModel>(
                          //   builder: (context, viewModel, child) {
                          //     if (viewModel.otpSent) {
                          //       return Padding(
                          //         padding: EdgeInsets.only(top: 8.h),
                          //         child: Text(
                          //           '✓ OTP sent successfully! Check your email.',
                          //           style: TextStyle(color: Colors.green),
                          //         ),
                          //       );
                          //     }
                          //     return SizedBox();
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: Column(
                      children: [
                        Consumer<ForgotPasswordViewModel>(
                          builder: (context, viewModel, child) {
                            return PrimaryButton(
                              onTap: viewModel.isButtonEnable && !viewModel.isLoading
                                  ? () async {
                                await viewModel.sendOTP();
                                if (viewModel.otpSent) {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.otpVerifyScreen,
                                    arguments: viewModel.email,
                                  );
                                }
                              }
                                  : (){},
                              title: 'Send',
                              color: viewModel.isButtonEnable && !viewModel.isLoading
                                  ? AppColors.activeButtonColor
                                  : AppColors.inactiveButtonColor,
                              textColor: AppColors.white,
                            );
                          },
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ],
              ),

              Consumer<ForgotPasswordViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}