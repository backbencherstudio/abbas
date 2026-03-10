import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../cors/routes/route_names.dart';
import '../../../../cors/theme/app_colors.dart';
import '../view_model/form_fill_and_rules_provider.dart';

class SelectCourse extends ConsumerStatefulWidget {
  const SelectCourse({super.key});

  @override
  ConsumerState<SelectCourse> createState() => _SelectCourseState();
}

class _SelectCourseState extends ConsumerState<SelectCourse> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(getAllCoursesProvider.notifier).getAllCourses();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final getAllCourse = ref.watch(getAllCoursesProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: getAllCourse.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (data) {
          final course = data;
          if (course == null) {
            return const Center(child: Text('No data available'));
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Text(
                    'Select Course',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: data?.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final value = data?.data?[index];
                      return Card(
                        color: const Color(0xFF0A1A29),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(
                            color: const Color(0xFF3D4566),
                            width: 2.w,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          title: Text(
                            value?.title ?? "N/A",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.fillEnrollmentForm,
                              arguments: value?.id,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
