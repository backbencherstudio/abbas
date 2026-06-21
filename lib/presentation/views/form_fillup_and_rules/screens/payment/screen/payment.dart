import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/form_fillup_and_rules/screens/payment/screen/payment_webview_screen.dart';
import 'package:abbas/presentation/views/form_fillup_and_rules/view_model/form_fill_and_rules_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Payment extends ConsumerStatefulWidget {
  final String enrollmentId;

  const Payment({super.key, required this.enrollmentId});

  @override
  ConsumerState<Payment> createState() => _PaymentState();
}

class _PaymentState extends ConsumerState<Payment> {
  bool _isProcessing = false;

  Future<void> _startPayment() async {
    if (widget.enrollmentId.isEmpty) {
      Utils.showToast(
        msg: 'Enrollment not found. Please complete previous steps.',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final checkout = await ref
          .read(stripeCheckoutProvider.notifier)
          .createCheckoutSession(enrollmentId: widget.enrollmentId);

      if (!checkout.success || checkout.sessionUrl == null) {
        Utils.showToast(
          msg: checkout.message.isNotEmpty
              ? checkout.message
              : 'Failed to start payment',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      if (!mounted) return;

      final paymentSuccess = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentWebviewScreen(url: checkout.sessionUrl!),
        ),
      );

      if (!mounted) return;

      if (paymentSuccess == true) {
        Utils.showToast(
          msg: 'Payment completed successfully',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.profileSetup,
          (route) => route.isFirst,
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030C15),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              'Complete Your Payment',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Proceed to payment to complete your enrollment.',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFA5A5AB),
              ),
            ),
            SizedBox(height: 24.h),
            DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: Radius.circular(12.r),
                color: const Color(0xFF3D4566),
                strokeWidth: 1.5,
                dashPattern: [6.w, 5.w],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'You\'ll receive a digital invoice to your email after successful payment.',
                    style: TextStyle(
                      color: const Color(0xFFA5A5AB),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _startPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50914),
                  disabledBackgroundColor: const Color(0xFFE50914),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: _isProcessing
                    ? SizedBox(
                        height: 22.h,
                        width: 22.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Payment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
