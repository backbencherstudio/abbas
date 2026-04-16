import 'package:abbas/cors/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../widgets/secondary_appber.dart';

class SupportUser extends StatefulWidget {
  const SupportUser({super.key});

  @override
  State<SupportUser> createState() => _SupportUserState();
}

class _SupportUserState extends State<SupportUser> {
  final TextEditingController _goalsController = TextEditingController();
  final FocusNode _goalsFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SecondaryAppBar(title: 'Support User'),
          SizedBox(height: 10.h,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTextEdit(context,'Reason for Support:', 'Account or Login Issues'),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormSection(
                          'Message',
                          _buildTextField('Describe the reason..',
                              controller: _goalsController,
                              maxLines: 5,
                              focusNode: _goalsFocus)),

                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.pushNamed(context, RouteNames.profileSetup);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
Widget _buildTextEdit(BuildContext context, String title, String subTitle) {
  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: GestureDetector(
      onTap: (){},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Color(0xff0A1A29),
          border: Border.all(
            color: Color(0xff3D4566),
            width: 0.5,
          ),
          boxShadow: const [
            BoxShadow(offset: Offset(0, 0)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500,color: Color(0xFF8C9196)),
                ),
               SizedBox(height: 10.h,),
            Text(
              subTitle,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    ),
  );
}

Widget _buildFormSection(String label, Widget child) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 16),
      Text(
        label,
        style: const TextStyle(
            color: Color(0xFF8C9196), fontSize: 16, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 8),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Color(0xFF3D4566), width: 1),
      ),
    ),
  );
}

