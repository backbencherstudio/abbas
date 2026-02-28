import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../cors/routes/route_names.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),
                Text(
                  'Profile Setup',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                _buildFormSection(
                    'Full Name',
                    _buildTextField('Enter your full name',
                        controller: _fullNameController,
                        focusNode: _fullNameFocus)),
                _buildFormSection(
                    'Email for Invoice',
                    _buildTextField('your@email.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailFocus)),
                _buildFormSection(
                    'Phone',
                    _buildTextField('e.g., +32123 456 789',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        focusNode: _phoneFocus)),
                _buildFormSection('Date of Birth', _buildDateField()),
                _buildFormSection('Experience Level', _buildFormFillField()),
                _buildFormSection(
                    'Acting Goals / Interests',
                    _buildTextField('Tell us why you\'re here...',
                        controller: _goalsController,
                        maxLines: 5,
                        focusNode: _goalsFocus)),
                SizedBox(height: 30.h),
                SizedBox(
                  width: double.infinity,
                  height: 60.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.parentScreen);
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
                      'Complete Profile Setup',
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
          const BorderSide(color: Color(0xFF3D4566), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide:
          const BorderSide(color: Color(0xFF3D4566), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide:
          const BorderSide(color: Color(0xFF3D4566), width: 1),
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
          const BorderSide(color: Color(0xFF3D4566), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide:
          const BorderSide(color: Color(0xFF3D4566), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide:
          const BorderSide(color: Color(0xFF3D4566), width: 1),
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
        suffixIcon: Padding(
          padding: EdgeInsets.all(12.w),
          child: SvgPicture.asset('assets/icons/arrow_down.svg',
              width: 20.w, height: 20.h),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide:
          const BorderSide(color: Color(0xFF3D4566), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide:
          const BorderSide(color: Color(0xFF3D4566), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide:
          const BorderSide(color: Color(0xFF3D4566), width: 1),
        ),
      ),
    );
  }
}
