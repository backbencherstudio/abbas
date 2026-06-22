import 'package:abbas/presentation/views/course_screen/model/get_my_assignments_model.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../cors/routes/route_names.dart';

class MyAssignmentWidget extends ConsumerStatefulWidget {
  final String courseId;

  const MyAssignmentWidget({super.key, required this.courseId});

  @override
  ConsumerState<MyAssignmentWidget> createState() => _MyAssignmentWidgetState();
}

class _MyAssignmentWidgetState extends ConsumerState<MyAssignmentWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getMyAssignmentsProvider.notifier)
          .getMyAssignments(courseId: widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final assignmentsState = ref.watch(getMyAssignmentsProvider);

    return assignmentsState.when(
      loading: () => const Center(child: AnimatedLoading()),
      error: (error, _) => Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
        ),
      ),
      data: (model) {
        final modules = (model?.data ?? [])
            .where((module) => module.allAssignments.isNotEmpty)
            .toList();

        if (modules.isEmpty) {
          return Center(
            child: Text(
              'No assignments found',
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          children: modules.expand((module) {
            return [
              Padding(
                padding: EdgeInsets.only(bottom: 10.h, top: 8.h),
                child: Text(
                  module.displayTitle,
                  style: TextStyle(
                    color: const Color(0xff8C9196),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ...module.allAssignments.map(
                (assignment) => Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: CourseAssignmentCard(
                    assignment: assignment,
                    onTap: () {
                      if (assignment.id == null) return;
                      Navigator.pushNamed(
                        context,
                        RouteNames.dueAssignmentScreen,
                        arguments: assignment.id,
                      );
                    },
                  ),
                ),
              ),
            ];
          }).toList(),
        );
      },
    );
  }
}

class CourseAssignmentCard extends StatelessWidget {
  const CourseAssignmentCard({super.key, required this.assignment, required this.onTap});

  final CourseAssignmentItem assignment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: const Color(0xff061220),
            borderRadius: BorderRadius.circular(6.r),
            border: Border(
              left: BorderSide(color: Colors.red, width: 3.w),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  assignment.title ?? 'N/A',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (assignment.isPending)
                _StatusBadge(
                  label: assignment.dueLabel,
                  backgroundColor: const Color(0xffF9C80E),
                  textColor: Colors.black,
                ),
              if (assignment.isSubmitted || assignment.isGraded) ...[
                _StatusBadge(
                  label: 'Submitted',
                  backgroundColor: const Color(0xFF1E273D),
                  textColor: Colors.white70,
                ),
                if (assignment.grade != null &&
                    assignment.grade!.isNotEmpty) ...[
                  SizedBox(width: 6.w),
                  _StatusBadge(
                    label: 'Grade: ${assignment.grade}',
                    backgroundColor: const Color(0xFF1E273D),
                    textColor: Colors.red,
                  ),
                ],
              ],
              SizedBox(width: 10.w),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14.sp),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 6.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
