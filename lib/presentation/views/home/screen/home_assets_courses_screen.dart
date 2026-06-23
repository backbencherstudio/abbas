import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeAssetsCoursesScreen extends ConsumerStatefulWidget {
  const HomeAssetsCoursesScreen({super.key});

  @override
  ConsumerState<HomeAssetsCoursesScreen> createState() =>
      _HomeAssetsCoursesScreenState();
}

class _HomeAssetsCoursesScreenState
    extends ConsumerState<HomeAssetsCoursesScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myCourseProvider.notifier).getMyCourse();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myCoursesAsync = ref.watch(myCourseProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Courses Assets'),
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
                    child: Text(
                      'No enrolled courses yet',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ...courses.map(
                      (course) => GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteNames.homeCourseAssetsScreen,
                          arguments: course.id,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Color(0xFFE9201D), Color(0xFF0A1929)],
                              ),
                            ),
                            child: ListTile(
                              leading: Image.asset('assets/images/face.png'),
                              title: Text(
                                course.title ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: const Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: const Color(0xFFFFFFFF),
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
