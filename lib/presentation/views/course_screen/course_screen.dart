import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/course_screen/model/get_all_courses_model.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../cors/routes/route_names.dart';
import '../../widgets/custom_appbar.dart';

class CourseScreen extends ConsumerStatefulWidget {
  const CourseScreen({super.key});

  @override
  ConsumerState<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends ConsumerState<CourseScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(getAllCoursesProvider.notifier).getAllCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(getAllCoursesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppbar(title: "Course"),
          SizedBox(height: 24.h),
          Expanded(
            child: coursesAsync.when(
              loading: () => const Center(child: AnimatedLoading()),
              error: (error, _) => Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    'Failed to load courses',
                    style: TextStyle(color: Colors.white70, fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              data: (model) {
                final courses = model?.data ?? [];
                final enrolledCourses =
                    courses.where((c) => c.isEnrolled == true).toList();
                final otherCourses =
                    courses.where((c) => c.isEnrolled != true).toList();

                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Text(
                        "My Courses",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    if (enrolledCourses.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            Icon(
                              Icons.book_outlined,
                              size: 48.sp,
                              color: Colors.white70,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              "No Courses Available",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...enrolledCourses.map(
                        (course) => _EnrolledCourseCard(
                          course: course,
                          onTap: () => Navigator.pushNamed(
                            context,
                            RouteNames.myCourseScreen,
                            arguments: course.id,
                          ),
                        ),
                      ),
                    SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "Other Courses",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    if (otherCourses.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          "No other courses available",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white54,
                          ),
                        ),
                      )
                    else
                      ...otherCourses.map(
                        (course) => _OtherCourseCard(
                          course: course,
                          onTap: () => Navigator.pushNamed(
                            context,
                            RouteNames.otherCourseScreen,
                            arguments: course.id,
                          ),
                        ),
                      ),
                    SizedBox(height: 24.h),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EnrolledCourseCard extends StatelessWidget {
  final CourseListItem course;
  final VoidCallback onTap;

  const _EnrolledCourseCard({
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xff9A1E21), Color(0xff0A192A)],
            ),
            boxShadow: const [
              BoxShadow(
                offset: Offset(-1, 1),
                color: Color(0xffE9201D),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/face.png'),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            course.title ?? 'N/A',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ],
                    ),
                    if (course.subtitleLine.isNotEmpty) ...[
                      SizedBox(height: 10.h),
                      Text(
                        course.subtitleLine,
                        style: TextStyle(
                          color: const Color(0xffD2D2D5),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
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

class _OtherCourseCard extends StatelessWidget {
  final CourseListItem course;
  final VoidCallback onTap;

  const _OtherCourseCard({
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          margin: EdgeInsets.only(bottom: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: const Color(0xFF0A1A29),
            border: Border.all(color: const Color(0xFF3D4566)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/face.png'),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            course.title ?? 'N/A',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    if (course.subtitleLine.isNotEmpty) ...[
                      SizedBox(height: 10.h),
                      Text(
                        course.subtitleLine,
                        style: TextStyle(
                          color: const Color(0xffD2D2D5),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
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
