import 'package:abbas/presentation/views/home/view_model/events_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../widgets/primary_button.dart';
import '../../../../../widgets/secondary_appber.dart';

class EventDetails extends ConsumerStatefulWidget {
  final String eventId;

  const EventDetails({super.key, required this.eventId});

  @override
  ConsumerState<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends ConsumerState<EventDetails> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(getEventByIdProvider.notifier).getEventById(widget.eventId);
    });
    super.initState();
  }

  String formatEventDate(String? startAt) {
    if (startAt == null || startAt.isEmpty) return 'N/A';
    final dateTime = DateTime.tryParse(startAt);
    if (dateTime == null) return 'N/A';
    return DateFormat('dd-MM-yyyy').format(dateTime.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final eventDetailsProvider = ref.watch(getEventByIdProvider);
    final eventDetails = eventDetailsProvider.value?.data;

    return Scaffold(
      backgroundColor: Color(0xff030D15),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SecondaryAppBar(title: 'Event Details'),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

            if (eventDetailsProvider.isLoading) const AnimatedLoading(),
            if (eventDetailsProvider.hasError)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    eventDetailsProvider.error.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Color(0xff1C2C41),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xff2A3856), width: 2.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventDetails?.name ?? 'N/A',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/calender.png',
                          scale: 3.8,
                          color: Color(0xffE9201D),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          "${formatEventDate(eventDetails?.startAt)} • ${eventDetails?.time ?? 'N/A'}",
                          style: TextStyle(
                            color: Color(0xffE9E9EA),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/location.png',
                          scale: 2.8,
                          color: Color(0xffE9201D),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          eventDetails?.location ?? 'N/A',
                          style: TextStyle(
                            color: Color(0xffE9E9EA),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/coins.png',
                          scale: 2.8,
                          color: Color(0xffE9201D),
                        ),
                        SizedBox(width: 5.w),
                        Icon(
                          Icons.attach_money,
                          color: Colors.grey[100],
                          size: 20,
                        ),
                        Text(
                          eventDetails?.displayFee ?? 'N/A',
                          style: TextStyle(
                            color: Color(0xffE9E9EA),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                padding: EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Color(0xff1C2C41),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xff2A3856), width: 2.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Event Overview",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      eventDetails?.overview?.isNotEmpty == true
                          ? eventDetails!.overview!
                          : (eventDetails?.description ?? 'No overview available'),
                      style: TextStyle(
                        color: Color(0xffE9E9EA),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (eventDetails?.description?.isNotEmpty == true &&
                        eventDetails?.overview?.isNotEmpty == true) ...[
                      SizedBox(height: 15.h),
                      Text(
                        "Description",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        eventDetails!.description!,
                        style: TextStyle(
                          color: Color(0xffE9E9EA),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Color(0xff1C2C41),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xff2A3856), width: 2.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      " Ticket Information",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "Limited tickets available — reserve early!",
                      style: TextStyle(
                        color: Color(0xffD2D2D5),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.h),
            if (eventDetails?.isRegistered != true)
              Align(
                alignment: Alignment.center,
                child: PrimaryButton(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.completePayment,
                      arguments: widget.eventId,
                    );
                  },
                  color: Color(0xFFE9201D),
                  textColor: Colors.white,
                  icon: '',
                  child: Text(
                    "Get Ticket",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF142331),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF3D4566)),
                  ),
                  child: Text(
                    'You are registered for this event',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 25.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
