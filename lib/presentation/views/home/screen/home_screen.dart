import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../cors/routes/route_names.dart';
import '../../../../cors/theme/app_colors.dart';
import '../../../../data/datasources/home/home_remote_data_sources.dart';
import '../../../../data/repositories/home/home_repository_impl.dart';
import '../../../../domain/entities/home/home.dart';
import '../../../../domain/usecases/home/get_home_data.dart';
import '../../../viewmodels/home/home_viewmodel.dart';
import '../../../widgets/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = HomeViewModel(GetHomeData(HomeRepositoryImpl(HomeRemoteDataSource())));
    vm.load('user-123');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Consumer<HomeViewModel>(
        builder: (_, vm, _) {
          if (vm.loading) {
            return const _Shell(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (vm.error != null) {
            return _Shell(child: Center(child: Text('Error: ${vm.error}')));
          }

          final data = vm.data!;
          return _Shell(
            child: Column(
              children: [
                CustomAppbar(
                  title: "Hello, Tisha!",
                  subtitle: "Welcome back!",
                  image: "assets/icons/search.png",
                  image2: "assets/icons/notification.png",
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ListView(
                      children: [
                        _SectionTitle('Quick Access'),
                        const SizedBox(height: 8),
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
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.prosHome,
                                );
                              },
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
                        const SizedBox(height: 16),
                        _SectionTitle('Upcoming Class'),
                        const SizedBox(height: 8),
                        if (data.upcoming != null)
                          _ClassCard(item: data.upcoming!),
                        const SizedBox(height: 16),
                        _SectionTitle('Assignments', trailing: 'View All'),
                        const SizedBox(height: 8),
                        ...data.assignments.map(
                          (a) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _AssignmentCard(item: a),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _SectionTitle('Upcoming Events', trailing: 'View All'),
                        const SizedBox(height: 8),
                        ...data.events.map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _EventCard(item: e),
                          ),
                        ),
                      ],
                    ),
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

class _Shell extends StatelessWidget {
  final Widget child;

  const _Shell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background, body: child);
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final String? trailing;

  const _SectionTitle(this.text, {this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        if (trailing != null)
          Text(
            trailing!,
            style: TextStyle(
              color: Color(0xFFDFE1E7),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
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
        Navigator.pushNamed(context, RouteNames.prosHome);
        break;
      case 'note':
        Navigator.pushNamed(context, RouteNames.scanner);
        break;
      case 'folder':
        Navigator.pushNamed(context, RouteNames.scanner);
        break;
      default:
        Navigator.pushNamed(context, RouteNames.scanner);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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

class _ClassCard extends StatelessWidget {
  final ClassSession item;

  const _ClassCard({required this.item});

  String _date(DateTime d) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const w = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${d.day} ${m[d.month - 1]}, ${w[d.weekday - 1]}';
  }

  String _time(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final m = d.minute.toString().padLeft(2, '0');
    final p = d.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $p';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            '${item.title} (${item.section})',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'by ${item.teacher}',
            style: TextStyle(color: Color(0xFFEAD8D9), fontSize: 13.sp),
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
                _date(item.dateTime),
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
              SizedBox(width: 16.w),
              Icon(
                Icons.access_time_outlined,
                size: 16.sp,
                color: AppColors.splashRed,
              ),
              SizedBox(width: 6.w),
              Text(
                _time(item.dateTime),
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
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
                    fixedSize:  Size.fromHeight(48.h),
                    side: BorderSide(color: Color(0xFF3D4466), width: 2),
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
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  final Assignment item;

  const _AssignmentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final days = item.dueAt.difference(DateTime.now()).inDays.abs();
    return Container(
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
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    '${item.course} • ${item.teacher}',
                    style: TextStyle(color: Color(0xFF9AA5B1), fontSize: 12.sp),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(Icons.schedule, size: 16.sp, color: Colors.white),
              SizedBox(width: 6.w),
              Text(
                'Due in $days days',
                style: TextStyle(color: Color(0xFFFFC9A3), fontSize: 12.sp),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size.fromHeight(48.h),
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Color(0xFF3D4466), width: 2.w),
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
              SizedBox(
                width: 174.w,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
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
            ],
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventItem item;

  const _EventCard({required this.item});

  @override
  Widget build(BuildContext context) {
    String date(DateTime d) {
      const m = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      const w = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return '${d.day} ${m[d.month - 1]}, ${w[d.weekday - 1]}';
    }

    String time(DateTime d) {
      final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
      final m = d.minute.toString().padLeft(2, '0');
      final p = d.hour >= 12 ? 'PM' : 'AM';
      return '$h:$m $p';
    }

    return Container(
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
            item.title,
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
                date(item.dateTime),
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
              SizedBox(width: 7.w),
              const Text(' • ', style: TextStyle(color: Colors.white)),
              SizedBox(width: 7.w),
              Text(
                time(item.dateTime),
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
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
                item.location,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            item.note,
            style: TextStyle(color: Color(0xFFE5E7EB), fontSize: 12.sp),
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
                    side: BorderSide(color: Color(0xFF3D4466), width: 2),
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
                    Navigator.pushNamed(context, RouteNames.allEvents);
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
    );
  }
}
