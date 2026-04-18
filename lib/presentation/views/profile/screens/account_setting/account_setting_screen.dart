import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../cors/routes/route_names.dart';
import '../../../../widgets/custom_bottom_sheet.dart';
import '../../../../widgets/secondary_appber.dart';
import '../../view_model/profile_screen_provider.dart';
import '../../widgets/option_card.dart';

class AccountSettingScreen extends StatelessWidget {
  const AccountSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileScreenProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      backgroundColor: AppColors.background,
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
                  title: "Delete Account",
                  iconPath: "assets/icons/user.svg",
                  route: RouteNames.loginScreen,
                  hasPrefixIcon: false,
                  isLast: true,
                  bottomSheet: CustomBottomSheet(
                    onTap: () async {
                      final res = await profileProvider.deleteAccount();
                      if (res.success) {
                        Utils.showToast(
                          msg: res.message,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );
                        Navigator.pop(context);
                      }else{
                        Utils.showToast(
                          msg: res.message,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    },
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
