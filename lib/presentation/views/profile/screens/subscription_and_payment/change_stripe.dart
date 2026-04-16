
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../cors/routes/route_names.dart';
import '../../../../widgets/secondary_appber.dart';


class ChangeStripe extends StatefulWidget {
  const ChangeStripe({super.key});

  @override
  State<ChangeStripe> createState() => _ChangeStripeState();
}

class _ChangeStripeState extends State<ChangeStripe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SecondaryAppBar(title: 'Change Stripe Payment Account'),
          Padding(
            padding:  EdgeInsets.all(16.0.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormSection(
                  'Account Holder Name',
                  _buildTextField('Your full name'),
                ),
                _buildFormSection(
                  'Card Number',
                  _buildTextField('1234 5678 9012 3456'),
                ),
                 SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildFormSection('Expire Date', _buildTextField('MM/YY'),),
                    ),
                     SizedBox(width: 20.w),
                    Expanded(
                      child: _buildFormSection('CVC', _buildTextField('123')),
                    ),
                  ],
                ),

                 SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.profileSetup);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding:  EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: const Text(
                      'Update Account',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                 SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildFormSection(String label, Widget child) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
       SizedBox(height: 16.h),
      Text(
        label,
        style: const TextStyle(
          color: Color(0xFF8C9196),
          fontSize: 14,
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
      contentPadding:  EdgeInsets.symmetric(
        horizontal: 16.0.w,
        vertical: 15.0.h,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0.r),
        borderSide:  BorderSide(color: Color(0xFF3D4566), width: 1.5.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0.r),
        borderSide:  BorderSide(color: Color(0xFF3D4566), width: 1.5.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0.r),
        borderSide:  BorderSide(color: Color(0xFF3D4566), width: 1.w),
      ),
    ),
  );
}
