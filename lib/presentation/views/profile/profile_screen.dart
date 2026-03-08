import 'package:abbas/presentation/views/profile/widgets/option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../cors/routes/route_names.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_bottom_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(title: 'Profile'),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 24.h),
                  Container(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Image.asset(
                      "assets/images/profile.png",
                      height: 100.h,
                      width: 100.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text("Brooklyn Simmons", style: textTheme.headlineSmall),
                  SizedBox(height: 4.h),
                  Text(
                    "Membership Active",
                    style: textTheme.bodySmall?.copyWith(
                      color: Color(0xFF5F6CA0),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      spacing: 12.h,
                      children: [
                        OptionCard(
                          title: "Personal Info",
                          iconPath: "assets/icons/user.svg",
                          route: RouteNames.personalInfoScreen,
                        ),
                        OptionCard(
                          title: "Subscription & Payment",
                          iconPath: "assets/icons/credit.svg",
                          route: RouteNames.subscriptions,
                        ),
                        OptionCard(
                          title: "Contract Document",
                          iconPath: "assets/icons/document.svg",
                          route: RouteNames.contractAndDocumentScreen,
                        ),
                        OptionCard(
                          title: "Account Settings",
                          iconPath: "assets/icons/settings.svg",
                          route: RouteNames.accountSettingsScreen,
                        ),
                        OptionCard(
                          title: "Feedback & Certificates",
                          iconPath: "assets/icons/certificate.svg",
                          route: RouteNames.feedbackScreen,
                        ),
                        OptionCard(
                          title: "Push Notification",
                          iconPath: "assets/icons/notification.svg",
                          route: RouteNames.pushNotifications,
                        ),
                        OptionCard(
                          title: "Help & Support",
                          iconPath: "assets/icons/support.svg",
                          route: RouteNames.helpSupportScreen,
                        ),
                        OptionCard(
                          title: "Logout",
                          iconPath: "assets/icons/logout.svg",
                          isLast: true,
                          bottomSheet: CustomBottomSheet(
                            title: "Confirm Logout",
                            description: "Are you sure you want to log out?",
                            iconPath: "assets/icons/logout.svg",
                            buttonTitle: "Yes, Logout",
                            buttonIconPath: "assets/icons/logout_white.svg",
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
