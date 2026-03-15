import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';

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
    final assignmentsProvider = ref.watch(getMyAssignmentsProvider);
    final assignmentsData = assignmentsProvider.value;
    final modules = assignmentsData?.data ?? [];

    /// -------- Loading --------
    if (assignmentsProvider.isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            shimmerWidget(),
            SizedBox(height: 12.h),
            shimmerWidget(),
          ],
        ),
      );
    }

    /// -------- Error --------
    if (assignmentsProvider.hasError) {
      return Center(
        child: Text(
          "Failed to load assignments",
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      );
    }

    /// -------- Data UI --------
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      children: [
        ...modules.map((module) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Module Title
              Text(
                "${module.moduleTitle ?? ''} : ${module.moduleName ?? ''}",
                style: TextStyle(
                  color: Color(0xff8C9196),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 10.h),

              /// Assignments List
              ...?module.assignments?.map((value) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 7.h),
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
                        /// Assignment Title
                        Expanded(
                          child: Text(
                            value.title ?? 'N/A',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),

                        /// Due Label
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: Color(0xffF9C80E),
                          ),
                          child: Text(
                            value.dueLabel ?? 'N/A',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),

                        SizedBox(width: 10.w),

                        /// Navigate Button
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.dueAssignmentScreen,
                              arguments: value.id,
                            );
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        }),

        SizedBox(height: 20.h),

        /// -------- Submitted Assignments Example --------
        Text(
          "Module 1 : Personal Development",
          style: TextStyle(
            color: Color(0xff8C9196),
            fontSize: 14.sp,
          ),
        ),

        SizedBox(height: 10.h),

        ...List.generate(2, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 7.h),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                RouteNames.submittedAssignmentScreen,
              ),
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
                    Text(
                      "Assignment ${index + 4}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),

                    SizedBox(width: 10.w),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Color(0xff1E273D),
                      ),
                      child: Text(
                        "Submitted",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),

                    SizedBox(width: 10.w),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Color(0xff1E273D),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Grade: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            "A+",
                            style: TextStyle(
                              color: AppColors.radishTextColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Spacer(),

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
        }),
      ],
    );
  }
}