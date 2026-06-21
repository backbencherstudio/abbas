import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:abbas/presentation/widgets/primary_button.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../form_fillup_and_rules/utils/enrollment_navigator.dart';

class CourseDetailsScreen extends ConsumerStatefulWidget {
  final String courseId;
  final bool fromEnrollment;

  const CourseDetailsScreen({
    super.key,
    required this.courseId,
    this.fromEnrollment = false,
  });

  @override
  ConsumerState<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends ConsumerState<CourseDetailsScreen> {
  bool _isStartingEnrollment = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(getCourseDetailsProvider.notifier).getCoursesDetails(widget.courseId);
    });
  }

  String stripHtml(String? htmlString) {
    if (htmlString == null || htmlString.isEmpty) return "";
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final courseDetailsAsync = ref.watch(getCourseDetailsProvider);

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: Column(
        children: [
          SecondaryAppBar(
            title: widget.fromEnrollment
                ? "Select Course / Course Details"
                : "Other Courses / Course Details",
          ),
          Expanded(
            child: courseDetailsAsync.when(
              data: (model) {
                if (model == null || model.data == null) {
                  return const Center(child: Text("No data found", style: TextStyle(color: Colors.white)));
                }

                final data = model.data!;
                final instructor = data.instructor;
                final modules = data.modules ?? [];
                final includes = data.includes ?? [];
                final scheduleText =
                    data.scheduleLabel ??
                    data.formattedStartDate ??
                    (data.startDate ?? '');
                final showSchedule =
                    scheduleText.isNotEmpty || (data.classTime?.isNotEmpty ?? false);

                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title ?? "N/A",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xff0A1A2A),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Course Overview",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              stripHtml(data.overviewText ?? data.courseOverview),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                            if (showSchedule) ...[
                              SizedBox(height: 12.h),
                              const Divider(color: Color(0xff232E47), thickness: 0.8),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  if (scheduleText.isNotEmpty) ...[
                                    const Icon(Icons.calendar_month, color: Color(0xffE9201D)),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        scheduleText,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (data.classTime != null &&
                                      data.classTime!.isNotEmpty) ...[
                                    const Icon(Icons.access_time, color: Color(0xffE9201D)),
                                    SizedBox(width: 8.w),
                                    Text(
                                      data.classTime!,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                            if (modules.isNotEmpty) ...[
                              SizedBox(height: 12.h),
                              const Divider(color: Color(0xff232E47), thickness: 0.8),
                              SizedBox(height: 12.h),
                              Text(
                                "Course Module",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                "The lessons consist of ${data.modulesCount ?? modules.length} modules:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              ...modules.asMap().entries.map((entry) {
                                final index = entry.key + 1;
                                final module = entry.value;
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star_rate_outlined,
                                        color: Color(0xffE9201D),
                                        size: 14,
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          "Module $index: ${module.moduleTitle ?? module.moduleName ?? "N/A"}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                            if (includes.isNotEmpty) ...[
                              SizedBox(height: 16.h),
                              Text(
                                "In addition to the lessons, this package also includes:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              ...includes.map((include) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star_rate_outlined,
                                        color: Color(0xffE9201D),
                                        size: 14,
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          include.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                            if (instructor != null) ...[
                              SizedBox(height: 16.h),
                              const Divider(color: Color(0xff232E47), thickness: 0.8),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/instructor.svg',
                                    height: 20.h,
                                    width: 20.w,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "Instructor",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100.r),
                                      color: const Color(0xff142331),
                                    ),
                                    child: instructor.avatar != null
                                        ? ClipOval(
                                            child: Image.network(
                                              instructor.avatar,
                                              width: 32.w,
                                              height: 32.w,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.person_2, color: AppColors.grey),
                                            ),
                                          )
                                        : const Icon(Icons.person_2, color: AppColors.grey),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          instructor.name ?? "N/A",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          instructor.about ?? "Instructor details not available.",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            SizedBox(height: 24.h),
                            if (data.isAlreadyEnrolled)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 14.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF142331),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: const Color(0xFF3D4566)),
                                ),
                                child: Text(
                                  'You have already enrolled in this course.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            else
                              PrimaryButton(
                                onTap: _isStartingEnrollment
                                    ? null
                                    : () async {
                                        if (data.id == null) return;
                                        setState(
                                          () => _isStartingEnrollment = true,
                                        );
                                        await EnrollmentNavigator
                                            .navigateToCurrentStep(
                                          context,
                                          ref,
                                          courseId: data.id!,
                                        );
                                        if (mounted) {
                                          setState(
                                            () => _isStartingEnrollment = false,
                                          );
                                        }
                                      },
                                color: const Color(0xFFE9201D),
                                textColor: Colors.white,
                                icon: '',
                                child: _isStartingEnrollment
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text("Enroll Now"),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: AnimatedLoading()),
              error: (error, stack) => Center(
                child: Text(
                  "Error: $error",
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
