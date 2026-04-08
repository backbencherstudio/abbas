import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/views/home/view_model/get_home_data_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../cors/routes/route_names.dart';
import '../../../../cors/theme/app_colors.dart';
import '../../../widgets/custom_appbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(getHomeDataProvider.notifier).getHomeData();
    });
    super.initState();
  }

  /// ------------------- Formatted Date ---------------------------------------
  String formattedDate(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return 'N/A';

    final parseDate = DateTime.tryParse(createdAt);
    if (parseDate == null) return 'N/A';

    return "${parseDate.year}-${parseDate.month}-${parseDate.day}";
  }

  /// -------------------- Due Date Format -------------------------------------
  String dueDateFormatted(String? dueDate) {
    if (dueDate == null || dueDate.isEmpty) return 'N/A';

    final parseDate = DateTime.tryParse(dueDate);
    if (parseDate == null) return 'N/A';

    final now = DateTime.now();
    final difference = parseDate.difference(now).inDays;

    return difference.toString();
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
    final homeDataWatch = ref.watch(getHomeDataProvider);
    final homeData = homeDataWatch.value;
    final userProfileValues = homeData?.userProfile;
    final upComingClassesValues = homeData?.upcomingClasses;
    final upComingAssignmentsValues = homeData?.upcomingAssignments;
    final upComingEventsValues = homeData?.upcomingEvents;
    return Scaffold(
      body: Column(
        children: [
          CustomAppbar(
            title: userProfileValues?.name ?? 'N/A',
            subtitle: "Welcome back!",
          ),

          SizedBox(height: 24.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Text(
                    "Quick Access",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _QuickGrid(
                    items: [
                      QuickAction(
                        icon: 'qr',
                        label: 'Attendance',
                        onTap: () {},
                      ),
                      QuickAction(
                        icon: 'book',
                        label: 'My Course',
                        onTap: () {},
                      ),
                      QuickAction(
                        icon: 'note',
                        label: 'Assignments',
                        onTap: () {},
                      ),
                      QuickAction(
                        icon: 'folder',
                        label: 'Assets',
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Upcoming Class",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  if (homeDataWatch.isLoading) AnimatedLoading(),

                  /// ----------- Up Coming Class --------------------------
                  SizedBox(height: 12.h),
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(0.85, -1.8),
                        radius: 2,
                        colors: [AppColors.splashRed, AppColors.cardBackground],
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${upComingClassesValues?.moduleTitle ?? 'N/A'} (${upComingClassesValues?.classTitle ?? 'N/A'})',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'by ${upComingClassesValues?.instructorName ?? 'N/A'}',
                          style: TextStyle(
                            color: Color(0xFFEAD8D9),
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(height: 18.h),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              size: 16.sp,
                              color: AppColors.splashRed,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              formattedDate(upComingClassesValues?.startDate),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Icon(
                              Icons.access_time_outlined,
                              size: 16.sp,
                              color: AppColors.splashRed,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              formatClassTime(
                                upComingClassesValues?.classTime ?? 'N/A',
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  fixedSize: Size.fromHeight(48.h),
                                  side: BorderSide(
                                    color: Color(0xFF3D4466),
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/note.svg',
                                      height: 16.h,
                                      width: 16.h,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      'Materials',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size.fromHeight(48.h),
                                  backgroundColor: AppColors.splashRed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/video.svg',
                                      height: 16.h,
                                      width: 16.h,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      'Join Class',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
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
                  SizedBox(height: 16.h),

                  /// --------------- Assignments --------------------------
                  Text(
                    "Upcoming Assignments",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: Color(0xFF0A1A29), width: 1.w),
                    ),
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: AppColors.subContainerColor,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/note.svg',
                                height: 24.h,
                                width: 24.h,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.splashRed,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  upComingAssignmentsValues?.title ?? 'N/A',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  '${upComingAssignmentsValues?.courseTitle ?? 'N/A'} • ${upComingAssignmentsValues?.teacherName ?? 'N/A'}',
                                  style: TextStyle(
                                    color: Color(0xFF9AA5B1),
                                    fontSize: 12.sp,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      size: 16.sp,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      'Due in ${dueDateFormatted(upComingAssignmentsValues?.dueDate)} days',
                                      style: TextStyle(
                                        color: Color(0xFFFFC9A3),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 18.h),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () async {
                                  await ref
                                      .read(
                                        getAssignmentDetailsProvider.notifier,
                                      )
                                      .getAssignmentDetails(
                                        assignmentId:
                                            upComingAssignmentsValues?.id ?? "",
                                      );
                                  if (context.mounted) {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.dueAssignmentScreen,
                                      arguments: upComingAssignmentsValues?.id,
                                    );
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  fixedSize: Size.fromHeight(48.h),
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Color(0xFF3D4466),
                                    width: 2.w,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Text(
                                  'View Details',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: SizedBox(
                                width: 174.w,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    fixedSize: Size.fromHeight(48.h),
                                    backgroundColor: AppColors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Submit Assignment',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xFF030C15),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  /// ------------- Upcoming Events ------------------------
                  Text(
                    "Upcoming Events",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(-0.85, -1.8),
                        radius: 1.5,
                        colors: [AppColors.splashRed, AppColors.cardBackground],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          upComingEventsValues?.name ?? 'N/A',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              formattedDate(upComingEventsValues?.date),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(width: 7.w),
                            const Text(
                              ' • ',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 7.w),
                            Text(
                              formatClassTime(
                                upComingEventsValues?.time ?? 'N/A',
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 20.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              upComingEventsValues?.location ?? 'N/A',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          upComingEventsValues?.description ?? 'N/A',
                          style: TextStyle(
                            color: Color(0xFFE5E7EB),
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  fixedSize: const Size.fromHeight(56),
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Color(0xFF3D4466),
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Text(
                                  'View Details',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.allEvents,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size.fromHeight(56),
                                  backgroundColor: AppColors.splashRed,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/ticket.svg',
                                      height: 16.h,
                                      width: 16.h,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      'Get Tickets',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
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
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickAction {
  final String icon;
  final String label;
  final VoidCallback onTap;

  QuickAction({required this.icon, required this.label, required this.onTap});
}

class _QuickGrid extends StatelessWidget {
  final List<QuickAction> items;

  const _QuickGrid({required this.items});

  String _icon(String k) {
    switch (k) {
      case 'qr':
        return 'assets/icons/qr.svg';
      case 'book':
        return 'assets/icons/menu.svg';
      case 'note':
        return 'assets/icons/note.svg';
      case 'folder':
        return 'assets/icons/folder_red.svg';
      default:
        return 'assets/icons/qr.svg';
    }
  }

  void _handleTap(BuildContext context, String icon) {
    switch (icon) {
      case 'qr':
        Navigator.pushNamed(context, RouteNames.scanner);
        break;
      case 'book':
        Navigator.pushNamed(context, RouteNames.homeMyCourseScreen);
        break;
      case 'note':
        Navigator.pushNamed(context, RouteNames.allAssignmentsScreen);
        break;
      case 'folder':
        Navigator.pushNamed(context, RouteNames.homeAssetsCoursesScreen);
        break;
      default:
        Navigator.pushNamed(context, RouteNames.scanner);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final it = items[i];
        return GestureDetector(
          onTap: () => _handleTap(context, it.icon),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.quickGridBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderColor),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(_icon(it.icon), height: 32.h, width: 32.h),
                SizedBox(height: 10.h),
                Text(
                  it.label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
