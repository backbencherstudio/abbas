import 'package:abbas/cors/theme/app_colors.dart';
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
    final assignmentsProvider = ref.watch(getMyAssignmentsProvider);
    final assignmentsData = assignmentsProvider.value;
    final modules = assignmentsData?.data ?? [];

    if (assignmentsProvider.isLoading) {
      return Center(child: AnimatedLoading());
    }

    if (assignmentsProvider.hasError) {
      return Center(
        child: Text(
          "Failed to load assignments",
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Assignments'),
          SizedBox(height: 24.h),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              children: modules.map((module) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    iconTheme: const IconThemeData(color: Colors.white),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      "${module.moduleTitle ?? ''} : ${module.moduleName ?? ''}",
                      style: TextStyle(
                        color: Color(0xff8C9196),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: (module.assignments ?? []).map((value) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 7.h),
                        child: InkWell(
                          onTap: () {
                            if (value.status == 'SUBMITTED') {
                            } else {}
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 20.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(color: Colors.red, width: 3.w),
                              ),
                              color: Color(0xff061220),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    value.title ?? 'N/A',
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
                                    color: value.status == 'SUBMITTED'
                                        ? Color(0xFF1E273D)
                                        : Color(0xffF9C80E),
                                  ),
                                  child: Center(
                                    child: Text(
                                      value.status == 'SUBMITTED'
                                          ? 'Submitted'
                                          : value.dueLabel ?? 'N/A',
                                      style: TextStyle(
                                        color: value.status == 'SUBMITTED'
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
