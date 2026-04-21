import 'package:abbas/cors/services/user_id_storage.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../cors/routes/route_names.dart';
import '../../../../cors/services/token_storage.dart';
import '../../../widgets/custom_appbar.dart';
import '../model/all_conversation_model.dart';
import '../provider/create_chat_provider.dart';

class MessageScreens extends StatefulWidget {
  const MessageScreens({super.key});

  @override
  State<MessageScreens> createState() => _MessageScreensState();
}

class _MessageScreensState extends State<MessageScreens> {
  String? _currentUserId;
  String? _token;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadUserAndConversations();
  }

  Future<void> _loadUserAndConversations() async {
    _currentUserId = await UserIdStorage().getUserId();
    _token = await TokenStorage().getToken();

    if (!mounted) return;

    await context.read<CreateChatProvider>().getAllConversation();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateChatProvider>();
    final allConversations = provider.allConversationModel;

    final filteredData = allConversations.where((conv) {
      final type = (conv.type ?? '').toUpperCase();
      final selectedFilter = provider.selectedFilter;

      if (selectedFilter == 'Group' && type != 'GROUP') return false;
      if (selectedFilter == 'DM' && type != 'DM') return false;

      final displayName = _getDisplayName(conv);
      final lastMsg = _getLastMessage(conv);

      final keyword = _searchText.trim().toLowerCase();
      if (keyword.isEmpty) return true;

      return displayName.toLowerCase().contains(keyword) ||
          lastMsg.toLowerCase().contains(keyword);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: SafeArea(
        child: Column(
          children: [
            CustomAppbar(
              title: "Message",
              image: "assets/icons/edit.png",
              onTap: () =>
                  Navigator.pushNamed(context, RouteNames.addGroupMember),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  fillColor: const Color(0xff030D15),
                  hintText: "Search message...",
                  hintStyle: TextStyle(
                    color: const Color(0xff3D4566),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.r),
                    borderSide: const BorderSide(color: Color(0xff3D4566)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.r),
                    borderSide: const BorderSide(color: Color(0xff3D4566)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100.r),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),

            SizedBox(height: 6.h),

            SizedBox(
              height: 40.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                children: ['All', 'Group', 'DM'].map((filter) {
                  final isSelected = provider.selectedFilter == filter;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: GestureDetector(
                      onTap: () => provider.toggleFilter(filter),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xff1F283D),
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(50.r),
                          color: isSelected
                              ? const Color(0xffE9201D)
                              : Colors.transparent,
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 24.h),

            Expanded(
              child: provider.isLoading
                  ? AnimatedLoading()
                  : filteredData.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.message, color: Colors.white70, size: 50.sp),
                        SizedBox(height: 16.h),
                        Text(
                          "No conversations found",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white70,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                  : RefreshIndicator(
                      onRefresh: provider.getAllConversation,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          final conv = filteredData[index];
                          final isGroup =
                              (conv.type ?? '').toUpperCase() == "GROUP";

                          final displayName = _getDisplayName(conv);
                          final lastMsg = _getLastMessage(conv);
                          final time = _getLastMessageTime(conv);
                          final avatarUrl = isGroup
                              ? null
                              : (conv.otherUserAvatar ?? '');

                          return GestureDetector(
                            onTap: () {
                              if (conv.id == null || _token == null || _currentUserId == null) return;

                              final displayName = _getDisplayName(conv);

                              Navigator.pushNamed(
                                context,
                                isGroup
                                    ? RouteNames.groupChatScreen
                                    : RouteNames.oneTwoOneChatScreen,
                                arguments: {
                                  "conversationId": conv.id!,
                                  "token": _token!,
                                  "currentUserId": _currentUserId!,
                                  "receiverName": displayName,
                                  "groupName": displayName,
                                },
                              );
                            },

                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 12.h,
                                horizontal: 16.w,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 48.h,
                                        width: 48.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff1F283D),
                                        ),
                                        child: avatarUrl != null
                                            ? ClipOval(
                                                child: Image.network(
                                                  avatarUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      Icon(
                                                        Icons.person,
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              )
                                            : Icon(
                                                Icons.person,
                                                color: Colors.white,
                                              ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              displayName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              lastMsg,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Color(0xff8C9196),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        time,
                                        style: const TextStyle(
                                          color: Color(0xff8C9196),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  const Divider(
                                    color: Color(0xff121D2D),
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDisplayName(AllConversationModel conv) {
    final isGroup = (conv.type ?? '').toUpperCase() == 'GROUP';

    if (isGroup) {
      return (conv.title ?? '').trim().isNotEmpty
          ? conv.title!.trim()
          : 'Group';
    }

    if (_currentUserId != null && conv.creatorId == _currentUserId) {
      final name = conv.receiverTitle?.trim() ?? '';
      return name.isNotEmpty ? name : 'Direct Message';
    }

    final name = conv.senderTitle?.trim() ?? '';
    return name.isNotEmpty ? name : 'Direct Message';
  }

  String _getLastMessage(AllConversationModel conv) {
    final messages = conv.messages ?? [];
    if (messages.isEmpty) return 'No messages yet';

    final last = messages.last;
    final text = last.content?.text?.trim() ?? '';
    return text.isNotEmpty ? text : 'Attachment';
  }

  String _getLastMessageTime(AllConversationModel conv) {
    final messages = conv.messages ?? [];
    if (messages.isEmpty) return '';

    final createdAt = messages.last.createdAt;
    if (createdAt == null || createdAt.isEmpty) return '';

    final dt = DateTime.tryParse(createdAt)?.toLocal();
    if (dt == null) return '';

    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }
}
