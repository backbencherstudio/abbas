import 'package:abbas/cors/services/token_storage.dart';
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/profile/view_model/profil_screen_provider.dart';
import 'package:abbas/presentation/views/profile/widgets/option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../cors/routes/route_names.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_bottom_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    /// Call API when screen loads
    Future.microtask(() {
      context.read<ProfileScreenProvider>().getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final TokenStorage _tokenStorage = TokenStorage();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<ProfileScreenProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          final profile = provider.profile?.data;

          final userName = profile?.name ?? "N/A";

          return Column(
            children: [
              const CustomAppbar(title: 'Profile'),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 24.h),

                      profile?.avatar != null
                          ? CircleAvatar(
                              radius: 30, // 30 px radius
                              backgroundImage: NetworkImage(profile!.avatar!),
                            )
                          : CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[200],
                              child: const Icon(
                                Icons.image,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),

                      SizedBox(height: 16.h),

                      /// Name
                      Text(userName, style: textTheme.headlineSmall),

                      SizedBox(height: 4.h),

                      Text(
                        "Membership Active",
                        style: textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF5F6CA0),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            OptionCard(
                              title: "Personal Info",
                              iconPath: "assets/icons/user.svg",
                              route: RouteNames.personalInfoScreen,
                            ),

                            SizedBox(height: 12.h),

                            OptionCard(
                              title: "Subscription & Payment",
                              iconPath: "assets/icons/credit.svg",
                              route: RouteNames.subscriptions,
                            ),

                            SizedBox(height: 12.h),

                            OptionCard(
                              title: "Contract Document",
                              iconPath: "assets/icons/document.svg",
                              route: RouteNames.contractAndDocumentScreen,
                            ),

                            SizedBox(height: 12.h),

                            OptionCard(
                              title: "Account Settings",
                              iconPath: "assets/icons/settings.svg",
                              route: RouteNames.accountSettingsScreen,
                            ),

                            SizedBox(height: 12.h),

                            OptionCard(
                              title: "Feedback & Certificates",
                              iconPath: "assets/icons/certificate.svg",
                              route: RouteNames.feedbackScreen,
                            ),

                            SizedBox(height: 12.h),

                            OptionCard(
                              title: "Push Notification",
                              iconPath: "assets/icons/notification.svg",
                              route: RouteNames.pushNotifications,
                            ),

                            SizedBox(height: 12.h),

                            OptionCard(
                              title: "Help & Support",
                              iconPath: "assets/icons/support.svg",
                              route: RouteNames.helpSupportScreen,
                            ),

                            SizedBox(height: 12.h),

                            OptionCard(
                              title: "Logout",
                              iconPath: "assets/icons/logout.svg",
                              isLast: true,
                              bottomSheet: CustomBottomSheet(
                                onTap: () async {
                                  await _tokenStorage.clearToken();

                                  final token = await _tokenStorage.getToken();

                                  if (token == null) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      RouteNames.loginScreen,
                                          (route) => false,
                                    );
                                  }
                                },
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
          );
        },
      ),
    );
  }
}
