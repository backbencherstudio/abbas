import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../cors/routes/route_names.dart';
import '../../../../cors/services/user_id_storage.dart';
import '../../../widgets/secondary_appber.dart';
import '../model/suggest_model.dart';
import '../provider/create_chat_provider.dart';
import '../provider/create_group_provider.dart';

class NewMessageScreens extends StatefulWidget {
  const NewMessageScreens({super.key});

  @override
  State<NewMessageScreens> createState() => _NewMessageScreensState();
}

class _NewMessageScreensState extends State<NewMessageScreens> {
  final TextEditingController _searchController = TextEditingController();
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateGroupProvider>().loadSuggestedUsers();
      _loadCurrentUserId();
    });
  }

  Future<void> _loadCurrentUserId() async {
    _currentUserId = await UserIdStorage().getUserId();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _startDm(BuildContext context, Items user) async {
    if (user.id.isEmpty) return;

    final chatProvider = context.read<CreateChatProvider>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final conv = await chatProvider.createConversation(user.id);
    if (!mounted) return;

    if (conv != null && conv.id.isNotEmpty) {
      await navigator.pushNamed(
        RouteNames.chatScreen,
        arguments: {
          'conversationId': conv.id,
          'type': 'DM',
          'title': user.name,
          'avatarUrl': user.avatarUrl ?? '',
          'currentUserId': _currentUserId ?? '',
        },
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(chatProvider.errorMessage ?? 'Failed to start chat'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff060C11),
      body: Column(
        children: [
          const SecondaryAppBar(title: 'New message'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),
                  _SearchField(
                    controller: _searchController,
                    onChanged: (value) {
                      context.read<CreateGroupProvider>().searchUsers(value);
                    },
                    onClear: () {
                      _searchController.clear();
                      context.read<CreateGroupProvider>().clearSearch();
                    },
                  ),
                  SizedBox(height: 8.h),
                  _GroupChatTile(
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.addGroupMember),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Suggested',
                    style: TextStyle(
                      color: const Color(0xffB2B5B8),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: Consumer2<CreateGroupProvider, CreateChatProvider>(
                      builder: (context, discover, chat, _) {
                        if (discover.isLoading && discover.users.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xffE9201D),
                            ),
                          );
                        }

                        if (discover.errorMessage != null &&
                            discover.users.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  discover.errorMessage!,
                                  style: const TextStyle(color: Colors.white70),
                                  textAlign: TextAlign.center,
                                ),
                                TextButton(
                                  onPressed: discover.loadSuggestedUsers,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }

                        if (discover.users.isEmpty) {
                          return Center(
                            child: Text(
                              _searchController.text.trim().isEmpty
                                  ? 'No suggested users'
                                  : 'No users found',
                              style: const TextStyle(color: Color(0xff8C9196)),
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: discover.users.length,
                          separatorBuilder: (_, __) => SizedBox(height: 4.h),
                          itemBuilder: (context, index) {
                            final user = discover.users[index];
                            final isCreating =
                                chat.creatingParticipantId == user.id;
                            return _UserTile(
                              user: user,
                              isLoading: isCreating,
                              onTap: isCreating
                                  ? null
                                  : () => _startDm(context, user),
                            );
                          },
                        );
                      },
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

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
        hintText: 'To: Type a name or group',
        hintStyle: const TextStyle(color: Color(0xff5C6580)),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 4.w, right: 8.w),
          child: Text(
            'To:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 36.w),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Color(0xff5C6580)),
                onPressed: onClear,
              )
            : null,
        border: InputBorder.none,
      ),
    );
  }
}

class _GroupChatTile extends StatelessWidget {
  final VoidCallback onTap;

  const _GroupChatTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff1F283D),
              ),
              child: Icon(Icons.groups_outlined, color: Colors.white, size: 22.sp),
            ),
            SizedBox(width: 14.w),
            Text(
              'Group chat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final Items user;
  final bool isLoading;
  final VoidCallback? onTap;

  const _UserTile({
    required this.user,
    required this.isLoading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasAvatar = user.avatarUrl != null && user.avatarUrl!.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: const Color(0xff1F283D),
              backgroundImage: hasAvatar ? NetworkImage(user.avatarUrl!) : null,
              child: hasAvatar
                  ? null
                  : Icon(Icons.person, color: Colors.white, size: 22.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (user.username != null && user.username!.isNotEmpty)
                    Text(
                      '@${user.username}',
                      style: TextStyle(
                        color: const Color(0xff8C9196),
                        fontSize: 13.sp,
                      ),
                    ),
                ],
              ),
            ),
            if (isLoading)
              SizedBox(
                width: 20.r,
                height: 20.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xffE9201D),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
