import 'package:abbas/presentation/views/course_screen/model/get_module_details_model.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../cors/routes/route_names.dart';
import '../../../../widgets/secondary_appber.dart';

class CourseModuleScreen extends ConsumerStatefulWidget {
  final String moduleId;

  const CourseModuleScreen({super.key, required this.moduleId});

  @override
  ConsumerState<CourseModuleScreen> createState() => _CourseModuleScreenState();
}

class _CourseModuleScreenState extends ConsumerState<CourseModuleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getModuleDetailsProvider.notifier)
          .getModuleDetails(moduleId: widget.moduleId);
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

  @override
  Widget build(BuildContext context) {
    final moduleState = ref.watch(getModuleDetailsProvider);

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: moduleState.when(
        loading: () => const Column(
          children: [
            SecondaryAppBar(title: 'Module'),
            Expanded(child: Center(child: AnimatedLoading())),
          ],
        ),
        error: (error, _) => Column(
          children: [
            const SecondaryAppBar(title: 'Module'),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
        data: (module) {
          final data = module?.data;
          if (data == null) {
            return const Column(
              children: [
                SecondaryAppBar(title: 'Module'),
                Expanded(
                  child: Center(
                    child: Text(
                      'No module data available',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            );
          }

          final classes = data.classes ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SecondaryAppBar(title: data.moduleTitle ?? 'Module'),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Module: ${data.moduleName ?? 'N/A'}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Divider(color: const Color(0xff3D4566), thickness: 0.7),
                        Text(
                          'Module Overview',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          data.moduleOverview ?? 'N/A',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Text(
                              'All Classes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xff1E273D),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Text(
                                data.moduleTitle ?? 'N/A',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        if (classes.isEmpty)
                          Text(
                            'No classes available',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14.sp,
                            ),
                          )
                        else
                          ...classes.map(
                            (classItem) => Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: _ClassCard(
                                classItem: classItem,
                                formattedDate: formatDate(classItem.classAt),
                                formattedTime: formatTime(classItem.classAt),
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  RouteNames.myClassScreen,
                                  arguments: classItem.id,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  final Classes classItem;
  final String formattedDate;
  final String formattedTime;
  final VoidCallback onTap;

  const _ClassCard({
    required this.classItem,
    required this.formattedDate,
    required this.formattedTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isNext = classItem.isNext;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isNext ? const Color(0xffE9201D) : const Color(0xff8D9CDC),
              width: 3.w,
            ),
          ),
          color: const Color(0xff0A1A2A),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    classItem.displayTitle,
                    style: TextStyle(
                      color: isNext
                          ? const Color(0xffE9201D)
                          : const Color(0xff8D9CDC),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (classItem.status != null && classItem.status!.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: isNext
                          ? const Color(0xffE9201D).withValues(alpha: 0.2)
                          : const Color(0xff1E273D),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      classItem.status!,
                      style: TextStyle(
                        color: isNext ? const Color(0xffE9201D) : Colors.white70,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                SizedBox(width: 8.w),
                const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.calendar_month, color: Colors.red, size: 16.sp),
                SizedBox(width: 6.w),
                Text(
                  formattedDate,
                  style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                ),
                SizedBox(width: 16.w),
                Icon(Icons.access_time, color: Colors.red, size: 16.sp),
                SizedBox(width: 6.w),
                Text(
                  formattedTime,
                  style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                ),
                if (classItem.duration != null) ...[
                  SizedBox(width: 16.w),
                  Text(
                    '${classItem.duration} min',
                    style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
