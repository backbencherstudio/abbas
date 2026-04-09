import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myCourseProvider.notifier).getMyCourse();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myCourses = ref.watch(myCourseProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SecondaryAppBar(title: 'My Courses'),
          SizedBox(height: 24.h),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...((myCourses.value?.data?.myCourses ?? []).map(
                  (course) => Padding(
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
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
