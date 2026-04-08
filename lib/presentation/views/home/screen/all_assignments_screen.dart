import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AllAssignmentsScreen extends ConsumerStatefulWidget {
  const AllAssignmentsScreen({super.key});

  @override
  ConsumerState<AllAssignmentsScreen> createState() =>
      _AllAssignmentsScreenState();
}

class _AllAssignmentsScreenState extends ConsumerState<AllAssignmentsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myCourseProvider.notifier).getMyCourse();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final myCourses = ref.watch(myCourseProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Assignments'),
          SizedBox(height: 24.h),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ...((myCourses.value?.data?.myCourses ?? []).map(
                  (course) => GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteNames.allAssignmentDetails,
                        arguments: course.id
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Color(0xFFE9201D), Color(0xFF0A1929)],
                          ),
                        ),
                        child: ListTile(
                          leading: Image.asset('assets/images/face.png'),
                          title: Text(
                            course.title ?? 'course title : N/A',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFFFFFFFF),
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
