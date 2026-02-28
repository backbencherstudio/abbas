import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../../data/datasources/home/home_remote_data_sources.dart';
import '../../../../../../data/repositories/home/home_repository_impl.dart';
import '../../../../../../domain/entities/home/home.dart';
import '../../../../../../domain/usecases/home/get_home_data.dart';
import '../../../../../viewmodels/home/home_viewmodel.dart';
import '../../../../../viewmodels/parent/parent_screen_provider.dart';
import '../../../../../widgets/custom_appbar.dart';
import '../../../../../widgets/custom_card.dart';

class ProsHome extends StatefulWidget {
  const ProsHome({super.key});
  @override
  State<ProsHome> createState() => _ProsHomeState();
}

class _ProsHomeState extends State<ProsHome> {
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
      child: Scaffold(
        body:  Consumer<HomeViewModel>(
          builder: (_, vm, __) {
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
                          _SectionTitle('Upcoming Course'),
                           SizedBox(height: 15.h),
                          CustomCard(title: '1 year program ( adult)', subtitle: 'by Prof. Anderson', date: '12 July, Monday', time: '1:30 PM', dateIcon: Icons.calendar_today, timeIcon: Icons.access_time,),
                           SizedBox(height: 16.h),
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
            style: const TextStyle(color: Color(0xFF9AA5B1), fontSize: 12),
          ),
      ],
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
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 16.sp,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                date(item.dateTime),
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
              const SizedBox(width: 7),
              const Text(' • '),
              const SizedBox(width: 7),
              Text(
                time(item.dateTime),
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20.sp,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                item.location,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.note,
            style: const TextStyle(color: Color(0xFFE5E7EB), fontSize: 12),
          ),
          const SizedBox(height: 16),
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
                    Navigator.pushNamed(context, RouteNames.eventDetails);
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
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
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
          )
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String label;
  final String activeIcon;
  final String inactiveIcon;
  final bool isActive;
  final VoidCallback onTap;

  const _Item({
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const active = Color(0xFFE33632);
    const inactive = Color(0xFF8A96A3);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(isActive ? activeIcon : inactiveIcon, height: 22.h, width: 22.w),
            const SizedBox(height: 6),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? active : inactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

