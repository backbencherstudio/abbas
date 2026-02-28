
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../cors/routes/route_names.dart';
import '../../../../widgets/primary_button.dart';

class DigitalContractSigning extends StatefulWidget {
  const DigitalContractSigning({Key? key}) : super(key: key);

  @override
  _DigitalContractSigningState createState() => _DigitalContractSigningState();
}

class _DigitalContractSigningState extends State<DigitalContractSigning> {
  bool _isAcknowledged = false;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _digitalSignatureController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

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
                fontWeight: FontWeight.bold,
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
              padding: EdgeInsets.all(16.w),
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
                          fontSize: 20.sp,
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
                  value: _isAcknowledged,
                  onChanged: (bool? value) {
                    setState(() {
                      _isAcknowledged = value ?? false;
                    });
                  },
                  activeColor: Colors.black,
                ),
                Expanded(
                  child: Text(
                    'I have read, understood, and agree to all terms and conditions .',
                    style: TextStyle(fontSize: 16.sp),
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
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            _buildFormSection('Full Name', _buildTextField('Enter your full name')),
            SizedBox(height: 10.h),
            _buildFormSection('Digital Signature', _buildTextField('Type your full name as signature')),
            SizedBox(height: 10.h),
            _buildFormSection('Date', _buildTextField('Type Date')),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.payment);
                },
                title: 'Submit',
                color: const Color(0xFFE9201D),
                textColor: Colors.white,
                icon: '',
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

  const _RulePoint(this.title, this.description, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('•    ', style: TextStyle(fontSize: 16.sp, color: Colors.white)),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.w400),
              children: [
                TextSpan(
                  text: title,
                  style: TextStyle(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.w400),
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
  );
}
