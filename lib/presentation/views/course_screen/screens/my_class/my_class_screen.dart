import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../cors/routes/route_names.dart';
import '../../../../widgets/secondary_appber.dart';

class MyClassScreen extends StatelessWidget {
  const MyClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030D15),
      body: Column(
        children: [
          SecondaryAppBar(title: "Class -1 "),

          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text(
                  "Class: Script Analysis",
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
                  "This module develops the actor's self-awareness and confidence, and creativity in the authentic performance.",
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
                    Icon(Icons.star_rate_outlined, color: Colors.red, size: 16),
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
                    Icon(Icons.star_rate_outlined, color: Colors.red, size: 16),
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
                    Icon(Icons.star_rate_outlined, color: Colors.red, size: 16),
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
                            "Monday",
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
                            "1:30 PM",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 17.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Navigator.pushNamed(context, RouteNames.assetsScreen);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  SvgPicture.asset('assets/icons/folder.svg'),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "Assets",
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10),

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
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/icons/doc.svg'),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "Assignments",
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
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

                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, RouteNames.parentScreen),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/arrow_back.svg', height: 22.w, width: 22.w),
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
  }
}
