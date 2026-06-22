import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/course_screen/screens/my_course/widget/my_assignment_widget.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllAssignmentsDetailsScreen extends ConsumerStatefulWidget {
  final String courseId;

  const AllAssignmentsDetailsScreen({super.key, required this.courseId});

  @override
  ConsumerState<AllAssignmentsDetailsScreen> createState() =>
      _AllAssignmentsDetailsScreenState();
}

class _AllAssignmentsDetailsScreenState
    extends ConsumerState<AllAssignmentsDetailsScreen> {
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Assignments'),
          Expanded(
            child: assignmentsState.when(
              loading: () => const Center(child: AnimatedLoading()),
              error: (_, __) => Center(
                child: Text(
                  'Failed to load assignments',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
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
            ),
          ),
        ],
      ),
    );
  }
}
