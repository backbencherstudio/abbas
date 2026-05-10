import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../cors/routes/route_names.dart';
import '../../../widgets/secondary_appber.dart';

class UserProfileScreen extends StatelessWidget {
  final String conversationId;
  final String receiverName;
  final String avatarUrl;

  const UserProfileScreen({
    super.key,
    this.conversationId = '',
    this.receiverName = 'User',
    this.avatarUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: Column(
        children: [
          SecondaryAppBar(title: "Profile"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 12.h),
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: const BoxDecoration(
                    color: Color(0xff1F283D),
                    shape: BoxShape.circle,
                  ),
                  child: avatarUrl.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 50,
                        ),
                ),
                SizedBox(height: 10.h),
                Text(
                  receiverName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    mainSection(
                      title: "Audio",
                      icon: Icons.call,
                      ontap: () {
                        if (conversationId.isNotEmpty) {
                          Navigator.pushNamed(
                            context,
                            RouteNames.audioCallScreen,
                            arguments: {
                              'conversationId': conversationId,
                              'callKind': 'AUDIO',
                              'autoStart': true,
                              'callerName': receiverName,
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(width: 20.w),
                    mainSection(
                      title: "Video",
                      icon: Icons.videocam,
                      ontap: () {
                        if (conversationId.isNotEmpty) {
                          Navigator.pushNamed(
                            context,
                            RouteNames.videoCallScreen,
                            arguments: {
                              'conversationId': conversationId,
                              'callKind': 'VIDEO',
                              'autoStart': true,
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(width: 20.w),
                    mainSection(
                      title: "Mute",
                      icon: Icons.notifications_off_outlined,
                      ontap: () {},
                    ),
                    SizedBox(width: 20.w),
                    mainSection(
                      title: "Profile",
                      icon: Icons.person,
                      ontap: () {},
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Divider(thickness: 0.7),
                SizedBox(height: 0),

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
                    action(title: "View media & file", icon: Icons.perm_media_sharp),
                    SizedBox(height: 20.h),
                    action(title: "Share contact", icon: Icons.share),
                    SizedBox(height: 20.h),
                    action(
                      title: "Report",
                      icon: Icons.report_problem_outlined,
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

  Widget mainSection({required String title, required IconData icon, required VoidCallback ontap}) {
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
          style: TextStyle(color: Colors.white, fontSize: 13.sp),
        ),
      ],
    );
  }
}
