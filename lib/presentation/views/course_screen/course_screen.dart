import 'package:abbas/cors/theme/app_colors.dart';
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
      ref.read(myCourseProvider.notifier).getMyCourse();
      ref.read(getAllCoursesProvider.notifier).getAllCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final myCourses = ref.watch(myCourseProvider);
    final allCourses = ref.watch(getAllCoursesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppbar(title: "Course"),
          SizedBox(height: 24.h),
          Expanded(
            child: ListView(
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

                /// Loading
                if (myCourses.isLoading) const AnimatedLoading(),

                ...((myCourses.value?.data?.myCourses ?? []).map((course) {
                  return InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteNames.myCourseScreen,
                      arguments: course.id,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 14.h,
                        ),
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
                                          course.title ?? "N/A",
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

                                  SizedBox(height: 10.h),

                                  Text(
                                    course.infoLine ?? "N/A",
                                    style: TextStyle(
                                      color: const Color(0xffD2D2D5),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),

                                  SizedBox(height: 10.h),

                                  Text(
                                    course.progressLabel ?? 'N/A',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),

                                  SizedBox(height: 6.h),

                                  LinearProgressIndicator(
                                    value: (course.progressPercent ?? 0)
                                        .toDouble(),
                                    minHeight: 10,
                                    backgroundColor: const Color(0xff212D44),
                                    color: const Color(0xffE9201D),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList()),

                SizedBox(height: 12.h),

                /// ------------------- Other Courses --------------------------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const Text(
                    "Other Courses",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                SizedBox(height: 12.h),
                ...((myCourses.value?.data?.otherCourses ?? []).map((course) {
                  return InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 16.h,
                        ),
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
                                          course.title ?? "N/A",
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
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10.h),

                                  Text(
                                    course.infoLine ?? "N/A",
                                    style: TextStyle(
                                      color: const Color(0xffD2D2D5),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList()),

                SizedBox(height: 12.h),

                /// --------------- All Courses --------------------------------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const Text(
                    "All Courses",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                /// Loading
                if (allCourses.isLoading) const AnimatedLoading(),
                ...((allCourses.value?.data ?? []).map((course) {
                  return InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 16.h,
                        ),
                        margin: EdgeInsets.symmetric(vertical: 10.h),
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
                                          course.title ?? "N/A",
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
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
