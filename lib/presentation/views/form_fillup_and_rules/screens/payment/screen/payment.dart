import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../cors/routes/route_names.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

enum PaymentType { oneTime, monthly }

class _PaymentState extends State<Payment> {
  PaymentType? _paymentType = PaymentType.oneTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030C15), // Dark gray background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
          onPressed: () {
            Navigator.pop(context);
          },
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
              'Choose a payment option and enter your details to enroll.',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFA5A5AB),
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              'Payment Type',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPaymentTypeRadio(
                  title: 'One-time',
                  value: PaymentType.oneTime,
                ),
                _buildPaymentTypeRadio(
                  title: 'Monthly Installments',
                  value: PaymentType.monthly,
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Row(
              children: [
                Text(
                  '|',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: const Color(0xFFE9201D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 5.w),
                Text(
                  'Monthly plans includes extra charges*',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFFA5A5AB),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            _buildPaymentMethodSection(),
            SizedBox(height: 10.h),
            _buildFormSection(
              'Account Holder Name',
              _buildTextField('Your full name'),
            ),
            _buildFormSection(
              'Card Number',
              _buildTextField('1234 5678 9012 3456'),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildFormSection(
                    'Expire Date',
                    _buildTextField('MM/YY'),
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: _buildFormSection('CVC', _buildTextField('123')),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(12.r),
              color: const Color(0xFF3D4566),
              strokeWidth: 1.5,
              dashPattern: [6.w, 5.w],
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'You\'ll receive a digital invoice to your mail after successful payment',
                          style: TextStyle(
                            color: const Color(0xFFA5A5AB),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.profileSetup);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50914),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
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

  Widget _buildPaymentTypeRadio({
    required String title,
    required PaymentType value,
  }) {
    return Row(
      children: [
        Radio<PaymentType>(
          value: value,
          groupValue: _paymentType,
          onChanged: (PaymentType? newValue) {
            setState(() {
              _paymentType = newValue;
            });
          },
          activeColor: const Color(0xFFE9201D),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A29),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Payment Method',
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
          Row(
            children: [
              Text(
                'Only',
                style: TextStyle(
                  color: const Color(0xFF5F6CA0),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 5.w),
              SizedBox(
                height: 20.h,
                child: Image.asset('assets/icons/stripe.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF8C9196),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        child,
      ],
    );
  }

  Widget _buildTextField(
      String hintText, {
        int? maxLines,
        TextInputType? keyboardType,
        TextEditingController? controller,
        FocusNode? focusNode,
      }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 15.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF3D4566), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF3D4566), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Color(0xFF3D4566), width: 1),
        ),
      ),
    );
  }
}
