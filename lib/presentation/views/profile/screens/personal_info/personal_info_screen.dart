import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../cors/routes/route_names.dart';
import '../../../../../cors/theme/app_colors.dart';
import '../../../../widgets/secondary_appber.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  // ✅ Dummy Data
  final Map<String, String> dummyUser = const {
    "name": "Mohammad Wahab",
    "email": "wahab@gmail.com",
    "phone": "01712345678",
    "dob": "1998-05-10",
    "experience": "Intermediate",
    "goals": "Acting in movies and web series",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SecondaryAppBar(
            title: 'Personal Info',
            hasButton: true,
            isEdit: true,
            onEditButtonTap: () {
              Navigator.pushNamed(context, RouteNames.editPersonalInfoScreen);
            },
          ),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(context,
                      title: 'Full Name', content: dummyUser["name"]!),

                  _buildInfoSection(context,
                      title: 'Email for Invoice', content: dummyUser["email"]!),

                  _buildInfoSection(context,
                      title: 'Phone', content: dummyUser["phone"]!),

                  _buildInfoSection(context,
                      title: 'Date of Birth',
                      content: _formatDate(dummyUser["dob"]!)),

                  _buildInfoSection(context,
                      title: 'Experience Level',
                      content: dummyUser["experience"]!),

                  _buildInfoSection(context,
                      title: 'Acting Goals/Interests',
                      content: dummyUser["goals"]!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Date formatter
  String _formatDate(String date) {
    try {
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
    } catch (e) {
      return date;
    }
  }

  // ✅ Reusable widget
  Widget _buildInfoSection(
      BuildContext context, {
        required String title,
        required String content,
      }) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
            textTheme.bodyMedium?.copyWith(color: AppColors.greyTextColor),
          ),
          SizedBox(height: 4.h),
          Text(content, style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}
