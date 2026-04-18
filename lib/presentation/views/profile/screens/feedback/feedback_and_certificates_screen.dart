import 'package:abbas/cors/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../cors/routes/route_names.dart';
import '../../../../widgets/secondary_appber.dart';
import '../../widgets/option_card.dart';

class FeedbackAndCertificatesScreen extends StatelessWidget {
  const FeedbackAndCertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SecondaryAppBar(title: 'Certificates'),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              spacing: 16.h,
              children: [
                // OptionCard(
                //   title: 'Feedback',
                //   iconPath: 'iconPath',
                //   route: RouteNames.feedbackPage,
                //   hasPrefixIcon: false,
                // ),
                OptionCard(
                  title: 'Certificates',
                  iconPath: 'iconPath',
                  route: RouteNames.certificate,
                  hasPrefixIcon: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
