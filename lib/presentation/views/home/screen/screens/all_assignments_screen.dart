import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AllAssignmentsScreen extends ConsumerStatefulWidget {
  final String moduleId;
  const AllAssignmentsScreen({super.key, required this.moduleId});

  @override
  ConsumerState<AllAssignmentsScreen> createState() =>
      _AllAssignmentsScreenState();
}

class _AllAssignmentsScreenState extends ConsumerState<AllAssignmentsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getMyAssignmentsProvider.notifier)
          .getMyAssignments(courseId: widget.moduleId);
    });
    super.initState();
  }

  /// -------------------- Formatted Date --------------------------------------
  String formattedDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';

    try {
      final DateTime parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignment = ref.watch(getMyAssignmentsProvider);
    final assignmentList = assignment.value?.data?.first.assignments;

    return Scaffold(
      backgroundColor: Color(0xff030D15),
      body: Column(
        children: [
          SecondaryAppBar(title: 'All Assignments'),
          Expanded(
            child: ListView.builder(
              itemCount: assignmentList?.length,
              itemBuilder: (context, index) {
                final assignment = assignmentList?[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10),
                  child: Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(0.85, -1.8),
                        radius: 2,
                        colors: [AppColors.splashRed, AppColors.cardBackground],
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15.h),
                        Text(
                          assignment?.title ?? 'N/A',
                          style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "${assignment?.classTitle ?? 'N/A'}: ${assignment?.className ?? 'N/A'}",
                          style: TextStyle(
                            color: Color(0xff8C9196),
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 12.h),
            
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.red),
                            SizedBox(width: 6.w),
                            Text(
                              "Due : ${formattedDate(assignment?.dueDate)}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Divider(thickness: 0.7, color: Color(0xff8C9196)),
                        Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment(0.85, -1.8),
                              radius: 2,
                              colors: [
                                AppColors.splashRed,
                                AppColors.cardBackground,
                              ],
                            ),
                          ),
                          child: Text(
                            "Status : ${assignment?.status}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
            
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
