
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
import '../../../../../widgets/secondary_appber.dart';

class AllEvents extends StatefulWidget {
  const AllEvents({super.key});
  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> {
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
        body: Consumer<HomeViewModel>(
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
                  const SecondaryAppBar(title: 'Upcoming Events'),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context,index){
                          return  Column(
                            children: [
                              _SectionTitle('Upcoming Events', trailing: 'View All'),
                              const SizedBox(height: 15),
                              ...data.events.take(2).map(
                                    (e) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _EventCard(item: e),
                                ),
                              ),
                            ],
                          );
                        },



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
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
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
          center: const Alignment(-0.85, -1.8),
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
                    side: const BorderSide(color: Color(0xFF3D4466), width: 2),
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