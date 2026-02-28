import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/secondary_appber.dart';

class SeeGroupMemberScreen extends StatelessWidget {
  const SeeGroupMemberScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030D15),
      body: Column(
        children: [
          SecondaryAppBar(title: "Member"),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Color(0xff030D15),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TabBar(
                      tabAlignment: TabAlignment.fill,
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: Color(0xff8D9CDC),
                      labelColor: Color(0xffFFFFFF),
                      indicatorColor: Color(0xffE9201D),
                      tabs: [
                        Tab(text: "All"),
                        Tab(text: "Admins"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TabBarView(
                        children: [
                          ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, child) {
                              return Container(
                                padding: EdgeInsets.all(7.w),
                                decoration: BoxDecoration(),
                                child: Row(
                                  children: [
                                    ClipOval(
                                      child: Image.asset(
                                        "assets/images/profile.png",
                                        height: 60,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),

                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Abdul Rakib",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),

                                        Text(
                                          "@abdul_rakib",
                                          style: TextStyle(
                                            color: Color(0xffA5A5AB),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, child) {
                              return Container(
                                padding: EdgeInsets.all(7.w),

                                decoration: BoxDecoration(),
                                child: Row(
                                  children: [
                                    ClipOval(
                                      child: Image.asset(
                                        "assets/images/profile.png",
                                        height: 60,
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text("Abdul Wahab"),

                                        Text(
                                          "@abdul_wahab",
                                          style: TextStyle(
                                            color: Color(0xffA5A5AB),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
