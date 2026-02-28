
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../widgets/secondary_appber.dart';
import '../../../widgets/course_Detail_Card.dart';
import '../../../widgets/course_Fee_Card.dart';
import '../../../widgets/instructor_Card.dart';
import '../../../widgets/subtitle_Content_Card.dart';

class CourseModule extends StatelessWidget {
  const CourseModule({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SecondaryAppBar(title: 'Course Module'),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1 year program ( adult )',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SubtitleContentCard(
                      subtitle: 'Course Overview',
                      content:
                      'This course consists of a 2-year period\ntrajectory that runs 1 day a week on Sunday\ntakes place.',
                    ),
                    SizedBox(height: 6.h),
                    CourseDetailCard(
                        title: 'Course Module',
                        subtitle: 'The lessons consist of 4 modules:',
                        content: ''),
                    SizedBox(height: 6.h),
                    CourseFeeCard(),
                    SizedBox(height: 6.h),
                    InstructorCard(
                      mainTitle: 'Instructor',
                      icon: 'assets/icons/profile_img.png',
                      iconpath: 'assets/icons/instructor_img.png',
                      name: 'Sophie Lambert',
                      details:
                      '20+ years experience in theater and film.\n'
                          'Trained at Royal Academy of Dramatic Art.',
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.fillEnrollmentForm);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFE9201D),
                        minimumSize: Size(double.infinity, 60.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Enroll Now',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}