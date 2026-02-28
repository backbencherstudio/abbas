
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../cors/routes/route_names.dart';
import '../../../../widgets/custom_bottom_sheet.dart';
import '../../../../widgets/secondary_appber.dart';
import '../../widgets/option_card.dart';

class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SecondaryAppBar(title: 'Account Settings'),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              spacing: 16.h,
              children: [
                OptionCard(
                  title: "Change Password",
                  iconPath: "assets/icons/user.svg",
                  route: RouteNames.changePassword,
                  hasPrefixIcon: false,
                ),
                OptionCard(
                  title: "Disable Account",
                  iconPath: "assets/icons/user.svg",
                  route: '',
                  hasPrefixIcon: false,
                  isLast: true,
                  bottomSheet: CustomBottomSheet(
                    title: "Disable Account?",
                    description: "Are you sure you to Disable Account?",
                    iconPath: "assets/icons/alert.svg",
                    buttonTitle: "Disable",
                    buttonIconPath: "assets/icons/disable.svg",
                  ),
                ),
                OptionCard(
                  title: "Delete Account",
                  iconPath: "assets/icons/user.svg",
                  route: '',
                  hasPrefixIcon: false,
                  isLast: true,
                  bottomSheet: CustomBottomSheet(
                    title: "Delete Account?",
                    description: "Are you sure you to Delete Account?",
                    iconPath: "assets/icons/alert.svg",
                    buttonTitle: "Delete",
                    buttonIconPath: "assets/icons/delete.svg",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
