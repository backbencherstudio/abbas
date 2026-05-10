import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../cors/routes/route_names.dart';
import '../../../../cors/constants/api_endpoints.dart';
import 'package:http/http.dart' as http;
import '../../../widgets/secondary_appber.dart';
import '../model/all_conversation_model.dart';

class GroupProfileScreen extends StatelessWidget {
  final String conversationId;
  final String groupName;
  final String token;
  final String currentUserId;
  final List<Memberships> memberships;

  const GroupProfileScreen({
    super.key,
    required this.conversationId,
    required this.groupName,
    required this.token,
    required this.currentUserId,
    this.memberships = const [],
  });

  @override
  Widget build(BuildContext context) {
    final memberCount = memberships.length;

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: Column(
        children: [
          SecondaryAppBar(title: "Group Profile"),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 12.h),
                    // Group Avatar
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: const BoxDecoration(
                        color: Color(0xff3D4466),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.groups,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Group Name
                    Text(
                      groupName.isNotEmpty ? groupName : 'Group',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    // Member count
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
                        "$memberCount ${memberCount == 1 ? 'member' : 'members'}",
                        style: TextStyle(
                          color: const Color(0xff5F6CA0),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Action buttons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _mainSection(
                          title: "Audio",
                          icon: Icons.call,
                          ontap: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.audioCallScreen,
                              arguments: {
                                'conversationId': conversationId,
                                'callKind': 'AUDIO',
                                'autoStart': true,
                                'callerName': groupName,
                              },
                            );
                          },
                        ),
                        SizedBox(width: 20.w),
                        _mainSection(
                          title: "Video",
                          icon: Icons.videocam,
                          ontap: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.videoCallScreen,
                              arguments: {
                                'conversationId': conversationId,
                                'callKind': 'VIDEO',
                                'autoStart': true,
                              },
                            );
                          },
                        ),
                        SizedBox(width: 20.w),
                        _mainSection(
                          title: "Mute",
                          icon: Icons.notifications_off_outlined,
                          ontap: () {},
                        ),
                        SizedBox(width: 20.w),
                        _mainSection(
                          title: "Add",
                          icon: Icons.person_add,
                          ontap: () {
                            Navigator.pushNamed(
                                context, RouteNames.addGroupMember);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    const Divider(thickness: 0.7),
                    SizedBox(height: 12.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Chat info",
                        style:
                            TextStyle(color: const Color(0xffB2B5B8), fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // See members
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.seeGroupMemberScreen,
                          arguments: {
                            'memberships': memberships,
                            'groupName': groupName,
                            'token': token,
                            'conversationId': conversationId,
                            'currentUserId': currentUserId,
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.groups, color: const Color(0xff8D9CDC)),
                          SizedBox(width: 12.w),
                          Text(
                            "See members ($memberCount)",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Action",
                        style:
                            TextStyle(color: const Color(0xffB2B5B8), fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Column(
                      children: [
                        _action(title: "View media & file", icon: Icons.perm_media_sharp, onTap: () {}),
                        SizedBox(height: 20.h),
                        _action(title: "Share contact", icon: Icons.share, onTap: () {}),
                        SizedBox(height: 20.h),
                        _action(title: "Report", icon: Icons.report_problem_outlined, onTap: () {}),
                        SizedBox(height: 20.h),
                        _action(
                          title: "Delete conversation",
                          icon: Icons.delete_outline,
                          onTap: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (c) => AlertDialog(
                                backgroundColor: const Color(0xff152033),
                                title: const Text('Delete Conversation', style: TextStyle(color: Colors.white)),
                                content: const Text('Are you sure you want to delete this conversation?', style: TextStyle(color: Colors.white70)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(c, false),
                                    child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(c, true),
                                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              try {
                                final res = await http.post(
                                  Uri.parse(ApiEndpoints.clearConversation(conversationId)),
                                  headers: {
                                    'Authorization': 'Bearer $token',
                                    'Content-Type': 'application/json',
                                  },
                                );
                                if (res.statusCode == 200 || res.statusCode == 201) {
                                  if (context.mounted) {
                                    Navigator.popUntil(context, (route) => route.isFirst);
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to delete conversation')));
                                  }
                                }
                              } catch (e) {
                                debugPrint("Clear error: $e");
                              }
                            }
                          },
                        ),
                        SizedBox(height: 20.h),
                        _action(
                          title: "Leave group",
                          icon: Icons.logout,
                          onTap: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (c) => AlertDialog(
                                backgroundColor: const Color(0xff152033),
                                title: const Text('Leave Group', style: TextStyle(color: Colors.white)),
                                content: const Text('Are you sure you want to leave this group?', style: TextStyle(color: Colors.white70)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(c, false),
                                    child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(c, true),
                                    child: const Text('Leave', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              try {
                                // Assume DELETE or POST for remove. We use DELETE since it's common.
                                final res = await http.delete(
                                  Uri.parse(ApiEndpoints.removeMember(conversationId, currentUserId)),
                                  headers: {
                                    'Authorization': 'Bearer $token',
                                    'Content-Type': 'application/json',
                                  },
                                );
                                if (res.statusCode == 200 || res.statusCode == 201) {
                                  if (context.mounted) {
                                    Navigator.popUntil(context, (route) => route.isFirst);
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to leave group')));
                                  }
                                }
                              } catch (e) {
                                debugPrint("Leave error: $e");
                              }
                            }
                          },
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _action({required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: (title.contains('Delete') || title.contains('Leave') || title.contains('Report')) ? Colors.red : const Color(0xff8D9CDC),
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _mainSection({
    required String title,
    required IconData icon,
    required VoidCallback ontap,
  }) {
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
