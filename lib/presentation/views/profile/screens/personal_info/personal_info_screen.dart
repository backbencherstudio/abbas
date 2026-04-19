import 'package:abbas/presentation/views/profile/view_model/profile_screen_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../cors/routes/route_names.dart';
import '../../../../../cors/theme/app_colors.dart';
import '../../../../widgets/secondary_appber.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<ProfileScreenProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const AnimatedLoading();
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }
          final profile = provider.profile?.data;

          final name = profile?.name ?? "N/A";
          final email = profile?.email ?? "N/A";
          final phone = profile?.phoneNumber ?? "N/A";
          final birthdate = profile?.dateOfBirth;
          final level = profile?.experienceLevel ?? "N/A";
          final goals = profile?.actingGoals?.actingGoals ?? "N/A";

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SecondaryAppBar(
                title: 'Personal Info',
                hasButton: true,
                isEdit: true,
                onEditButtonTap: () {
                  Navigator.pushNamed(
                    context,
                    RouteNames.editPersonalInfoScreen,
                  );
                },
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(
                        context,
                        title: 'Full Name',
                        content: name,
                      ),

                      _buildInfoSection(
                        context,
                        title: 'Email for Invoice',
                        content: email,
                      ),

                      _buildInfoSection(
                        context,
                        title: 'Phone',
                        content: phone,
                      ),

                      _buildInfoSection(
                        context,
                        title: 'Date of Birth',
                        content: birthdate != null
                            ? _formatDate(birthdate)
                            : "N/A",
                      ),

                      _buildInfoSection(
                        context,
                        title: 'Experience Level',
                        content: level,
                      ),

                      _buildInfoSection(
                        context,
                        title: 'Acting Goals/Interests',
                        content: goals,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(String date) {
    try {
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
    } catch (e) {
      return date;
    }
  }

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
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.greyTextColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(content, style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}
