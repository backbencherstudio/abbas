import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widgets/animated_loading.dart';

class ClassAssignmentsScreen extends ConsumerStatefulWidget {
  final String classId;

  const ClassAssignmentsScreen({super.key, required this.classId});

  @override
  ConsumerState<ClassAssignmentsScreen> createState() =>
      _ClassAssignmentsScreenState();
}

class _ClassAssignmentsScreenState
    extends ConsumerState<ClassAssignmentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getClassDetailsProvider.notifier)
          .getClassDetails(classId: widget.classId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final assignmentsProvider = ref.watch(getClassDetailsProvider);
    final assignmentsData = assignmentsProvider.value?.data;
    final assignments = assignmentsData?.assignments ?? [];

    if (assignmentsProvider.isLoading) {
      return const Scaffold(body: Center(child: AnimatedLoading()));
    }

    if (assignmentsProvider.hasError) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
            SizedBox(height: 10.h),
            Center(
              child: Text(
                assignmentsProvider.error.toString(),
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    if (assignments.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            SecondaryAppBar(title: 'Assignments'),
            Expanded(
              child: Center(
                child: Text(
                  "No assignments found",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SecondaryAppBar(title: 'Assignments'),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                final assignment = assignments[index];
                final bool isSubmitted = assignment.status == 'SUBMITTED';
                final bool isPending = assignment.status == 'PENDING';

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 7.h),
                  child: InkWell(
                    onTap: () {
                      if (isSubmitted) {
                        Navigator.pushNamed(
                          context,
                          RouteNames.submittedAssignmentScreen,
                          arguments: assignment.id,
                        );
                      } else if (isPending) {
                        Navigator.pushNamed(
                          context,
                          RouteNames.dueAssignmentScreen,
                          arguments: assignment.id,
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          RouteNames.assignmentCongratulationScreen,
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 20.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: isSubmitted
                                ? Colors.green
                                : isPending
                                ? Colors.orange
                                : Color(0xFF1E273D),
                            width: 3.w,
                          ),
                        ),
                        color: const Color(0xff061220),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              assignment.title ?? 'N/A',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: isSubmitted
                                  ? Colors.green.shade100
                                  : isPending
                                  ? Colors.orange.shade100
                                  : Color(0xffF9C80E),
                            ),
                            child: Center(
                              child: Text(
                                assignment.status ?? 'N/A',
                                style: TextStyle(
                                  color: isSubmitted
                                      ? Colors.green
                                      : isPending
                                      ? Colors.orange
                                      : Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
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
