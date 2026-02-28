import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../cors/di/injection.dart';
import '../../../../cors/routes/route_names.dart';
import '../../../../cors/theme/app_colors.dart';
import '../../../../cors/theme/app_text_styles.dart';

import '../../../viewmodels/onboardibng/onboarding_viewmodel.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/onboarding_screen_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      {
        "image": "assets/images/onboarding1.png",
        "title": "Welcome to CINACT 🎭",
        "subtitle1": "Join Belgium’s leading acting school",
        "subtitle2": "for cinema and television – now in your pocket.",
      },
      {
        "image": "assets/images/onboarding2.png",
        "title": "Learn. Perform. Connect.",
        "subtitle1": "Enroll in classes, chat with coaches,",
        "subtitle2": "and track your progress — all in one place.",
      },
      {
        "image": "assets/images/onboarding3.png",
        "title": "Ready to Shine?",
        "subtitle1": "Create your profile",
        "subtitle2": "and step into the CINACT community.",
      },
    ];

    // Get the OnboardingViewModel using GetIt
    final onboardingViewModel = getIt<OnboardingViewModel>();  // GetOnboardingViewModel

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Pages
            PageView.builder(
              controller: onboardingViewModel.pageController,
              onPageChanged: onboardingViewModel.onPageChanged,
              itemCount: pages.length,
              itemBuilder: (_, index) {
                final p = pages[index];
                return OnboardingScreenWidget(
                  imageAsset: p["image"]!,
                  title: p["title"]!,
                  subtitle1: p["subtitle1"]!,
                  subtitle2: p["subtitle2"]!,
                );
              },
            ),

            // Skip Button
            Positioned(
              top: 16.h,
              right: 20.w,
              child: TextButton(
                onPressed: () => onboardingViewModel.skip(context),  // skip method
                child: Text(
                  "Skip",
                  style: AppTextStyles.textTheme.titleLarge?.copyWith(
                    color: AppColors.lightGreyTextColor,
                  ),
                ),
              ),
            ),

            // Dots Indicator
            Positioned(
              bottom: 180.h,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: onboardingViewModel.pageController,
                  count: pages.length,
                  effect: CustomizableEffect(
                    spacing: 6.w,
                    dotDecoration: DotDecoration(
                      width: 8.w,
                      height: 8.h,
                      color: AppColors.greyPurpleTextColor, // inactive
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    activeDotDecoration: DotDecoration(
                      width: 18.w,
                      height: 8.h,
                      color: AppColors.activeButtonColor, // active (red)
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),
            ),

            // Next / Get Started Button
            Positioned(
              bottom: 40.h,
              left: 24.w,
              right: 24.w,
              child: AnimatedBuilder(
                animation: onboardingViewModel.pageController,
                builder: (context, _) {
                  final currentPage = onboardingViewModel.pageController.hasClients
                      ? onboardingViewModel.pageController.page?.round() ?? 0
                      : 0;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: currentPage == pages.length - 1
                          ? AppColors.activeButtonColor // red for last page
                          : Color(0xff0A1A29), // gray for first pages
                    ),
                    child: CustomElevatedButton(
                      backgroundColor: currentPage == pages.length - 1
                          ? AppColors.activeButtonColor
                          : Color(0xff0A1A29),
                      onPressed: () {
                        if (currentPage == pages.length - 1) {
                          Navigator.pushReplacementNamed(
                              context, RouteNames.loginAndSignUpScreen);
                        } else {
                          onboardingViewModel.nextPage();
                        }
                      },
                      text: currentPage == pages.length - 1 ? "Get Started" : "Next",
                      textStyle: AppTextStyles.textTheme.bodyLarge?.copyWith(
                        color: currentPage == pages.length - 1
                            ? Colors.white
                            : Colors.white,
                      ),
                      prefixIcon: null,
                      suffixIcon: currentPage != pages.length - 1
                          ? const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.white,
                      )
                          : null,
                    ),
                  );
                },
              ),
            ),


          ],
        ),
      ),
    );
  }
}
