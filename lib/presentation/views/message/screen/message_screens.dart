import 'dart:async';

import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/message/model/conversation_model.dart';
import 'package:abbas/presentation/views/message/provider/conversations_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:abbas/presentation/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MessageScreens extends ConsumerStatefulWidget {
  const MessageScreens({super.key});

  @override
  ConsumerState<MessageScreens> createState() => _MessageScreensState();
}

class _MessageScreensState extends ConsumerState<MessageScreens> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(conversationsProvider.notifier).connectSocket();
      _currentUserId =
          await ref.read(conversationsProvider.notifier).ensureCurrentUserId();
      await ref.read(conversationsProvider.notifier).loadInitial();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(conversationsProvider.notifier).search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(conversationsProvider);
    final userId = _currentUserId ?? state.currentUserId;

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: Column(
        children: [
          CustomAppbar(
            title: 'Message',
            showNotificationIcon: true,
            image: 'assets/icons/edit.png',
            onTap: () =>
                Navigator.pushNamed(context, RouteNames.newMessageScreens),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                prefixIcon: Icon(Icons.search, color: Colors.white, size: 24.sp),
                fillColor: Colors.transparent,
                hintText: 'Search messages...',
                hintStyle: TextStyle(
                  color: const Color(0xff5C6580),
                  fontSize: 16.sp,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  borderSide: const BorderSide(color: Color(0xff1F283D)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  borderSide: const BorderSide(color: Color(0xff1F283D)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.r),
                  borderSide: const BorderSide(color: Color(0xff3D4566)),
                ),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          _FilterChips(
            selected: state.filter,
            onSelected: (f) =>
                ref.read(conversationsProvider.notifier).setFilter(f),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: _buildBody(state, userId),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ConversationsState state, String? userId) {
    if (state.isInitialLoading && state.conversations.isEmpty) {
      return const Center(child: AnimatedLoading());
    }

    if (state.error != null && state.conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.error!, style: const TextStyle(color: Colors.white70)),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () =>
                  ref.read(conversationsProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.conversations.isEmpty) {
      return Center(
        child: Text(
          'No conversations found',
          style: TextStyle(color: Colors.white70, fontSize: 16.sp),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(conversationsProvider.notifier).refresh(),
      color: AppColors.activeButtonColor,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels >=
              notification.metrics.maxScrollExtent - 200) {
            ref.read(conversationsProvider.notifier).loadMore();
          }
          return false;
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: state.conversations.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= state.conversations.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.activeButtonColor,
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            final conv = state.conversations[index];
            return _ConversationTile(
              conversation: conv,
              userId: userId,
              onTap: () => _openChat(conv),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openChat(ConversationItem conv) async {
    if (conv.id.isEmpty) return;

    var userId = _currentUserId ?? ref.read(conversationsProvider).currentUserId;
    if (userId == null || userId.isEmpty) {
      userId =
          await ref.read(conversationsProvider.notifier).ensureCurrentUserId();
      _currentUserId = userId;
    }

    if (!mounted) return;
    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open chat — user not loaded')),
      );
      return;
    }

    await Navigator.pushNamed(
      context,
      RouteNames.chatScreen,
      arguments: {
        'conversationId': conv.id,
        'type': conv.type.apiValue,
        'title': conv.displayTitle(userId),
        'avatarUrl': conv.displayAvatar(userId) ?? '',
        'currentUserId': userId,
      },
    );
  }
}

class _FilterChips extends StatelessWidget {
  final ConversationFilter selected;
  final ValueChanged<ConversationFilter> onSelected;

  const _FilterChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    const filters = [
      (ConversationFilter.all, 'All'),
      (ConversationFilter.groups, 'Groups'),
      (ConversationFilter.dm, 'DM'),
    ];

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final (filter, label) = filters[index];
          final isSelected = selected == filter;
          return GestureDetector(
            onTap: () => onSelected(filter),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff1F283D)),
                borderRadius: BorderRadius.circular(50.r),
                color: isSelected
                    ? const Color(0xffE9201D)
                    : Colors.transparent,
              ),
              child: Text(
                label,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationItem conversation;
  final String? userId;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.userId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatarUrl = conversation.displayAvatar(userId);
    final title = conversation.displayTitle(userId);
    final preview = conversation.lastMessage?.previewText() ?? 'No messages yet';
    final time = _formatTime(conversation.lastMessage?.createdAt);
    final unread = conversation.unreadMessages;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            Row(
              children: [
                _Avatar(
                  url: avatarUrl,
                  isGroup: conversation.type.isGroup,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xff8C9196),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        color: const Color(0xff8C9196),
                        fontSize: 12.sp,
                      ),
                    ),
                    if (unread > 0) ...[
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffE9201D),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          unread > 99 ? '99+' : '$unread',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            const Divider(color: Color(0xff121D2D), height: 1),
          ],
        ),
      ),
    );
  }

  String _formatTime(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return '';

    final now = DateTime.now();
    if (dt.year == now.year &&
        dt.month == now.month &&
        dt.day == now.day) {
      return DateFormat('h:mm a').format(dt);
    }
    if (now.difference(dt).inDays == 1) return 'Yesterday';
    return DateFormat('MMM d').format(dt);
  }
}

class _Avatar extends StatelessWidget {
  final String? url;
  final bool isGroup;

  const _Avatar({this.url, required this.isGroup});

  @override
  Widget build(BuildContext context) {
    final hasUrl = url != null && url!.isNotEmpty;
    return Container(
      height: 48.r,
      width: 48.r,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xff1F283D),
      ),
      child: ClipOval(
        child: hasUrl
            ? Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(),
              )
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Icon(
      isGroup ? Icons.groups_outlined : Icons.person,
      color: Colors.white,
      size: 24.sp,
    );
  }
}
