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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getClassDetailsProvider.notifier)
          .getClassDetails(classId: widget.classId);
    });
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return 'N/A';
    return DateFormat('dd MMM yyyy').format(parsed.toLocal());
  }

  String formatTime(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return 'N/A';
    return DateFormat('hh:mm a').format(parsed.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final classState = ref.watch(getClassDetailsProvider);

    return classState.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xff030D15),
        body: Column(
          children: [
            SecondaryAppBar(title: 'Class'),
            Expanded(child: Center(child: AnimatedLoading())),
          ],
        ),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: const Color(0xff030D15),
        body: Column(
          children: [
            const SecondaryAppBar(title: 'Class'),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      data: (model) {
        final classValue = model?.data;
        if (classValue == null) {
          return const Scaffold(
            backgroundColor: Color(0xff030D15),
            body: Column(
              children: [
                SecondaryAppBar(title: 'Class'),
                Expanded(
                  child: Center(
                    child: Text(
                      'No class data available',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xff030D15),
          body: Column(
            children: [
              SecondaryAppBar(title: classValue.classTitle ?? 'Class'),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16.w),
                  children: [
                    Text(
                      'Class: ${classValue.className ?? 'N/A'}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Divider(thickness: 0.7, color: const Color(0xff3D4566)),
                    Text(
                      'Class Overview',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      classValue.classOverview ?? 'N/A',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff081623),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.red,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                formatDate(classValue.classAt),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Icon(
                                Icons.access_time_outlined,
                                color: Colors.red,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                formatTime(classValue.classAt),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (classValue.duration != null) ...[
                                SizedBox(width: 16.w),
                                Text(
                                  '${classValue.duration} min',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 17.h),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xff3D4466),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.r),
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
                                        'Assets',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
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
                                    side: const BorderSide(
                                      color: Color(0xff3D4466),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.classAssignmentsScreen,
                                      arguments: widget.classId,
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
                                        'Assignments',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        RouteNames.parentScreen,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/arrow_back.svg',
                            height: 22.w,
                            width: 22.w,
                          ),
                          SizedBox(width: 7.w),
                          Text(
                            'Back to Home',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: const Color(0xff8D9CDC),
                            ),
                          ),
                        ],
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
