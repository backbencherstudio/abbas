import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getModuleDetailsProvider.notifier)
          .getModuleDetails(moduleId: widget.moduleId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final modules = ref.watch(getModuleDetailsProvider);
    return modules.when(
      loading: () => const CircularProgressIndicator(color: Colors.white),
      error: (err, stackTrace) => Center(
        child: Text(
          "Error : $err",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      data: (data) {
        final module = data;
        final valueModules = module?.data;
        final valueClasses = module?.data?.classes ?? [];
        return Scaffold(
          backgroundColor: Color(0xff030D15),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SecondaryAppBar(title: valueModules?.moduleTitle ?? 'N/A'),
              Padding(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Module: ${valueModules?.moduleName ?? 'N/A'}",
                      style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Divider(color: Color(0xff3D4566), thickness: 0.7),
                    Text(
                      "Module OverView",
                      style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 10.h),
                    Text(
                      valueModules?.moduleOverview ?? 'N/A',
                      style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Key Learning Outcomes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 14,
                        ),
                        SizedBox(width: 7.w),
                        Text(
                          "Gain self-awareness",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 14,
                        ),
                        SizedBox(width: 7.w),
                        Text(
                          "Boost creativity and focus",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 14,
                        ),
                        SizedBox(width: 7.w),
                        Text(
                          "Improve communication skills",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Text(
                          "All Classes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xff1E273D),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Text(
                            valueModules?.moduleTitle ?? 'N/A',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),
                    ...valueClasses.map((value) {
                      return Column(
                        spacing: 12.h,
                        children: [
                          _buildClassContainer(
                            title: value.classTitle ?? 'N/A',
                            subtitle: value.className ?? 'N/A',
                            onTap: () => Navigator.pushNamed(
                              context,
                              RouteNames.myClassScreen,
                              arguments: value.id ?? 'N/A',
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClassContainer({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Color(0xff8D9CDC), width: 3.w),
        ),
        color: Color(0xff0A1A2A),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Color(0xff8D9CDC),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: onTap,
                child: Icon(Icons.arrow_forward_ios, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
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
}
