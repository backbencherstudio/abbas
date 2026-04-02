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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(myCourseDetailsProvider.notifier)
          .myCourseDetails(courseId: widget.courseId);
    });
    super.initState();
  }

  /// ---------------- Formatted Date ------------------------------------------
  String? formattedDate(String? startDate) {
    if (startDate == null) return 'N/A';
    final parseDate = DateTime.parse(startDate);
    final formatted = DateFormat('dd MMM yyyy').format(parseDate);
    return formatted;
  }

  /// ------------------ Format Class Time -------------------------------------
  String formatClassTime(String? classTime) {
    if (classTime == null) return 'N/A';
    try {
      final parts = classTime.split('_');
      final start = DateFormat('HH:mm').parse(parts[0]);
      final end = DateFormat('HH:mm').parse(parts[1]);
      final formattedStart = DateFormat('h:mm a').format(start);
      final formattedEnd = DateFormat('h:mm a').format(end);

      return '$formattedStart - $formattedEnd';
    } catch (e) {
      return classTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseDetails = ref.watch(myCourseDetailsProvider);
    final data = courseDetails.value;
    final modules = data?.data?.modules ?? [];
    final instructor = data?.data?.instructor;
    final nextClassData = data?.data?.nextClass;
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xff1e2b42),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12.w, top: 12.h),
                child: Text(
                  "Next Class",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF0a1a29),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (courseDetails.isLoading) AnimatedLoading(),
                      if (courseDetails.hasError)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 24.sp,
                              color: Colors.white,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Network error : Connection refused',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                      Text(
                        "${nextClassData?.classTitle ?? 'N/A'}: ${nextClassData?.className ?? 'N/A'}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...modules.map((module) {
                        return Text(
                          "${module.moduleTitle}: ${module.moduleName}",
                          style: TextStyle(
                            color: Color(0xff8D9CDC),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      }),

                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.red,
                            size: 20.sp,
                          ),
                          SizedBox(width: 7.w),
                          Text(
                            formattedDate(nextClassData?.startDate) ?? 'N/A',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Icon(
                            Icons.access_time,
                            color: Colors.red,
                            size: 20.sp,
                          ),
                          SizedBox(width: 7.w),
                          Text(
                            formatClassTime(nextClassData?.classTime ?? 'N/A'),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      DottedBorder(
                        padding: EdgeInsets.all(16.r),
                        borderType: BorderType.RRect,
                        radius: Radius.circular(16.r),
                        color: Color(0xFF3D4566),
                        strokeWidth: 1.5,
                        dashPattern: [6, 5],
                        child: Text(
                          'Today’s class will start from ${formatClassTime(nextClassData?.classTime ?? 'N/A')} AM.',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Color(0xffF9C80E),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32.w,
                                  vertical: 16.h,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFF3D4566),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.assetsScreen,
                                  arguments: data?.data?.id,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/icons/folder.svg'),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "Assets",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 16.h,
                                ),
                                backgroundColor: Color(0xFFE9201D),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/icons/video.svg'),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "Join Class",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "All Module",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 16.h),
        ...modules.map((value) {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              RouteNames.courseModuleScreen,
              arguments: value.id,
            ),
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xff3D151E), Color(0xff071220)],
                ),
                borderRadius: BorderRadius.circular(6),
                border: Border(
                  left: BorderSide(color: Color(0xffE9201D), width: 2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        value.moduleTitle ?? 'N/A',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    value.moduleName ?? 'N/A',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            color: Color(0xff0A1A2A),
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
                    SizedBox(width: 6.h),
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
              ),

              ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    color: Color(0xff142331),
                    border: Border.all(color: Color(0xff142331), width: 1.w),
                  ),
                  child: Icon(Icons.person_2, color: AppColors.grey),
                ),
                title: Text(
                  instructor?.name ?? 'N/A',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                subtitle: Text(
                  instructor?.about ?? 'N/A',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Color(0xff0A1A2A),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "In addition to the lessons, this package also\nincludes:",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 10),

              SizedBox(width: 6),
              Row(
                children: [
                  Icon(
                    Icons.star_rate_outlined,
                    color: Color(0xffE9201D),
                    size: 12,
                  ),
                  SizedBox(width: 6),
                  Text(
                    "A certificate of the training completed",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Icon(
                    Icons.star_rate_outlined,
                    color: Color(0xffE9201D),
                    size: 12,
                  ),
                  SizedBox(width: 6),
                  Text(
                    "1 scene that you can add to your portfolio",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
