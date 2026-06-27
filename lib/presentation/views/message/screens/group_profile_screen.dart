import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../cors/routes/route_names.dart';
import '../../../widgets/secondary_appber.dart';
import '../provider/conversation_detail_provider.dart';
import '../widgets/conversation_mute_sheet.dart';
import '../widgets/conversation_media_files_sheet.dart';

class GroupProfileScreen extends StatefulWidget {
  final String conversationId;
  final String groupName;
  final String currentUserId;

  const GroupProfileScreen({
    super.key,
    required this.conversationId,
    required this.groupName,
    required this.currentUserId,
  });

  @override
  State<GroupProfileScreen> createState() => _GroupProfileScreenState();
}

class _GroupProfileScreenState extends State<GroupProfileScreen> {
  late final ConversationDetailProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = ConversationDetailProvider();
    _provider.fetchDetail(widget.conversationId);
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  String _title(ConversationDetailProvider provider) {
    final detail = provider.detail;
    if (detail != null) {
      return detail.displayTitle(widget.currentUserId);
    }
    return widget.groupName.isNotEmpty ? widget.groupName : 'Group';
  }

  int _memberCount(ConversationDetailProvider provider) {
    final detail = provider.detail;
    if (detail != null && detail.totalMembers > 0) {
      return detail.totalMembers;
    }
    return 0;
  }

  bool _isSilenced(ConversationDetailProvider provider) =>
      provider.detail?.isSilenced ?? false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<ConversationDetailProvider>(
        builder: (context, provider, _) {
          final title = _title(provider);
          final memberCount = _memberCount(provider);
          final isSilenced = _isSilenced(provider);
          final mutedUntil = provider.detail?.mutedUntil;

          return Scaffold(
            backgroundColor: const Color(0xff030D15),
            body: Column(
              children: [
                SecondaryAppBar(title: 'Group Profile'),
                if (provider.isLoadingDetail && provider.detail == null)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xffE9201D),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 12.h),
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
                            Text(
                              title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xff0A1A2A),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                'Group',
                                style: TextStyle(
                                  color: const Color(0xff8D9CDC),
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            // SizedBox(height: 8.h),
                            // Container(
                            //   padding: EdgeInsets.symmetric(
                            //     horizontal: 10.w,
                            //     vertical: 7.h,
                            //   ),
                            //   decoration: BoxDecoration(
                            //     color: const Color(0xff0A1A2A),
                            //     borderRadius: BorderRadius.circular(30),
                            //   ),
                            //   child: Text(
                            //     provider.detail != null
                            //         ? '$memberCount ${memberCount == 1 ? 'member' : 'members'}'
                            //         : 'Loading members...',
                            //     style: TextStyle(
                            //       color: const Color(0xff5F6CA0),
                            //       fontSize: 14.sp,
                            //     ),
                            //   ),
                            // ),
                            if (isSilenced) ...[
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.notifications_off,
                                    color: const Color(0xffE9201D),
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    provider.detail?.muteStatusLabel() ??
                                        'Notifications muted',
                                    style: TextStyle(
                                      color: const Color(0xffE9201D),
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _mainSection(
                                  title: 'Audio',
                                  icon: Icons.call,
                                  ontap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.audioCallScreen,
                                      arguments: {
                                        'conversationId': widget.conversationId,
                                        'callKind': 'AUDIO',
                                        'autoStart': true,
                                        'callerName': title,
                                      },
                                    );
                                  },
                                ),
                                SizedBox(width: 20.w),
                                _mainSection(
                                  title: 'Video',
                                  icon: Icons.videocam,
                                  ontap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.videoCallScreen,
                                      arguments: {
                                        'conversationId': widget.conversationId,
                                        'callKind': 'VIDEO',
                                        'autoStart': true,
                                      },
                                    );
                                  },
                                ),
                                SizedBox(width: 20.w),
                                _mainSection(
                                  title: isSilenced ? 'Muted' : 'Mute',
                                  icon: isSilenced
                                      ? Icons.notifications_off
                                      : Icons.notifications,
                                  iconColor: isSilenced
                                      ? const Color(0xffE9201D)
                                      : const Color(0xff8D9CDC),
                                  ontap: provider.isUpdatingSilent
                                      ? () {}
                                      : () {
                                          showConversationMuteSheet(
                                            context: context,
                                            provider: provider,
                                            conversationId:
                                                widget.conversationId,
                                            contactName: title,
                                            isSilenced: isSilenced,
                                            mutedUntil: mutedUntil,
                                          );
                                        },
                                ),
                                SizedBox(width: 20.w),
                                _mainSection(
                                  title: 'Add',
                                  icon: Icons.person_add,
                                  ontap: () async {
                                    final added = await Navigator.pushNamed(
                                      context,
                                      RouteNames.addGroupMember,
                                      arguments: {
                                        'conversationId': widget.conversationId,
                                      },
                                    );
                                    if (added == true && mounted) {
                                      _provider.fetchDetail(
                                        widget.conversationId,
                                      );
                                    }
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
                                'Chat info',
                                style: TextStyle(
                                  color: const Color(0xffB2B5B8),
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.seeGroupMemberScreen,
                                  arguments: {
                                    'conversationId': widget.conversationId,
                                    'currentUserId': widget.currentUserId,
                                    'groupName': title,
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.groups,
                                    color: const Color(0xff8D9CDC),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    provider.detail != null
                                        ? 'See members ($memberCount)'
                                        : 'See members',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Action',
                                style: TextStyle(
                                  color: const Color(0xffB2B5B8),
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Column(
                              children: [
                                _action(
                                  title: 'View media & file',
                                  icon: Icons.perm_media_sharp,
                                  onTap: () {
                                    showConversationMediaFilesSheet(
                                      context: context,
                                      conversationId: widget.conversationId,
                                    );
                                  },
                                ),
                                SizedBox(height: 20.h),
                                _action(
                                  title: 'Share contact',
                                  icon: Icons.share,
                                  onTap: () {},
                                ),
                                SizedBox(height: 20.h),
                                _action(
                                  title: 'Report',
                                  icon: Icons.report_problem_outlined,
                                  onTap: () {},
                                ),
                                SizedBox(height: 20.h),
                                _action(
                                  title: 'Delete conversation',
                                  icon: Icons.delete_outline,
                                  onTap: () => _confirmDelete(context),
                                ),
                                SizedBox(height: 20.h),
                                _action(
                                  title: 'Leave group',
                                  icon: Icons.logout,
                                  onTap: () => _confirmLeave(context),
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
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xff152033),
        title: const Text(
          'Delete Conversation',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this conversation?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    final success =
        await _provider.deleteConversation(widget.conversationId);

    if (!context.mounted) return;

    if (success) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _provider.error ?? 'Failed to delete conversation',
          ),
        ),
      );
    }
  }

  Future<void> _confirmLeave(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xff152033),
        title: const Text(
          'Leave Group',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to leave this group?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Leave', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    final success = await _provider.leaveGroup(widget.conversationId);

    if (!context.mounted) return;

    if (success) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_provider.error ?? 'Failed to leave group'),
        ),
      );
    }
  }

  Widget _action({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: (title.contains('Delete') ||
                    title.contains('Leave') ||
                    title.contains('Report'))
                ? Colors.red
                : const Color(0xff8D9CDC),
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
    Color iconColor = const Color(0xff8D9CDC),
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
            child: Icon(icon, color: iconColor, size: 24.sp),
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
