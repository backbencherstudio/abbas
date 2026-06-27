import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../cors/constants/api_endpoints.dart';
import '../../../../cors/services/dio_client.dart';
import '../../../widgets/secondary_appber.dart';
import '../model/conversation_detail_model.dart';
import '../provider/conversation_detail_provider.dart';

class SeeGroupMemberScreen extends StatefulWidget {
  final String conversationId;
  final String currentUserId;
  final String groupName;

  const SeeGroupMemberScreen({
    super.key,
    required this.conversationId,
    required this.currentUserId,
    this.groupName = 'Group',
  });

  @override
  State<SeeGroupMemberScreen> createState() => _SeeGroupMemberScreenState();
}

class _SeeGroupMemberScreenState extends State<SeeGroupMemberScreen> {
  late final ConversationDetailProvider _provider;
  final DioClient _dioClient = DioClient();

  @override
  void initState() {
    super.initState();
    _provider = ConversationDetailProvider();
    _provider.fetchMembers(widget.conversationId);
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  bool get _iAmAdmin {
    try {
      return _provider.members
          .firstWhere((m) => m.isMe)
          .isAdmin;
    } catch (_) {
      return false;
    }
  }

  int get _adminCount =>
      _provider.members.where((m) => m.isAdmin).length;

  Future<void> _removeMember(String userId) async {
    final res = await _dioClient.deleteHttp(
      ApiEndpoints.removeMember(widget.conversationId, userId),
    );

    if (!mounted) return;

    if (res is Map && res['success'] == true) {
      await _provider.fetchMembers(widget.conversationId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove member')),
      );
    }
  }

  Future<void> _updateRole(String userId, String newRole) async {
    final res = await _dioClient.patchHttp(
      ApiEndpoints.updateMemberRole(widget.conversationId, userId),
      {'role': newRole},
    );

    if (!mounted) return;

    if (res is Map && res['success'] == true) {
      await _provider.fetchMembers(widget.conversationId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update role')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<ConversationDetailProvider>(
        builder: (context, provider, _) {
          final allMembers = provider.members;
          final admins =
              allMembers.where((m) => m.isAdmin).toList();
          final total = provider.membersTotal > 0
              ? provider.membersTotal
              : allMembers.length;

          return Scaffold(
            backgroundColor: const Color(0xff030D15),
            body: Column(
              children: [
                SecondaryAppBar(title: 'Members'),
                if (provider.isLoadingMembers && allMembers.isEmpty)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xffE9201D),
                      ),
                    ),
                  )
                else
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
                                Tab(text: 'All ($total)'),
                                Tab(text: 'Admins ($_adminCount)'),
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
        },
      ),
    );
  }

  Widget _buildMemberList(List<GroupMember> members) {
    if (members.isEmpty) {
      return const Center(
        child: Text(
          'No members found',
          style: TextStyle(color: Color(0xff8C9196)),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return _MemberTile(
          member: member,
          showAdminActions: _iAmAdmin && !member.isMe,
          onRemove: () => _removeMember(member.userId),
          onMakeAdmin: () => _updateRole(member.userId, 'ADMIN'),
          onDismissAdmin: () => _updateRole(member.userId, 'MEMBER'),
        );
      },
    );
  }
}

class _MemberTile extends StatelessWidget {
  final GroupMember member;
  final bool showAdminActions;
  final VoidCallback onRemove;
  final VoidCallback onMakeAdmin;
  final VoidCallback onDismissAdmin;

  const _MemberTile({
    required this.member,
    required this.showAdminActions,
    required this.onRemove,
    required this.onMakeAdmin,
    required this.onDismissAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final displayName =
        member.isMe ? '${member.name} (You)' : member.name;
    final hasAvatar =
        member.avatar != null && member.avatar!.isNotEmpty;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
      leading: Container(
        width: 50.w,
        height: 50.w,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xff1F283D),
        ),
        clipBehavior: Clip.antiAlias,
        child: hasAvatar
            ? Image.network(
                member.avatar!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 26,
                ),
              )
            : const Icon(Icons.person, color: Colors.white, size: 26),
      ),
      title: Text(
        displayName,
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
          if (member.username != null && member.username!.isNotEmpty)
            Text(
              '@${member.username}',
              style: TextStyle(
                color: const Color(0xff8C9196),
                fontSize: 12.sp,
              ),
            ),
          if (member.username != null && member.username!.isNotEmpty)
            SizedBox(width: 8.w),
          Text(
            _formatRole(member.role),
            style: TextStyle(
              color: member.isAdmin
                  ? const Color(0xffE9201D)
                  : const Color(0xff8C9196),
              fontSize: 12.sp,
            ),
          ),
          if (member.isAdmin) ...[
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: const Color(0xffE9201D).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xffE9201D).withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                'Admin',
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
      trailing: showAdminActions
          ? PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white70),
              color: const Color(0xff152033),
              onSelected: (value) {
                switch (value) {
                  case 'remove':
                    onRemove();
                  case 'make_admin':
                    onMakeAdmin();
                  case 'dismiss_admin':
                    onDismissAdmin();
                }
              },
              itemBuilder: (context) => [
                if (!member.isAdmin)
                  const PopupMenuItem(
                    value: 'make_admin',
                    child: Text(
                      'Make Admin',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (member.isAdmin)
                  const PopupMenuItem(
                    value: 'dismiss_admin',
                    child: Text(
                      'Dismiss as Admin',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Text(
                    'Remove from Group',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            )
          : null,
    );
  }

  String _formatRole(String role) {
    if (role.isEmpty) return 'Member';
    return role[0].toUpperCase() + role.substring(1).toLowerCase();
  }
}
