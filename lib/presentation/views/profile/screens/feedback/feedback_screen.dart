import 'package:flutter/material.dart';
import '../../../../widgets/secondary_appber.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _goalsController = TextEditingController();
  final FocusNode _goalsFocus = FocusNode();

  @override
  void dispose() {
    _goalsController.dispose();
    _goalsFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SecondaryAppBar(title: 'Change Password'),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormSection(
                  'Acting Goals / Interests',
                  _buildTextField(
                    'Tell us why you\'re here...',
                    controller: _goalsController,
                    maxLines: 5,
                    focusNode: _goalsFocus,
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, RouteNames.profileSetup);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          )
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
        style: TextStyle(
          color: Color(0xFF8C9196),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8.h),
      child,
    ],
  );
}

Widget _buildTextShortField(
    String hintText, {
      int? maxLines,
      TextInputType? keyboardType,
      TextEditingController? controller,
      FocusNode? focusNode,
      double? width, // optional width
    }) {
  return SizedBox(
    width: 180.w,
    child: Card(
      color: Colors.transparent,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Color(0xFF3D4566), width: 1.5.w),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Color(0xFF3D4566), width: 1.5.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: Color(0xFF3D4566), width: 1.w),
          ),
        ),
      ),
    ),
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
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Color(0xFF3D4566), width: 1.5.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Color(0xFF3D4566), width: 1.5.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: Color(0xFF3D4566), width: 1.w),
      ),
    ),
  );
}
