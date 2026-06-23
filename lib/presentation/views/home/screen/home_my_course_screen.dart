import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/course_screen/model/get_all_courses_model.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeMyCourseScreen extends ConsumerStatefulWidget {
  const HomeMyCourseScreen({super.key});

  @override
  ConsumerState<HomeMyCourseScreen> createState() => _HomeMyCourseScreenState();
}

class _HomeMyCourseScreenState extends ConsumerState<HomeMyCourseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myCourseProvider.notifier).getMyCourse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final myCoursesAsync = ref.watch(myCourseProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SecondaryAppBar(title: 'My Courses'),
          SizedBox(height: 24.h),
          Expanded(
            child: myCoursesAsync.when(
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

                if (courses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 48.sp,
                          color: Colors.white70,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No enrolled courses yet',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: courses.length,
                  separatorBuilder: (_, _) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    return _EnrolledCourseCard(
                      course: courses[index],
                      onTap: () => Navigator.pushNamed(
                        context,
                        RouteNames.myCourseScreen,
                        arguments: courses[index].id,
                      ),
                    );
                  },
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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
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
