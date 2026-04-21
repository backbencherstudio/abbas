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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

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
    context.read<GroupChatProvider>().disposeResources();
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
                debugPrint("The conId ${widget.conversationId}");
                Navigator.pushNamed(
                  context,
                  RouteNames.audioCallScreen,
                  arguments: widget.conversationId,
                );
              } else {
                debugPrint("The conv id not found");
              }
            },
            child: Icon(
              Icons.call,
              size: 20.sp,
              color: const Color(0xffE9201D),
            ),
          ),

          SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              if (widget.conversationId.isNotEmpty) {
                debugPrint("The conId ${widget.conversationId}");
                Navigator.pushNamed(
                  context,
                  RouteNames.videoCallScreen,
                  arguments: widget.conversationId,
                );
              } else {
                debugPrint("The conv id not found");
              }
            },
            child: Icon(
              Icons.videocam_rounded,
              size: 20.sp,
              color: const Color(0xffE9201D),
            ),
          ),

          SizedBox(width: 16.w),

          Icon(Icons.info, size: 20.sp, color: Color(0xff8D9CDC)),
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
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                context.read<GroupChatProvider>().updateTyping(
                  value.trim().isNotEmpty,
                );
              },
              decoration: InputDecoration(
                hintText: 'Type message...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xff0A1A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: () {
              final text = _messageController.text.trim();
              if (text.isEmpty) return;

              context.read<GroupChatProvider>().sendTextMessage(text);
              _messageController.clear();
              context.read<GroupChatProvider>().updateTyping(false);
              _scrollToBottom();
            },
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: const BoxDecoration(
                color: Color(0xffE9201D),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
