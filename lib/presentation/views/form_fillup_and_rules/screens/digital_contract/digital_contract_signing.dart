import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/form_fillup_and_rules/view_model/form_fill_and_rules_provider.dart';
import 'package:abbas/presentation/widgets/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../cors/network/api_error_handle.dart';
import '../../../../../cors/routes/route_names.dart';
import '../../../../widgets/primary_button.dart';

class DigitalContractSigning extends ConsumerStatefulWidget {
  final String enrollmentId;

  const DigitalContractSigning({super.key, required this.enrollmentId});

  @override
  ConsumerState<DigitalContractSigning> createState() =>
      _DigitalContractSigningState();
}

class _DigitalContractSigningState
    extends ConsumerState<DigitalContractSigning> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _digitalSignatureController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// ---------------------- Selected Date -------------------------------------
  Future<void> _selectedDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      _dateController.text = formattedDate;
    }
  }

  /// ------------------------ Convert to ISO ----------------------------------
  String convertToIso(String date) {
    final parseDate = DateTime.parse(date);
    return parseDate.toUtc().toIso8601String();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _digitalSignatureController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Digital Contract Signing',
              style: TextStyle(
                fontSize: 24.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please Review the agreement and sign to\ncomplete enrollment.',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFA5A5AB),
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: const Color(0xFF0A1A29),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('👋 ', style: TextStyle(fontSize: 18.sp)),
                      Text(
                        'Course Enrollment Agreement',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'This agreement is entered into between the\nStudent and Acting Academy',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  const _RulePoint(
                    '',
                    'Code of Conduct : Students must maintain professional behavior at all times. Disruptive behavior, harassment, or violation of academy policies may result in immediate dismissal without refund. Students are expected to respect instructors, staff, and fellow students.',
                  ),
                  SizedBox(height: 12.h),
                  const _RulePoint(
                    ' Intellectual Property: All course materials, including scripts, exercises, and teaching methods, remain the intellectual property of Acting Academy. Students may not reproduce, distribute, or use these materials outside of the course without written permission.',
                    '',
                  ),
                  SizedBox(height: 12.h),
                  const _RulePoint(
                    '',
                    ' Liability and Insurence: Students participate in physical activities at their own risk. Acting Academy maintains general liability insurance but recommends students have personal health insurance. The academy is not liable for personal injuries or property damage during course activities.',
                  ),
                  SizedBox(height: 12.h),
                  const _RulePoint(
                    '',
                    'Photography and Recording :  Students consent to being photographed or recorded during classes for educational and promotional purposes. Students who do not wish to be included in promotional materials must notify the academy in writing.',
                  ),
                  SizedBox(height: 12.h),
                  const _RulePoint(
                    'Force Majeure: In the event of circumstances beyond our control (natural disasters, pandemics, government regulations), the academy reserves the right to modify course delivery methods or schedules. Alternative arrangements, including online instruction, may be implemented.',
                    '',
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Checkbox(
                  value: ref.watch(acknowledgeProvider),
                  onChanged: (bool? value) {
                    ref.read(acknowledgeProvider.notifier).state =
                        value ?? false;
                  },
                  activeColor: Colors.black,
                  checkColor: Colors.white,
                ),
                Expanded(
                  child: Text(
                    'I have read, understood, and agree to all terms and conditions .',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Image.asset('assets/images/vector_line.png'),
            SizedBox(height: 24.h),
            Text(
              'Digital Signature',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10.h),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  _buildFormSection(
                    'Full Name',
                    _buildTextField(
                      'Enter your full name',
                      controller: _fullNameController,
                      validator: nameValidator,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildFormSection(
                    'Digital Signature',
                    _buildTextField(
                      'Type your full name as signature',
                      controller: _digitalSignatureController,
                      validator: digitalSignatureValidator,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildFormSection(
                    'Date',
                    _buildTextField(
                      'Select Date',
                      controller: _dateController,
                      validator: dateValidator,
                      suffixIcon: GestureDetector(
                        onTap: _selectedDate,
                        child: Icon(Icons.calendar_month, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    if (!ref.watch(acknowledgeProvider)) {
                      Utils.showToast(
                        msg: "Please accept rules and regulations",
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                      return;
                    }
                    final isoDate = convertToIso(_dateController.text);
                    logger.d(
                      "Submitting with enrollmentId: ${widget.enrollmentId}",
                    );

                    final result = await ref
                        .read(acceptContractTermsProvider.notifier)
                        .acceptContractTerms(
                          accepted: true,
                          fullName: _fullNameController.text.trim(),
                          digitalSignature: _digitalSignatureController.text
                              .trim(),
                          digitalSignatureDate: isoDate,
                          enrollmentId: widget.enrollmentId,
                        );

                    if (result.success) {
                      Utils.showToast(
                        msg: result.message,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      );
                      if (context.mounted) {
                        Navigator.pushNamed(
                          context,
                          RouteNames.payment,
                          arguments: widget.enrollmentId,
                        );
                      }
                    } else {
                      Utils.showToast(
                        msg: result.message,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  }
                },
                color: const Color(0xFFE9201D),
                textColor: Colors.white,
                icon: '',
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
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

class _RulePoint extends StatelessWidget {
  final String title;
  final String description;

  const _RulePoint(this.title, this.description, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•    ',
          style: TextStyle(fontSize: 16.sp, color: Colors.white),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(text: ' $description'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildTextField(
  String hintText, {
  int? maxLines,
  TextInputType? keyboardType,
  TextEditingController? controller,
  FocusNode? focusNode,
  Widget? suffixIcon,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    focusNode: focusNode,
    keyboardType: keyboardType,
    maxLines: maxLines,
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
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: const Color(0xFF3D4566), width: 1.w),
      ),
    ),
    validator: validator,
  );
}
