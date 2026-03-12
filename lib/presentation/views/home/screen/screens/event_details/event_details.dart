import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../widgets/primary_button.dart';
import '../../../../../widgets/secondary_appber.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030D15),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SecondaryAppBar(title: 'Event Details'),

            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                      "Annual Alumni Meetup",
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
                          "12 July, Monday 󠁯•󠁏󠁏 1:30 PM",
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
                          "Main Theater",
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
                          "246",
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
              padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                      "The Annual Alumni Meetup is a special gathering designed to bring together our alumni, current students, and faculty. This year’s event will feature an evening of outstanding performances by our talented students, celebrating creativity, talent, and the strong bond within our community.",
                      style: TextStyle(
                        color: Color(0xffE9E9EA),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      "Highlights of the Event",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.star_rate_outlined,
                          color: Colors.red,
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          " Live performances by current students",
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
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Networking opportunities with alumni",
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
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          " Inspiring speeches and shared experiences",
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
                          size: 10,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "A celebration of achievements and",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "community spirit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
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
            Align(
              alignment: Alignment.center,
              child: PrimaryButton(
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.completePayment);
                },
                color: Color(0xFFE9201D),
                textColor: Colors.white,
                icon: '',
                child: Text("Get Ticket"),
              ),
            ),
            SizedBox(height: 25.h),
          ],
        ),
      ),
    );
  }
}
