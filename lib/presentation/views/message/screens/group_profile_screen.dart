import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../cors/routes/route_names.dart';
import '../../../widgets/secondary_appber.dart';

class GroupProfileScreen extends StatelessWidget {
  const GroupProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: Column(
        children: [
          SecondaryAppBar(title: "Group Profile"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Color(0xff3D4466),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.groups, color: Colors.white, size: 50),
                ),
                SizedBox(height: 10.h),
                Text(
                  "1 YP A1-2025",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff0A1A2A),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "@Create by @cameron_williamson",
                    style: TextStyle(
                      color: const Color(0xff5F6CA0),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    mainSection(title: "Audio", icon: Icons.call, ontap: () {}),
                    SizedBox(width: 20.w),
                    mainSection(
                      title: "Video",
                      icon: Icons.videocam,
                      ontap: () {},
                    ),
                    SizedBox(width: 20.w),
                    mainSection(
                      title: "Mute",
                      icon: Icons.notification_important,
                      ontap: () {},
                    ),
                    SizedBox(width: 20.w),

                    mainSection(
                      title: "add",
                      icon: Icons.person_add,
                      ontap: () {
                        Navigator.pushNamed(context, RouteNames.addGroupMember);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Divider(thickness: 0.7),
                SizedBox(height: 0),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Chat info",
                    style: TextStyle(color: Color(0xffB2B5B8)),
                  ),
                ),
                SizedBox(height: 20),

                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, RouteNames.seeGroupMemberScreen);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.groups, color: Color(0xff8D9CDC)),
                      SizedBox(width: 12.w),
                      Text("See members"),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Action",
                    style: TextStyle(color: Color(0xffB2B5B8)),
                  ),
                ),

                SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    action(
                      title: "View media & file",
                      icon: Icons.perm_media_sharp,
                    ),
                    SizedBox(height: 20.h),
                    action(title: "Share contact", icon: Icons.share),
                    SizedBox(height: 20.h),

                    action(
                      title: "Report",
                      icon: Icons.report_problem_outlined,
                    ),
                    SizedBox(height: 20.h),

                    action(
                      title: "Delete conversations",
                      icon: Icons.delete_outline,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget action({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(
          icon,
          color: title == "Delete conversations"
              ? Colors.red
              : Color(0xff8D9CDC),
          size: 20.sp,
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget mainSection({required String title, required IconData icon ,required void Function() ontap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: ontap,
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xff0A1A2A),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(icon, color: const Color(0xff8D9CDC), size: 24.sp),
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
      ],
    );
  }
}
