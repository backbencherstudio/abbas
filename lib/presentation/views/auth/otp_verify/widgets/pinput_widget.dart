import 'package:abbas/presentation/views/auth/view_model/signup_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import '../../../../../cors/theme/app_colors.dart';
import '../../../../../cors/theme/app_text_styles.dart';

class PinPutWidget extends ConsumerStatefulWidget {
  const PinPutWidget({
    super.key,
    required TextEditingController pinController,
    required this.context,
  }) : _pinController = pinController;

  final TextEditingController _pinController;
  final BuildContext context;

  @override
  ConsumerState<PinPutWidget> createState() => _PinPutWidgetState();
}

class _PinPutWidgetState extends ConsumerState<PinPutWidget> {
  final pinTheme = PinTheme(
    width: 65.w,
    height: 65.h,
    textStyle: AppTextStyles.textTheme.bodyLarge?.copyWith(
      color: AppColors.white,
    ),
    decoration: BoxDecoration(
      color: Colors.transparent,
      border: Border.all(color: AppColors.borderColor),
      borderRadius: BorderRadius.circular(16.r),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Pinput(
            onChanged: (value) {
              ref.read(otpTextProvider.notifier).state = value;
            },
            length: 4,
            controller: widget._pinController,
            defaultPinTheme: pinTheme,
            focusedPinTheme: pinTheme.copyWith(
              decoration: pinTheme.decoration!.copyWith(
                border: Border.all(color: AppColors.primary),
              ),
            ),
            submittedPinTheme: pinTheme.copyWith(
              decoration: pinTheme.decoration!.copyWith(
                border: Border.all(color: AppColors.primary),
              ),
            ),
            onCompleted: (pin) =>
                ref.read(otpTextProvider.notifier).state = pin,
            separatorBuilder: (index) => SizedBox(width: 14.w),
          ),
        ),
      ],
    );
  }
}
