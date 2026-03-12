import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/presentation/views/form_fillup_and_rules/model/enroll_personal_info_model.dart';
import 'package:abbas/presentation/views/form_fillup_and_rules/view_model/form_fill_and_rules_provider.dart';
import 'package:abbas/presentation/widgets/validator.dart';
import 'package:abbas/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../cors/routes/route_names.dart';
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
  final TextEditingController _goalsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isCheckingStep = false; // Add this flag
  bool _isTextFieldFocused = false;

  /// GlobalKey for the experience field to get its position
  final GlobalKey _experienceFieldKey = GlobalKey();

  /// -------------------------------  FocusNodes ------------------------------
  final FocusNode _selectCourseFocus = FocusNode();
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _dobFocus = FocusNode();
  final FocusNode _goalsFocus = FocusNode();

  /// ----------------- Enroll Personal Info Model -----------------------------
  Data? data;

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
    _goalsFocus.addListener(focusListener);
  }

  /// -------- Check current step for the selected course ----------------------
  Future<void> _checkCurrentStep() async {
    try {
      await ref
          .read(currentStepProvider.notifier)
          .currentStep(courseId: widget.courseId);

      final currentStepState = ref.read(currentStepProvider);

      currentStepState.whenData((stepModel) {
        if (stepModel != null && mounted) {
          final currentStep = stepModel.data?.step;
          final enrollmentId = stepModel.data?.enrollmentId;

          logger.d("Current step for course ${widget.courseId} : $currentStep");

          // Only navigate if we're NOT on the current screen
          // If step is FORM_FILLING, stay on this screen (don't navigate)
          if (currentStep == 'RULES_SIGNING') {
            Navigator.pushReplacementNamed(
                context,
                RouteNames.rulesRegulations,
                arguments: enrollmentId
            );
          } else if (currentStep == 'CONTRACT_SIGNING') {
            Navigator.pushReplacementNamed(
                context,
                RouteNames.digitalContractSigning,
                arguments: enrollmentId
            );
          } else if (currentStep == 'PAYMENT') {
            Navigator.pushReplacementNamed(
                context,
                RouteNames.payment,
                arguments: enrollmentId
            );
          } else if (currentStep == 'COMPLETED') {
            Navigator.pushReplacementNamed(context, RouteNames.parentScreen);
          }
          // If currentStep == 'FORM_FILLING', do nothing - stay on this page
        }
      });
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
    _goalsFocus.dispose();
    _selectedCourse.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
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
          "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      final dobController = ref.read(dobControllerProvider.notifier);
      dobController.state.text = formattedDate;
    }
  }

  /// ------------------------- Show Experience Level Popup --------------------
  void _showExperienceLevelPopup() {
    final RenderBox? renderBox =
    _experienceFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    showMenu<String>(
      context: context,
      position:
      RelativeRect.fromLTRB(
        renderBox.size.width - 200.w,
        renderBox.size.height + 5.h,
        0,
        0,
      ).shift(
        Offset(
          renderBox.localToGlobal(Offset.zero).dx,
          renderBox.localToGlobal(Offset.zero).dy,
        ),
      ),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      items: [
        PopupMenuItem<String>(
          value: 'BEGINNER',
          child: Container(
            width: 200.w,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text('BEGINNER', style: TextStyle(fontSize: 14.sp)),
          ),
        ),
        PopupMenuItem<String>(
          value: 'MID-LEVEL',
          child: Container(
            width: 200.w,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text('MID-LEVEL', style: TextStyle(fontSize: 14.sp)),
          ),
        ),
        PopupMenuItem<String>(
          value: 'ADVANCED',
          child: Container(
            width: 200.w,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text('ADVANCED', style: TextStyle(fontSize: 14.sp)),
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        ref.read(experienceLevelProvider.notifier).state = value;
        ref.read(experienceControllerProvider.notifier).state.text = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final getAllCourse = ref.watch(getAllCoursesProvider);
    final experienceController = ref.watch(experienceControllerProvider);

    // Show loading while checking step
    if (_isCheckingStep) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18.sp),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      /// ---------------------- Fetching data from server ---------------------
      body: getAllCourse.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error : $error")),
        data: (data) {
          final course = data;
          if (course == null) {
            return const Center(child: Text("No selected course available"));
          }

          final courses = course.data;

          // Check if courses is empty
          if (courses == null || courses.isEmpty) {
            return const Center(child: Text("No courses available"));
          }

          return SingleChildScrollView(
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
                    ...courses.map(
                          (value) => _buildTextField(
                        'selected course',
                        initialValue: value.title ?? 'N/A',
                        readOnly: true,
                      ),
                    ).toList(),

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
                      controller: ref.watch(dobControllerProvider),
                      readOnly: true,
                      validator: dateOfBirthValidator,
                      suffixIcon: GestureDetector(
                        onTap: _selectedDate,
                        child: Icon(Icons.calendar_month, color: Colors.white),
                      ),
                    ),

                    /// ------------------- Experience Level -------------------
                    SizedBox(height: 8.h),
                    Text(
                      "Experience Level",
                      style: TextStyle(
                        color: const Color(0xFF8C9196),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      key: _experienceFieldKey,
                      child: _buildTextField(
                        'select experience level',
                        controller: experienceController,
                        readOnly: true,
                        validator: experienceLevelValidator,
                        suffixIcon: GestureDetector(
                          onTap: _showExperienceLevelPopup,
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 32.sp,
                            color: Colors.white,
                          ),
                        ),
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
                        onPressed: _isLoading ? null : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);

                            try {
                              // Get the selected date from provider
                              final selectedDate = ref.read(selectedDateProvider);
                              final formattedDate = selectedDate != null
                                  ? "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}"
                                  : '';

                              // Get the selected course title
                              final courseTitle = courses.first.title ?? '';

                              logger.d("Submitting enrollment data: ${{
                                "course_type": courseTitle,
                                "full_name": _fullNameController.text,
                                "email": _emailController.text,
                                "phone": _phoneController.text,
                                "address": _addressController.text,
                                "date_of_birth": formattedDate,
                                "experience_level": experienceController.text,
                                "acting_goals": _goalsController.text,
                                "course_id": widget.courseId,
                              }}");

                              final result = await ref
                                  .read(enrollPersonalInfoProvider.notifier)
                                  .postEnrollPersonalInfo(
                                courseType: courseTitle,
                                fullName: _fullNameController.text.trim(),
                                email: _emailController.text.trim(),
                                phone: _phoneController.text.trim(),
                                address: _addressController.text.trim(),
                                dateOfBirth: formattedDate,
                                experienceLevel: experienceController.text,
                                actingGoals: _goalsController.text.trim(),
                                enrollmentId: widget.courseId,
                              );

                              logger.d("Enrollment result: ${result.data?.id}");

                              if (result.success == true) {
                                Utils.showToast(
                                  msg: result.message ?? "Form submitted successfully!",
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                );

                                if (context.mounted) {
                                  // After successful submission, check current step again
                                  await _checkCurrentStep();
                                }
                              } else {
                                Utils.showToast(
                                  msg: result.message ?? "Failed to submit form",
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
          );
        },
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
          borderSide: BorderSide(color: const Color(0xFF3D4566), width: 1.5.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: const Color(0xFF3D4566), width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: const Color(0xFF3D4566), width: 1.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.redAccent, width: 1.w),
        ),
      ),
      validator: validator,
    );
  }
}