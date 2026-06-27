import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../cors/routes/route_names.dart';
import '../../../../../cors/theme/app_colors.dart';
import '../../../../widgets/secondary_appber.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const _topics = [
    'Account or Login Issue',
    'Course or Enrollment Help',
    'Payment & Billing',
    'Technical Support',
    'General Inquiry',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Support'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need Help?',
                    style: textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Select a topic below to contact the admin. We\'re here to assist you.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.greyTextColor,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ..._topics.map(
                    (topic) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Material(
                        color: AppColors.containerColor,
                        borderRadius: BorderRadius.circular(12.r),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.supportUser,
                              arguments: topic,
                            );
                          },
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.subContainerColor,
                                width: 1.5.w,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    topic,
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16.sp,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
