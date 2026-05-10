import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/secondary_appber.dart';
import '../model/all_conversation_model.dart';

class SeeGroupMemberScreen extends StatelessWidget {
  final List<Memberships> memberships;
  final String groupName;

  const SeeGroupMemberScreen({
    super.key,
    this.memberships = const [],
    this.groupName = 'Group',
  });

  @override
  Widget build(BuildContext context) {
    final admins =
        memberships.where((m) => m.role?.toUpperCase() == 'ADMIN').toList();
    final allMembers = memberships;

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

        return Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
          child: Row(
            children: [
              // Avatar placeholder (userId as fallback)
              Container(
                width: 50.w,
                height: 50.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff1F283D),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 26),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.userId ?? 'Unknown',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      member.role ?? 'Member',
                      style: TextStyle(
                        color: isAdmin
                            ? const Color(0xffE9201D)
                            : const Color(0xff8C9196),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              if (isAdmin)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffE9201D).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xffE9201D).withValues(alpha: 0.4),
                    ),
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
          ),
        );
      },
    );
  }
}
