import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../cors/routes/route_names.dart';
import '../../../widgets/secondary_appber.dart';
import '../provider/conversation_detail_provider.dart';
import '../widgets/conversation_mute_sheet.dart';
import '../widgets/conversation_media_files_sheet.dart';

class UserProfileScreen extends StatefulWidget {
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
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late final ConversationDetailProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = ConversationDetailProvider();
    if (widget.conversationId.isNotEmpty) {
      _provider.fetchDetail(widget.conversationId);
    }
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  String _displayName(ConversationDetailProvider provider) {
    final detail = provider.detail;
    if (detail != null) {
      return detail.displayTitle(null);
    }
    return widget.receiverName;
  }

  String? _displayAvatar(ConversationDetailProvider provider) {
    final detail = provider.detail;
    if (detail != null) {
      return detail.displayAvatar();
    }
    return widget.avatarUrl.isNotEmpty ? widget.avatarUrl : null;
  }

  bool _isSilenced(ConversationDetailProvider provider) =>
      provider.detail?.isSilenced ?? false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<ConversationDetailProvider>(
        builder: (context, provider, _) {
          final name = _displayName(provider);
          final avatarUrl = _displayAvatar(provider);
          final isSilenced = _isSilenced(provider);
          final mutedUntil = provider.detail?.mutedUntil;

          return Scaffold(
            backgroundColor: const Color(0xff030D15),
            body: Column(
              children: [
                SecondaryAppBar(title: 'Profile'),
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
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          SizedBox(height: 12.h),
                          Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: const BoxDecoration(
                              color: Color(0xff1F283D),
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: avatarUrl != null && avatarUrl.isNotEmpty
                                ? Image.network(
                                    avatarUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 50,
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
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (provider.detail?.participant?.username != null &&
                              provider.detail!.participant!.username!
                                  .isNotEmpty) ...[
                            SizedBox(height: 4.h),
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
                                '@${provider.detail!.participant!.username}',
                                style: TextStyle(
                                  color: const Color(0xff8D9CDC),
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
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
                                  if (widget.conversationId.isNotEmpty) {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.audioCallScreen,
                                      arguments: {
                                        'conversationId': widget.conversationId,
                                        'callKind': 'AUDIO',
                                        'autoStart': true,
                                        'callerName': name,
                                      },
                                    );
                                  }
                                },
                              ),
                              SizedBox(width: 20.w),
                              _mainSection(
                                title: 'Video',
                                icon: Icons.videocam,
                                ontap: () {
                                  if (widget.conversationId.isNotEmpty) {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.videoCallScreen,
                                      arguments: {
                                        'conversationId': widget.conversationId,
                                        'callKind': 'VIDEO',
                                        'autoStart': true,
                                      },
                                    );
                                  }
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
                                          conversationId: widget.conversationId,
                                          contactName: name,
                                          isSilenced: isSilenced,
                                          mutedUntil: mutedUntil,
                                        );
                                      },
                              ),
                              SizedBox(width: 20.w),
                              _mainSection(
                                title: 'Profile',
                                icon: Icons.person,
                                ontap: () {},
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          const Divider(thickness: 0.7),
                          SizedBox(height: 12.h),
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
                          SizedBox(height: 20.h),
                          _action(
                            title: 'View media & file',
                            icon: Icons.perm_media_sharp,
                            onTap: () {
                              if (widget.conversationId.isNotEmpty) {
                                showConversationMediaFilesSheet(
                                  context: context,
                                  conversationId: widget.conversationId,
                                );
                              }
                            },
                          ),
                          SizedBox(height: 20.h),
                          _action(title: 'Share contact', icon: Icons.share),
                          SizedBox(height: 20.h),
                          _action(
                            title: 'Report',
                            icon: Icons.report_problem_outlined,
                          ),
                          SizedBox(height: 30.h),
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

  Widget _action({
    required String title,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, color: const Color(0xff8D9CDC), size: 20.sp),
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
