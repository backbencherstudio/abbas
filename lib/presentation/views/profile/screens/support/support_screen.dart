
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../cors/routes/route_names.dart';
import '../../../../../cors/theme/app_colors.dart';
import '../../../../widgets/secondary_appber.dart';
import '../../widgets/option_card.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SecondaryAppBar(title: 'Support'),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              spacing: 16.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Need Help?", style: textTheme.headlineSmall,),
                Text("Select a topic below to contact the admin. We're here to assist you.", style: textTheme.bodyMedium?.copyWith(color: AppColors.greyTextColor),),
                OptionCard(title: 'Account or Login Issue', iconPath: '', route: RouteNames.supportUser, hasPrefixIcon: false,),
                OptionCard(title: 'Course or Enrollment Help', iconPath: '', route: RouteNames.supportUser, hasPrefixIcon: false,),
                OptionCard(title: 'Payment & Billing', iconPath: '', route: RouteNames.supportUser, hasPrefixIcon: false,),
                OptionCard(title: 'Technical Support', iconPath: '', route: RouteNames.supportUser, hasPrefixIcon: false,),
                OptionCard(title: 'General Inquiry', iconPath: '', route: RouteNames.supportUser, hasPrefixIcon: false,),
              ],
            ),
          )
        ],
      )
    );
  }
}
