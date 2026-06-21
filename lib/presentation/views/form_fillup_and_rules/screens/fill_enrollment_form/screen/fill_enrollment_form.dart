import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/form_fillup_and_rules/utils/enrollment_navigator.dart';
import 'package:abbas/presentation/views/form_fillup_and_rules/view_model/form_fill_and_rules_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:abbas/presentation/widgets/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../course_screen/view_model/get_all_courses_provider.dart';

class FillEnrollmentForm extends ConsumerStatefulWidget {
  final String courseId;

  const FillEnrollmentForm({super.key, required this.courseId});

  @override
  ConsumerState<FillEnrollmentForm> createState() => _FillEnrollmentFormState();
}

class _FillEnrollmentFormState extends ConsumerState<FillEnrollmentForm> {
  /// ------------------- TextEditingController --------------------------------
  final TextEditingController _selectedCourse = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _goalsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isCheckingStep = false;
  bool _isTextFieldFocused = false;

  /// -------------------------------  FocusNodes ------------------------------
  final FocusNode _selectCourseFocus = FocusNode();
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();
  final FocusNode _experienceFocus = FocusNode();
  final FocusNode _goalsFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() => _isCheckingStep = true);
      await ref.read(getAllCoursesProvider.notifier).getAllCourses();
      await _checkCurrentStep();
      setState(() => _isCheckingStep = false);
    });

    _selectCourseFocus.addListener(focusListener);
    _fullNameFocus.addListener(focusListener);
    _emailFocus.addListener(focusListener);
    _phoneFocus.addListener(focusListener);
    _addressFocus.addListener(focusListener);
    _dobFocus.addListener(focusListener);
    _experienceFocus.addListener(focusListener);
    _goalsFocus.addListener(focusListener);
  }

  /// -------- Check current step and skip completed steps ---------------------
  Future<void> _checkCurrentStep() async {
    try {
      await EnrollmentNavigator.navigateToCurrentStep(
        context,
        ref,
        courseId: widget.courseId,
        replace: true,
      );
    } catch (e) {
      logger.e("Error checking current step : $e");
    }
  }

  void focusListener() {
    setState(() {
      _isTextFieldFocused =
          _selectCourseFocus.hasFocus ||
          _fullNameFocus.hasFocus ||
          _emailFocus.hasFocus ||
          _phoneFocus.hasFocus ||
          _addressFocus.hasFocus ||
          _dobFocus.hasFocus ||
          _experienceFocus.hasFocus ||
          _goalsFocus.hasFocus;
    });
  }

  @override
  void dispose() {
    _selectCourseFocus.dispose();
    _fullNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _addressFocus.dispose();
    _dobFocus.dispose();
    _experienceFocus.dispose();
    _goalsFocus.dispose();
    _selectedCourse.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dateController.dispose();
    _experienceController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  /// ------------------------- Selected Date Method ---------------------------
  Future<void> _selectedDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      ref.read(selectedDateProvider.notifier).state = pickedDate;
      final formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

      _dateController.text = formattedDate;
    }
  }

  /// ------------------------- Convert Date to ISO ----------------------------
  String convertToIso(String date) {
    final parseDate = DateTime.parse(date);
    return parseDate.toUtc().toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    final getAllCourse = ref.watch(getAllCoursesProvider);
    final courses = getAllCourse.value?.data;

    final targetCourse = courses?.firstWhere(
      (c) => c.id == widget.courseId,
      orElse: () => courses.first,
    );
    // Show loading while checking step
    if (_isCheckingStep) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18.sp),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: AnimatedLoading(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      /// ---------------------- Fetching data from server ---------------------
      // body: getAllCourse.when(
      //   loading: () => const Center(child: CircularProgressIndicator()),
      //   error: (error, stack) => Center(child: Text("Error : $error")),
      //   data: (data) {
      //     final course = data;
      //     if (course == null) {
      //       return const Center(child: Text("No selected course available"));
      //     }
      //
      //     final courses = course.data;
      //
      //     // Check if courses is empty
      //     if (courses == null || courses.isEmpty) {
      //       return const Center(child: Text("No courses available"));
      //     }
      //
      //     final targetCourse = courses.firstWhere(
      //       (c) => c.id == widget.courseId,
      //       orElse: () => courses.first,
      //     );
      //
      //     return
      //   },
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fill Enrollment Form',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
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

                /// -------------------- Selected Course -------------------
                Text(
                  "Selected Course",
                  style: TextStyle(
                    color: const Color(0xFF8C9196),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildTextField(
                  'selected course',
                  initialValue: targetCourse?.title ?? 'N/A',
                  readOnly: true,
                ),

                /// ------------------ Full Name ---------------------------
                _buildFormSection(
                  'Full Name',
                  _buildTextField(
                    'enter your full name',
                    textInputAction: TextInputAction.next,
                    controller: _fullNameController,
                    focusNode: _fullNameFocus,
                    validator: nameValidator,
                  ),
                ),

                /// ------------------- Email ------------------------------
                _buildFormSection(
                  'Email',
                  _buildTextField(
                    'your email',
                    textInputAction: TextInputAction.next,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _emailFocus,
                    validator: emailValidator,
                  ),
                ),

                /// ----------------- Phone --------------------------------
                _buildFormSection(
                  'Phone',
                  _buildTextField(
                    'e.g., +32123 456 789',
                    textInputAction: TextInputAction.next,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    focusNode: _phoneFocus,
                    validator: phoneValidator,
                  ),
                ),

                /// ------------------- Address ----------------------------
                _buildFormSection(
                  'Address',
                  _buildTextField(
                    'Street, City, Country',
                    textInputAction: TextInputAction.next,
                    controller: _addressController,
                    focusNode: _addressFocus,
                    validator: addressValidator,
                  ),
                ),
                SizedBox(height: 8.h),

                /// ----------------- Date of Birth ------------------------
                Text(
                  "Date of Birth",
                  style: TextStyle(
                    color: const Color(0xFF8C9196),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildTextField(
                  'select date of birth',
                  controller: _dateController,
                  readOnly: true,
                  validator: dateOfBirthValidator,
                  suffixIcon: GestureDetector(
                    onTap: _selectedDate,
                    child: Icon(Icons.calendar_month, color: Colors.white),
                  ),
                ),

                /// ------------------- Experience ---------------------------
                _buildFormSection(
                  'Experience',
                  _buildTextField(
                    'e.g., 1 year, beginner, theater background',
                    textInputAction: TextInputAction.next,
                    controller: _experienceController,
                    focusNode: _experienceFocus,
                    validator: experienceLevelValidator,
                  ),
                ),

                /// ----------------- Acting Goals -------------------------
                _buildFormSection(
                  'Acting Goals / Interests',
                  _buildTextField(
                    'tell us why you\'re here...',
                    controller: _goalsController,
                    maxLines: 5,
                    focusNode: _goalsFocus,
                    validator: actingGoalsValidator,
                  ),
                ),
                SizedBox(height: 40.h),

                /// --------------- Save and Continue Button ---------------
                SizedBox(
                  width: double.infinity,
                  height: 60.h,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isLoading = true);

                              try {
                                final result = await ref
                                    .read(enrollPersonalInfoProvider.notifier)
                                    .submitFormFilling(
                                      courseId: widget.courseId,
                                      name: _fullNameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      phone: _phoneController.text.trim(),
                                      address: _addressController.text.trim(),
                                      dateOfBirth: _dateController.text.trim(),
                                      experience:
                                          _experienceController.text.trim(),
                                      actingGoals: _goalsController.text.trim(),
                                    );

                                if (result.success == true) {
                                  Utils.showToast(
                                    msg: result.message.isNotEmpty
                                        ? result.message
                                        : "Form submitted successfully!",
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                  );

                                  if (context.mounted) {
                                    await EnrollmentNavigator
                                        .navigateToCurrentStep(
                                      context,
                                      ref,
                                      courseId: widget.courseId,
                                      replace: true,
                                    );
                                  }
                                } else {
                                  Utils.showToast(
                                    msg: result.message.isNotEmpty
                                        ? result.message
                                        : "Failed to submit form",
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                }
                              } catch (e) {
                                logger.e("Error submitting form: $e");
                                Utils.showToast(
                                  msg: "Error: ${e.toString()}",
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                );
                              } finally {
                                if (mounted) {
                                  setState(() => _isLoading = false);
                                }
                              }
                            }
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
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
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
    String? Function(String?)? validator,
    String? initialValue,
    TextInputAction? textInputAction,
    bool? readOnly,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textInputAction: textInputAction,
      initialValue: initialValue,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: const Color(0xFF3D4566), width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: const Color(0xFF3D4566), width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.white, width: 1.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Color(0xFFE9201D), width: 1.w),
        ),
      ),
      validator: validator,
    );
  }
}
