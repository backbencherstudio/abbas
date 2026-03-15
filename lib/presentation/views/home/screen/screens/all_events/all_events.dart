import 'package:abbas/presentation/views/home/view_model/events_provider.dart';
import 'package:abbas/presentation/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../widgets/secondary_appber.dart';

class AllEvents extends ConsumerStatefulWidget {
  const AllEvents({super.key});

  @override
  ConsumerState<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends ConsumerState<AllEvents> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(getAllEventsProvider.notifier).getAllEvents();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allEventsData = ref.watch(getAllEventsProvider);
    final allEvents = allEventsData.value ?? [];
    if (allEventsData.isLoading) {
      return ListView(
        children: [
          shimmerWidget(),
          SizedBox(height: 12.h),
          shimmerWidget(),
          SizedBox(height: 12.h),
        ],
      );
    }
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SecondaryAppBar(title: 'Upcoming Events'),
          SizedBox(height: 24.h,),
          Padding(
            padding:  EdgeInsets.only(left: 16.w),
            child: Text(
              "All Events",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 16.w),
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  final event = allEvents[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(-0.85, -1.8),
                            radius: 1.5,
                            colors: [
                              AppColors.splashRed,
                              AppColors.cardBackground,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event?.name ?? 'N/A',
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
                                const SizedBox(width: 6),
                                Text(
                                  '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                const Text(' • '),
                                const SizedBox(width: 7),
                                Text(
                                  '',
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
                                SizedBox(width: 6.h),
                                Text(
                                  event?.location ?? 'N/A',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                             SizedBox(height: 8.h),
                            Text(
                              event?.description ?? 'N/A',
                              style:  TextStyle(
                                color: Color(0xFFE5E7EB),
                                fontSize: 12.sp,
                              ),
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
                                      side: const BorderSide(
                                        color: Color(0xFF3D4466),
                                        width: 2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
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
                                        RouteNames.eventDetails,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size.fromHeight(56),
                                      backgroundColor: AppColors.splashRed,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                            ),
                          ],
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
  }
}
