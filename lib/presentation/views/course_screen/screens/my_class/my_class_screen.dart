import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../../cors/routes/route_names.dart';
import '../../../../widgets/secondary_appber.dart';

class MyClassScreen extends ConsumerStatefulWidget {
  final String classId;

  const MyClassScreen({super.key, required this.classId});

  @override
  ConsumerState<MyClassScreen> createState() => _MyClassScreenState();
}

class _MyClassScreenState extends ConsumerState<MyClassScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getClassDetailsProvider.notifier)
          .getClassDetails(classId: widget.classId);
    });
    super.initState();
  }

  /// ------------------- Format Created At ------------------------------------
  String formatCreatedAt(String? createdAt) {
    if (createdAt == null) return 'N/A';
    final dateTime = DateTime.parse(createdAt);
    final formatted = DateFormat('dd-MM-yyyy').format(dateTime);
    return formatted;
  }

  /// ------------------ Format Class Time -------------------------------------
  String formatClassTime(String? classTime) {
    if (classTime == null) return 'N/A';
    try {
      final parts = classTime.split('_');
      final start = DateFormat('HH:mm').parse(parts[0]);
      final end = DateFormat('HH:mm').parse(parts[1]);
      final formattedStart = DateFormat('h:mm a').format(start);

      /// 6.00 PM
      final formattedEnd = DateFormat('h:mm a').format(end);

      /// 8.00 PM
      return '$formattedStart - $formattedEnd';
    } catch (e) {
      return classTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final classes = ref.watch(getClassDetailsProvider);
    return classes.when(
      loading: () => const AnimatedLoading(),
      error: (err, stackTrace) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
          SizedBox(height: 16.h),
          Text(
            "Error : $err",
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
        ],
      ),
      data: (data) {
        final classValue = data?.data;
        final assignments = classValue?.assignments ?? [];

        return Scaffold(
          backgroundColor: Color(0xff030D15),
          body: Column(
            children: [
              SecondaryAppBar(title: classValue?.classTitle ?? 'N/A'),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Text(
                      "Class: ${classValue?.className}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),

                    Divider(thickness: 0.7, color: Color(0xff3D4566)),

                    SizedBox(height: 10),
                    Text(
                      "Class Overview",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      classValue?.classOverview ?? 'N/A',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Key Learning Outcomes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),

                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Gain self-awareness and confidence",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Boost creativity and focus",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Improve communication skills",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xff081623),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.red,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                formatCreatedAt(classValue?.createdAt),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 13),
                              Icon(
                                Icons.access_time_outlined,
                                color: Colors.red,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                formatClassTime(classValue?.classTime),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 17.h),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Color(0xff3D4466),
                                      width: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.assetsScreen,
                                      arguments: widget.classId,
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/folder.svg',
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        "Assets",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Color(0xff3D4466),
                                      width: 1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.classAssignmentsScreen,
                                      arguments: widget.classId
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/assignment_icon.svg',
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        "Assignments",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (assignments.isNotEmpty) SizedBox(width: 10),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteNames.parentScreen,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/arrow_back.svg',
                              height: 22.w,
                              width: 22.w,
                            ),
                            SizedBox(width: 7),
                            Text(
                              "Back to Home",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: Color(0xff8D9CDC),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
