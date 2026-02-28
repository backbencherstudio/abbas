import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../cors/routes/route_names.dart';

class StartEnrollment extends StatelessWidget {
  const StartEnrollment({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final contentPadding = EdgeInsets.symmetric(
      horizontal: isPortrait ? 32.w : 64.w,
      vertical: isPortrait ? 48.h : 32.h,
    );

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/images/background_img.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Padding(
              padding: contentPadding,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 270.h),
                    Text(
                      'Start with Digital Signature',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isPortrait ? 28.sp : 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Complete your digital agreement to\nbegin your course enrollment.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8C9196),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.selectCourse);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFE9201D),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 16.h,
                        ),
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'Start Enrollment',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 80.h),
                    Text(
                      'Are You Prospective?',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white60,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.parentScreen);
                      },
                      child: Text(
                        'Skip Enrollment',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFFE9201D),
                          decoration: TextDecoration.underline,
                          decorationColor: const Color(0xFFE9201D),
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
