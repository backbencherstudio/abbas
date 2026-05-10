import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../cors/constants/api_endpoints.dart';
import '../../../widgets/secondary_appber.dart';
import '../model/all_conversation_model.dart';

class SeeGroupMemberScreen extends StatefulWidget {
  final List<Memberships> memberships;
  final String groupName;
  final String token;
  final String conversationId;
  final String currentUserId;

  const SeeGroupMemberScreen({
    super.key,
    this.memberships = const [],
    this.groupName = 'Group',
    this.token = '',
    this.conversationId = '',
    this.currentUserId = '',
  });

  @override
  State<SeeGroupMemberScreen> createState() => _SeeGroupMemberScreenState();
}

class _SeeGroupMemberScreenState extends State<SeeGroupMemberScreen> {
  late List<Memberships> _memberships;
  bool _iAmAdmin = false;

  @override
  void initState() {
    super.initState();
    _memberships = List.from(widget.memberships);
    _checkMyRole();
  }

  void _checkMyRole() {
    try {
      final myMember = _memberships.firstWhere((m) => m.userId == widget.currentUserId);
      _iAmAdmin = myMember.role?.toUpperCase() == 'ADMIN';
    } catch (_) {
      _iAmAdmin = false;
    }
  }

  Future<void> _removeMember(String userId) async {
    try {
      final res = await http.delete(
        Uri.parse(ApiEndpoints.removeMember(widget.conversationId, userId)),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        setState(() {
          _memberships.removeWhere((m) => m.userId == userId);
        });
      }
    } catch (e) {
      debugPrint("Error removing member: $e");
    }
  }

  Future<void> _updateRole(String userId, String newRole) async {
    try {
      final res = await http.patch(
        Uri.parse(ApiEndpoints.updateMemberRole(widget.conversationId, userId)),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"role": newRole}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        setState(() {
          final idx = _memberships.indexWhere((m) => m.userId == userId);
          if (idx != -1) {
            final old = _memberships[idx];
            _memberships[idx] = Memberships(
              userId: old.userId,
              role: newRole.toUpperCase(),
              lastReadAt: old.lastReadAt,
              clearedAt: old.clearedAt,
            );
          }
        });
      }
    } catch (e) {
      debugPrint("Error updating role: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final admins = _memberships.where((m) => m.role?.toUpperCase() == 'ADMIN').toList();
    final allMembers = _memberships;

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: Column(
        children: [
          SecondaryAppBar(title: "Members"),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: const Color(0xff030D15),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TabBar(
                      tabAlignment: TabAlignment.fill,
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: const Color(0xff8D9CDC),
                      labelColor: Colors.white,
                      indicatorColor: const Color(0xffE9201D),
                      tabs: [
                        Tab(text: "All (${allMembers.length})"),
                        Tab(text: "Admins (${admins.length})"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: TabBarView(
                        children: [
                          _buildMemberList(allMembers),
                          _buildMemberList(admins),
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

  Widget _buildMemberList(List<Memberships> members) {
    if (members.isEmpty) {
      return const Center(
        child: Text(
          "No members found",
          style: TextStyle(color: Color(0xff8C9196)),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        final isAdmin = member.role?.toUpperCase() == 'ADMIN';

        return ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
          leading: Container(
            width: 50.w,
            height: 50.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff1F283D),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 26),
          ),
          title: Text(
            member.userId ?? 'Unknown',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            children: [
              Text(
                member.role ?? 'Member',
                style: TextStyle(
                  color: isAdmin ? const Color(0xffE9201D) : const Color(0xff8C9196),
                  fontSize: 12.sp,
                ),
              ),
              if (isAdmin) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: const Color(0xffE9201D).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xffE9201D).withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    "Admin",
                    style: TextStyle(
                      color: const Color(0xffE9201D),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          trailing: (_iAmAdmin && member.userId != widget.currentUserId)
              ? PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white70),
                  color: const Color(0xff152033),
                  onSelected: (value) {
                    if (value == 'remove') {
                      _removeMember(member.userId!);
                    } else if (value == 'make_admin') {
                      _updateRole(member.userId!, 'ADMIN');
                    } else if (value == 'dismiss_admin') {
                      _updateRole(member.userId!, 'MEMBER');
                    }
                  },
                  itemBuilder: (context) => [
                    if (!isAdmin)
                      const PopupMenuItem(
                        value: 'make_admin',
                        child: Text('Make Admin', style: TextStyle(color: Colors.white)),
                      ),
                    if (isAdmin)
                      const PopupMenuItem(
                        value: 'dismiss_admin',
                        child: Text('Dismiss as Admin', style: TextStyle(color: Colors.white)),
                      ),
                    const PopupMenuItem(
                      value: 'remove',
                      child: Text('Remove from Group', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }
}
