import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/course_screen/model/class_assignments_model.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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
          .read(getClassAssignmentsProvider.notifier)
          .getClassAssignments(classId: widget.classId);
    });
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return date;
    return DateFormat('dd MMM yyyy').format(parsed);
  }

  String _dueDaysLabel(int? dueDays) {
    if (dueDays == null) return 'N/A';
    if (dueDays == 0) return 'Due today';
    if (dueDays == 1) return '1 day left';
    if (dueDays < 0) return '${dueDays.abs()} days overdue';
    return '$dueDays days left';
  }

  void _onAssignmentTap(ClassAssignmentItem assignment) {
    final id = assignment.id;
    if (id == null || id.isEmpty) return;

    Navigator.pushNamed(
      context,
      RouteNames.dueAssignmentScreen,
      arguments: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final assignmentsState = ref.watch(getClassAssignmentsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Assignments'),
          Expanded(
            child: assignmentsState.when(
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
                final assignments = model?.data ?? [];

                if (assignments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          color: Colors.white54,
                          size: 56.sp,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'No assignments found',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  itemCount: assignments.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final assignment = assignments[index];
                    return _AssignmentCard(
                      assignment: assignment,
                      formattedDate: _formatDate(assignment.submissionDate),
                      dueDaysLabel: _dueDaysLabel(assignment.dueDays),
                      onTap: () => _onAssignmentTap(assignment),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({
    required this.assignment,
    required this.formattedDate,
    required this.dueDaysLabel,
    required this.onTap,
  });

  final ClassAssignmentItem assignment;
  final String formattedDate;
  final String dueDaysLabel;
  final VoidCallback onTap;

  Color get _borderColor {
    if (assignment.isSubmitted) return Colors.green;
    if (assignment.isPending) return Colors.orange;
    if (assignment.isGraded) return const Color(0xffF9C80E);
    return const Color(0xFF1E273D);
  }

  Color get _statusBgColor {
    if (assignment.isSubmitted) {
      return Colors.green.withValues(alpha: 0.15);
    }
    if (assignment.isPending) {
      return Colors.orange.withValues(alpha: 0.15);
    }
    if (assignment.isGraded) {
      return const Color(0xffF9C80E).withValues(alpha: 0.15);
    }
    return Colors.white.withValues(alpha: 0.1);
  }

  Color get _statusTextColor {
    if (assignment.isSubmitted) return Colors.green;
    if (assignment.isPending) return Colors.orange;
    if (assignment.isGraded) return const Color(0xffF9C80E);
    return Colors.white70;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xff061220),
            borderRadius: BorderRadius.circular(8.r),
            border: Border(
              left: BorderSide(color: _borderColor, width: 3.w),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      assignment.title ?? 'N/A',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: _statusBgColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      assignment.status ?? 'N/A',
                      style: TextStyle(
                        color: _statusTextColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (assignment.description != null &&
                  assignment.description!.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Text(
                  assignment.description!,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.sp,
                    height: 1.4,
                  ),
                ),
              ],
              SizedBox(height: 14.h),
              Divider(color: const Color(0xff3D4566).withValues(alpha: 0.5)),
              SizedBox(height: 10.h),
              Row(
                children: [
                  _MetaItem(
                    icon: Icons.calendar_today_outlined,
                    label: formattedDate,
                  ),
                  SizedBox(width: 16.w),
                  _MetaItem(
                    icon: Icons.grade_outlined,
                    label: '${assignment.totalMarks ?? 0} marks',
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _MetaItem(
                    icon: Icons.timer_outlined,
                    label: dueDaysLabel,
                    iconColor: assignment.isPending ? Colors.orange : null,
                    labelColor: assignment.isPending ? Colors.orange : null,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white54,
                    size: 14.sp,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.label,
    this.iconColor,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final Color? iconColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor ?? Colors.red, size: 16.sp),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            color: labelColor ?? Colors.white70,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
