import 'package:abbas/presentation/views/course_screen/model/my_course_details_model.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';

class CourseWidget extends ConsumerStatefulWidget {
  final String courseId;

  const CourseWidget({super.key, required this.courseId});

  @override
  ConsumerState<CourseWidget> createState() => _CourseWidgetState();
}

class _CourseWidgetState extends ConsumerState<CourseWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(myCourseDetailsProvider.notifier)
          .myCourseDetails(courseId: widget.courseId);
    });
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return 'N/A';
    return DateFormat('dd MMM yyyy').format(parsed.toLocal());
  }

  String formatTime(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return 'N/A';
    return DateFormat('hh:mm a').format(parsed.toLocal());
  }

  String timeUntilClass(String? classAt) {
    if (classAt == null || classAt.isEmpty) return 'N/A';

    final classLocal = DateTime.tryParse(classAt)?.toLocal();
    if (classLocal == null) return 'N/A';

    final difference = classLocal.difference(DateTime.now());
    if (difference.isNegative) return 'Class already started';

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    if (days > 0) return 'Starts in ${days}d ${hours}h';
    if (hours > 0) return 'Starts in ${hours}h ${minutes}m';
    return 'Starts in ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final courseDetails = ref.watch(myCourseDetailsProvider);

    return courseDetails.when(
      loading: () => const Center(child: AnimatedLoading()),
      error: (error, _) => Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48.sp, color: Colors.white70),
              SizedBox(height: 12.h),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ),
      data: (model) {
        final data = model?.data;
        if (data == null) {
          return Center(
            child: Text(
              'No course data available',
              style: TextStyle(color: Colors.white70, fontSize: 16.sp),
            ),
          );
        }

        final modules = data.modules ?? [];
        final instructor = data.instructor;
        final nextClass = data.nextClass;

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          children: [
            if (nextClass != null) ...[
              _NextClassCard(
                nextClass: nextClass,
                timeUntilClass: timeUntilClass(nextClass.classAt),
                formattedDate: formatDate(nextClass.classAt),
                formattedTime: formatTime(nextClass.classAt),
                onAssets: () => Navigator.pushNamed(
                  context,
                  RouteNames.homeCourseAssetsScreen,
                  arguments: widget.courseId,
                ),
              ),
              SizedBox(height: 16.h),
            ],
            Text(
              'All Module',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 16.h),
            if (modules.isEmpty)
              Text(
                'No modules available',
                style: TextStyle(color: Colors.white54, fontSize: 14.sp),
              )
            else
              ...modules.map(
                (module) => GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    RouteNames.courseModuleScreen,
                    arguments: module.id,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16.r),
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xff3D151E), Color(0xff071220)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                      border: const Border(
                        left: BorderSide(color: Color(0xffE9201D), width: 2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                module.moduleTitle ?? 'N/A',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                        if (module.moduleName != null &&
                            module.moduleName!.isNotEmpty) ...[
                          SizedBox(height: 6.h),
                          Text(
                            module.moduleName!,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            if (instructor != null) ...[
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff0A1A2A),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12.w, top: 12.h),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/instructor.svg',
                            height: 20.h,
                            width: 20.w,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Instructor',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          color: const Color(0xff142331),
                        ),
                        child: const Icon(Icons.person_2, color: AppColors.grey),
                      ),
                      title: Text(
                        instructor.name ?? 'N/A',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                      subtitle: instructor.about != null
                          ? Text(
                              instructor.about.toString(),
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.sp,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _NextClassCard extends StatelessWidget {
  final NextClass nextClass;
  final String timeUntilClass;
  final String formattedDate;
  final String formattedTime;
  final VoidCallback onAssets;

  const _NextClassCard({
    required this.nextClass,
    required this.timeUntilClass,
    required this.formattedDate,
    required this.formattedTime,
    required this.onAssets,
  });

  @override
  Widget build(BuildContext context) {
    final module = nextClass.module;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff1e2b42),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.w, top: 12.h),
            child: Text(
              'Next Class',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0a1a29),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nextClass.displayTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (module != null &&
                    (module.moduleTitle != null || module.moduleName != null)) ...[
                  SizedBox(height: 6.h),
                  Text(
                    '${module.moduleTitle ?? ''}${module.moduleName != null ? ': ${module.moduleName}' : ''}',
                    style: TextStyle(
                      color: const Color(0xff8D9CDC),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.red, size: 20.sp),
                    SizedBox(width: 7.w),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(Icons.access_time, color: Colors.red, size: 20.sp),
                    SizedBox(width: 7.w),
                    Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                    if (nextClass.duration != null) ...[
                      SizedBox(width: 16.w),
                      Text(
                        '${nextClass.duration} min',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 16.h),
                DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    padding: EdgeInsets.all(16.r),
                    radius: Radius.circular(16.r),
                    color: const Color(0xFF3D4566),
                    strokeWidth: 1.5,
                    dashPattern: const [6, 5],
                  ),
                  child: Text(
                    'Next class $timeUntilClass.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xffF9C80E),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      side: const BorderSide(color: Color(0xFF3D4566)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: onAssets,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/folder.svg'),
                        SizedBox(width: 4.w),
                        Text(
                          'Assets',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
