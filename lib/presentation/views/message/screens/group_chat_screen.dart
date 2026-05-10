import 'package:abbas/presentation/views/message/model/dm_all_message_model.dart';
import 'package:abbas/presentation/views/message/provider/group_chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../cors/routes/route_names.dart';

class GroupChatScreen extends StatefulWidget {
  final String conversationId;
  final String token;
  final String currentUserId;
  final String groupName;

  const GroupChatScreen({
    super.key,
    required this.conversationId,
    required this.token,
    required this.currentUserId,
    required this.groupName,
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _didInit = false;
  late GroupChatProvider _groupChatProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _groupChatProvider = context.read<GroupChatProvider>();

    if (_didInit) return;
    _didInit = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupChatProvider>().initGroupChat(
        token: widget.token,
        conversationId: widget.conversationId,
        currentUserId: widget.currentUserId,
      );
    });

    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 80) {
      context.read<GroupChatProvider>().loadMoreMessages();
    }
  }

  String _formatTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateTime).toLocal();
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return '';
    }
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _groupChatProvider.disposeResources();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GroupChatProvider>();

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      appBar: AppBar(
        backgroundColor: const Color(0xff030D15),
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.groupName,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Consumer<GroupChatProvider>(
              builder: (_, provider, __) {
                return Text(
                  provider.isOtherUserTyping ? 'typing...' : 'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: provider.isOtherUserTyping
                        ? Colors.greenAccent
                        : Colors.white70,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              if (widget.conversationId.isNotEmpty) {
                Navigator.pushNamed(
                  context,
                  RouteNames.audioCallScreen,
                  arguments: {
                    'conversationId': widget.conversationId,
                    'callKind': 'AUDIO',
                    'autoStart': true,
                    'callerName': widget.groupName,
                  },
                );
              }
            },
            child: Icon(Icons.call, size: 20.sp, color: const Color(0xffE9201D)),
          ),

          SizedBox(width: 16),
          GestureDetector(
            onTap: () {
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
            child: Icon(
              Icons.videocam_rounded,
              size: 20.sp,
              color: const Color(0xffE9201D),
            ),
          ),

          SizedBox(width: 16.w),

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteNames.groupProfileScreen,
                arguments: {
                  'conversationId': widget.conversationId,
                  'groupName': widget.groupName,
                  'token': widget.token,
                  'currentUserId': widget.currentUserId,
                },
              );
            },
            child: Icon(Icons.info, size: 20.sp, color: Color(0xff8D9CDC)),
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (provider.isOtherUserTyping)
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: const Text(
                  'Someone is typing...',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            Expanded(
              child: provider.isLoading && provider.messages.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : provider.messages.isEmpty
                  ? const Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => provider.loadInitialMessages(),
                      child: ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: EdgeInsets.all(16.w),
                        itemCount:
                            provider.messages.length +
                            (provider.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == provider.messages.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final msg = provider.messages[index];
                          final isSentByMe =
                              (msg.senderId ?? '') == widget.currentUserId;

                          return _buildMessage(
                            message: msg,
                            time: _formatTime(msg.createdAt),
                            isSentByMe: isSentByMe,
                          );
                        },
                      ),
                    ),
            ),
            _messageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage({
    required Items message,
    required String time,
    required bool isSentByMe,
  }) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          mainAxisAlignment: isSentByMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isSentByMe)
              CircleAvatar(
                radius: 16.r,
                backgroundColor: Colors.grey[800],
                child:
                    message.sender?.avatar != null &&
                        message.sender!.avatar!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          message.sender!.avatar!,
                          width: 32.w,
                          height: 32.h,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20.r,
                          ),
                        ),
                      )
                    : Icon(Icons.person, color: Colors.white, size: 20.r),
              ),
            if (!isSentByMe) SizedBox(width: 8.w),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSentByMe
                      ? const Color(0xff4A5D83)
                      : const Color(0xff0A1A2A),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isSentByMe)
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Text(
                          message.sender?.name ?? 'Unknown',
                          style: TextStyle(
                            color: Colors.lightBlue.shade200,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Text(
                      message.content?.text ?? '',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white70,
                          ),
                        ),
                        if (isSentByMe) ...[
                          SizedBox(width: 6.w),
                          Icon(
                            message.status == 'sending'
                                ? Icons.access_time
                                : Icons.done_all,
                            size: 14.sp,
                            color: Colors.white70,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      child: SafeArea(
        child: Row(
          children: [
            // Plus Icon
            Container(
              height: 28.h,
              width: 28.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xff5C6580), width: 1.5),
              ),
              child: const Icon(Icons.add, color: Color(0xff5C6580), size: 20),
            ),
            SizedBox(width: 12.w),
            // Gallery Icon
            const Icon(Icons.image_outlined, color: Color(0xff5C6580), size: 28),
            SizedBox(width: 12.w),
            // Text Field
            Expanded(
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: const Color(0xff152033),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16.w),
                    Expanded(
                      child: TextFormField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        onChanged: (value) {
                          context.read<GroupChatProvider>().updateTyping(
                            value.trim().isNotEmpty,
                          );
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Type message...',
                          hintStyle: TextStyle(color: const Color(0xff5C6580), fontSize: 14.sp),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Icon(Icons.sentiment_satisfied_alt, color: const Color(0xff5C6580), size: 24.sp),
                    SizedBox(width: 12.w),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Mic or Send Icon
            GestureDetector(
              onTap: () {
                final text = _messageController.text.trim();
                if (text.isEmpty) return;

                context.read<GroupChatProvider>().sendTextMessage(text);
                _messageController.clear();
                context.read<GroupChatProvider>().updateTyping(false);
                setState(() {});
                _scrollToBottom();
              },
              child: Icon(
                _messageController.text.trim().isEmpty ? Icons.mic_none : Icons.send,
                color: const Color(0xff5C6580),
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
