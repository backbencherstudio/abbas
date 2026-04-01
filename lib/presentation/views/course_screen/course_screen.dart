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
    });
  }

  @override
  Widget build(BuildContext context) {
    final myCourses = ref.watch(myCourseProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppbar(
            title: "Course",
          ),
          Expanded(
            child: ListView(
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

                /// ------------------- My Courses Progress Bar ----------------
               if(myCourses.isLoading)
                 AnimatedLoading(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 19.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xff9A1E21), Color(0xff0A192A)],
                      ),
                      boxShadow: [
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
                        ...(myCourses.value?.data?.myCourses ?? []).map(
                          (course) => Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      course.title ?? "N/A",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    Spacer(),
                                    IconButton(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        RouteNames.myCourseScreen,
                                        arguments: course.id,
                                      ),
                                      icon: Icon(Icons.arrow_forward_ios),
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  course.infoLine ?? "N/A",
                                  style: TextStyle(
                                    color: Color(0xffD2D2D5),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  course.progressLabel ?? 'N/A',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                LinearProgressIndicator(
                                  value: course.progressPercent?.toDouble(),
                                  minHeight: 10,
                                  backgroundColor: Color(0xff212D44),
                                  color: Color(0xffE9201D),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                /// ---------------------- All Courses -------------------------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    textAlign: TextAlign.left,
                    "All Courses",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: NeverScrollableScrollPhysics(),
                //   padding: EdgeInsets.symmetric(horizontal: 16),
                //   itemCount: vm.courses.length,
                //   itemBuilder: (_, i) {
                //     final c = vm.courses[i];
                //     return CourseCard(
                //       title: c.title,
                //       subtitle: c.subtitle,
                //       date: 'Weekend',
                //       time: '1-day lessons',
                //       dateIcon: Icons.calendar_today,
                //       timeIcon: Icons.access_time,
                //       click: () {},
                //     );
                //   },
                // ),
                SizedBox(height: 12.h),

                /// ---------------------- Other Courses -----------------------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    textAlign: TextAlign.left,
                    "Other Courses",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: NeverScrollableScrollPhysics(),
                //   padding: EdgeInsets.symmetric(horizontal: 16),
                //   itemCount: vm.courses.length,
                //   itemBuilder: (_, i) {
                //     final c = vm.courses[i];
                //     return CourseCard(
                //       title: c.title,
                //       subtitle: c.subtitle,
                //       date: 'Weekend',
                //       time: '1-day lessons',
                //       dateIcon: Icons.calendar_today,
                //       timeIcon: Icons.access_time,
                //       click: () {
                //         Navigator.pushNamed(
                //           context,
                //           RouteNames.otherCourseScreen,
                //         );
                //       },
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
