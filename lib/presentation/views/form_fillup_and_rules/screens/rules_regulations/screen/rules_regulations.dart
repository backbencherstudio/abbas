import 'package:abbas/presentation/views/form_fillup_and_rules/view_model/form_fill_and_rules_provider.dart';
import 'package:abbas/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../widgets/primary_button.dart';

class RulesRegulations extends ConsumerStatefulWidget {
  final String enrollmentId;

  const RulesRegulations({super.key, required this.enrollmentId});

  @override
  ConsumerState<RulesRegulations> createState() => _RulesRegulationsState();
}

class _RulesRegulationsState extends ConsumerState<RulesRegulations> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _digitalSignatureController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
              'Rules & Regulations Signing',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please read and accept our rules to continue\nenrollment.',
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('👋 ', style: TextStyle(fontSize: 18)),
                      Text(
                        'Welcome to CINACT',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Welcome to CINACT Acting School. Before\nproceeding, please read and acknowledge\nthe following terms.',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  _RulePoint(
                    'Minimum Attendance:',
                    'Students must maintain\na minimum of 85% attendance in all\nclasses and practical sessions to be\neligible for examinations.',
                  ),
                  SizedBox(height: 12),
                  _RulePoint(
                    'Discrimination Policy:',
                    'Our institution has zero\ntolerance for discrimination based\non race, gender, religion, sexual orientation,\nor any other protected characteristic.',
                  ),
                  SizedBox(height: 12),
                  _RulePoint(
                    'Facility Usage:',
                    'All facilities and equipment must be used responsibly and only under proper supervision when required.',
                  ),
                  SizedBox(height: 12),
                  _RulePoint(
                    'Punctuality:',
                    'Students are expected to arrive on\ntime for all scheduled activities.\nRepeated tardiness may result in\ndisciplinary action.',
                  ),
                  SizedBox(height: 12),
                  _RulePoint(
                    'Incident Reporting:',
                    'Any accidents, injuries, or safety concerns must be immediately reported to the appropriate staff members.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Checkbox(
                  value: ref
                      .watch(acceptRulesRegulationsProvider.notifier)
                      .isAcknowledged,
                  onChanged: (bool? value) {
                    ref
                        .read(acceptRulesRegulationsProvider.notifier)
                        .setAcknowledge(value);
                  },
                  activeColor: Colors.black,
                ),
                Expanded(
                  child: Text(
                    'I acknowledge and agree to the school rules and regulations.',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Image.asset('assets/images/vector_line.png', width: 1.sw),
            SizedBox(height: 24.h),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Text(
                    'Digital Signature',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildFormSection(
                    'Full Name',
                    _buildTextField('Enter your full name'),
                  ),
                  SizedBox(height: 10.h),
                  _buildFormSection(
                    'Digital Signature',
                    _buildTextField('Type your full name as signature'),
                  ),
                  SizedBox(height: 10.h),
                  _buildFormSection('Date', _buildTextField('Type Date')),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          final result = await ref
                              .read(acceptRulesRegulationsProvider.notifier)
                              .acceptRulesRegulations(
                                accepted: true,
                                fullName: _fullNameController.text.trim(),
                                signature: _digitalSignatureController.text
                                    .trim(),
                                signedAt: _dateController.text.trim(),
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
                                RouteNames.digitalContractSigning,
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
                      title: 'Submit Acknowledgment',
                      color: const Color(0xFFE9201D),
                      textColor: Colors.white,
                      icon: '',
                    ),
                  ),
                ],
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
