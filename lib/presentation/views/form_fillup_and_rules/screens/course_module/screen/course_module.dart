import 'package:abbas/presentation/views/form_fillup_and_rules/view_model/form_fill_and_rules_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../widgets/secondary_appber.dart';
import '../../../widgets/course_Detail_Card.dart';
import '../../../widgets/instructor_Card.dart';
import '../../../widgets/subtitle_Content_Card.dart';
import '../../../widgets/subtitle_Content_Row.dart';

class CourseModule extends ConsumerStatefulWidget {
  final String courseId;

  const CourseModule({super.key, required this.courseId});

  @override
  ConsumerState<CourseModule> createState() => _CourseModuleState();
}

class _CourseModuleState extends ConsumerState<CourseModule> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(getCourseDetailsProvider.notifier)
          .getCoursesDetails(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseDetailsState = ref.watch(getCourseDetailsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      extendBodyBehindAppBar: true,
      body: courseDetailsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (data) {
          final courseDetails = data;
          if (courseDetails == null) {
            return const Center(child: Text('No data available'));
          }

          final modules = courseDetails.data?.modules;

          return SingleChildScrollView(
            child: Column(
              children: [
                SecondaryAppBar(title: 'Course Module'),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseDetails.data?.title ?? 'N/A',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      /// ---------------- Course OverView ---------------------
                      SubtitleContentCard(
                        subtitle: courseDetails.data?.courseOverview ?? 'N/A',
                        content: courseDetails.data?.overviewText ?? 'N/A',
                      ),
                      SizedBox(height: 6.h),

                      /// --------------- Course Module ------------------------
                      if (modules!.isNotEmpty)
                        ...modules.map(
                          (module) => CourseDetailCard(
                            title: module.moduleTitle ?? 'N/A',
                            subtitle: module.moduleName ?? 'N/A',
                            content: module.classesCount.toString(),
                          ),
                        ),

                      SizedBox(height: 6.h),

                      /// ---------------- Course Fee --------------------------
                      Card(
                        color: const Color(0xFF0A1A29),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0.r),
                          side: BorderSide(
                            color: Color(0xFF3D4566),
                            width: 1.w,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Course Fee:',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text("\$${courseDetails.data?.fee}"),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                '${courseDetails.data?.installmentProcess}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8.h),
                               Text(
                                'One-time',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Color(0xFF8D9CDC),
                                ),
                              ),
                              SubtitleContentRow(
                                subtitle: '⊹',
                                content: 'You pay the full amount at once.',
                              ),
                              SubtitleContentRow(
                                subtitle: '⊹',
                                content:
                                    'No recurring payments or extra charges.',
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Monthly Installments',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Color(0xFF8D9CDC),
                                ),
                              ),
                              SubtitleContentRow(
                                subtitle: '⊹',
                                content:
                                    'You pay the total amount in smaller,\nrecurring monthly payments.',
                              ),
                              SubtitleContentRow(
                                subtitle: '⊹',
                                content:
                                    'Extra charges may apply, as noted by the\nline: "Monthly plans include extra charges".',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),

                      /// --------------- Instructor ---------------------------
                      InstructorCard(
                        mainTitle: 'Instructor',
                        icon: 'assets/icons/profile_img.png',
                        iconpath: 'assets/icons/instructor_img.png',
                        name:
                            courseDetails.data?.instructor?.name ??
                            'Sophie Lambert',
                        details:
                            '${courseDetails.data?.instructor?.about ?? 'N/A.\n'
                                    'Trained at Royal Academy of Dramatic Art.'}',
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.fillEnrollmentForm,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFFE9201D),
                          minimumSize: Size(double.infinity, 60.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Enroll Now',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
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
