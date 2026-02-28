import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../cors/routes/route_names.dart';

class FillEnrollmentForm extends StatefulWidget {
  const FillEnrollmentForm({super.key});

  @override
  State<FillEnrollmentForm> createState() => _FillEnrollmentFormState();
}

class _FillEnrollmentFormState extends State<FillEnrollmentForm> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _goalsController = TextEditingController();

  bool _isLoading = false;
  bool _isTextFieldFocused = false;

  final _formKey = GlobalKey<FormState>();
  String? _selectedExperienceLevel;

  // FocusNodes
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();
  final FocusNode _goalsFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    void focusListener() {
      setState(() {
        _isTextFieldFocused = _fullNameFocus.hasFocus ||
            _emailFocus.hasFocus ||
            _phoneFocus.hasFocus ||
            _addressFocus.hasFocus ||
            _dobFocus.hasFocus ||
            _goalsFocus.hasFocus;
      });
    }

    _fullNameFocus.addListener(focusListener);
    _emailFocus.addListener(focusListener);
    _phoneFocus.addListener(focusListener);
    _addressFocus.addListener(focusListener);
    _dobFocus.addListener(focusListener);
    _goalsFocus.addListener(focusListener);
  }

  @override
  void dispose() {
    _fullNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _addressFocus.dispose();
    _dobFocus.dispose();
    _goalsFocus.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fill Enrollment Form',
            style: TextStyle(fontSize: 18.sp, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18.sp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fill Enrollment Form',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Join our acting program and take your first\nstep towards your dreams',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFFA5A5AB),
                  ),
                ),
                SizedBox(height: 16.h),
                _buildFormSection(
                  'Selected Course',
                  Text('2 -Years Training (Adult)',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                ),
                _buildFormSection(
                    'Full Name',
                    _buildTextField('Enter your full name',
                        controller: _fullNameController,
                        focusNode: _fullNameFocus)),
                _buildFormSection(
                    'Email',
                    _buildTextField('Your Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailFocus)),
                _buildFormSection(
                    'Phone',
                    _buildTextField('e.g., +32123 456 789',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        focusNode: _phoneFocus)),
                _buildFormSection(
                    'Address',
                    _buildTextField('Street, City, Country',
                        controller: _addressController,
                        focusNode: _addressFocus)),
                _buildFormSection('Date of Birth', _buildDateField()),
                _buildFormSection('Experience Level', _buildFormFillField()),
                _buildFormSection(
                    'Acting Goals / Interests',
                    _buildTextField('Tell us why you\'re here...',
                        controller: _goalsController,
                        maxLines: 5,
                        focusNode: _goalsFocus)),
                SizedBox(height: 40.h),
                SizedBox(
                  width: double.infinity,
                  height: 60.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.rulesRegulations);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: _isTextFieldFocused
                          ? Colors.white
                          : (_isLoading
                          ? Colors.white
                          : const Color(0xFF3D4566)),
                      backgroundColor: _isTextFieldFocused
                          ? const Color(0xFFE9201D)
                          : (_isLoading
                          ? const Color(0xFFE9201D)
                          : const Color(0xFF0A1A29)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      'Save & Continue',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: _isTextFieldFocused
                            ? Colors.white
                            : (_isLoading
                            ? Colors.white
                            : const Color(0xFF3D4566)),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
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
              fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8.h),
        child,
      ],
    );
  }

  Widget _buildTextField(String hintText,
      {int? maxLines,
        TextInputType? keyboardType,
        TextEditingController? controller,
        FocusNode? focusNode}) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding:
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide:
          BorderSide(color: const Color(0xFF3D4566), width: 1.5.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide:
          BorderSide(color: const Color(0xFF3D4566), width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide:
          BorderSide(color: const Color(0xFF3D4566), width: 1.w),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      focusNode: _dobFocus,
      readOnly: true,
      onTap: () async {
        // Show date picker
      },
      decoration: InputDecoration(
        hintText: 'mm/dd/yyyy',
        hintStyle: TextStyle(fontSize: 14.sp),
        suffixIcon: Padding(
          padding: EdgeInsets.all(12.w),
          child: Image.asset(
            'assets/images/calender.png',
            width: 24.w,
            height: 24.h,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide:
          BorderSide(color: const Color(0xFF3D4566), width: 1.5.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide:
          BorderSide(color: const Color(0xFF3D4566), width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide:
          BorderSide(color: const Color(0xFF3D4566), width: 1.w),
        ),
      ),
    );
  }

  Widget _buildFormFillField() {
    return TextFormField(
      readOnly: true,
      onTap: () async {},
      decoration: InputDecoration(
        hintText: 'Select',
        hintStyle: TextStyle(fontSize: 14.sp),
        suffixIcon: Padding(
          padding: EdgeInsets.all(12.w),
          child: SvgPicture.asset('assets/icons/arrow_down.svg',
              width: 20.w, height: 20.h),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide:
          BorderSide(color: const Color(0xFF3D4566), width: 1.5.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide:
          BorderSide(color: const Color(0xFF3D4566), width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide:
          BorderSide(color: const Color(0xFF3D4566), width: 1.w),
        ),
      ),
    );
  }
}
