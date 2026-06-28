import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../cors/routes/route_names.dart';
import '../model/dm_all_message_model.dart';
import '../provider/real_time_message_provider.dart';

class OneToOneChatScreen extends StatefulWidget {
  final String conversationId;
  final String receiverName;
  final String myUserId;
  final String token;
  final String? avatarUrl;

  const OneToOneChatScreen({
    super.key,
    required this.conversationId,
    required this.receiverName,
    required this.myUserId,
    required this.token,
    this.avatarUrl,
  });

  @override
  State<OneToOneChatScreen> createState() => _OneToOneChatScreenState();
}

class _OneToOneChatScreenState extends State<OneToOneChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late RealTimeMessageProvider _chatProvider;
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chatProvider = context.read<RealTimeMessageProvider>();
    
    if (_didInit) return;
    _didInit = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _chatProvider.initChat(
        widget.token,
        widget.conversationId,
        widget.myUserId,
      );
    });

    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 80) {
      context.read<RealTimeMessageProvider>().loadMoreMessages();
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
    _controller.dispose();
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _chatProvider.disposeResources();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              widget.receiverName,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Consumer<RealTimeMessageProvider>(
              builder: (_, provider, __) {
                if (!provider.isOtherUserTyping) {
                  return const SizedBox.shrink();
                }
                return Text(
                  'typing...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.greenAccent,
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
                  arguments: {
                    'conversationId': widget.conversationId,
                    'callKind': 'AUDIO',
                    'autoStart': true,
                    'callerName': widget.receiverName,
                  },
                );

              } else {
                debugPrint("The conv id not found");
              }
            },
            child: Icon(Icons.call, size: 20.sp, color: const Color(0xffE9201D)),
          ),

          SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              if (widget.conversationId.isNotEmpty) {
                debugPrint("The conId ${widget.conversationId}");
                Navigator.pushNamed(
                  context,
                  RouteNames.videoCallScreen,
                  arguments: {
                    'conversationId': widget.conversationId,
                    'callKind': 'VIDEO',
                    'autoStart': true,
                  },
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

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteNames.userProfileScreen,
                arguments: {
                  'conversationId': widget.conversationId,
                  'receiverName': widget.receiverName,
                  'avatarUrl': widget.avatarUrl ?? '',
                },
              );
            },
            child: Icon(Icons.info, size: 20.sp, color: const Color(0xff8D9CDC)),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<RealTimeMessageProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.messages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.loadInitialMessages(),
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 15,
                    ),
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
                      final isMe = (msg.senderId ?? '') == widget.myUserId;
                      return _buildChatBubble(msg, isMe);
                    },
                  ),
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Items msg, bool isMe) {
    String time = '';
    if (msg.createdAt != null) {
      try {
        final dt = DateTime.parse(msg.createdAt!).toLocal();
        time = DateFormat('hh:mm a').format(dt);
      } catch (_) {}
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xff4A5D83) : const Color(0xff0A1A2A),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: isMe
                ? const Radius.circular(18)
                : const Radius.circular(4),
            bottomRight: isMe
                ? const Radius.circular(4)
                : const Radius.circular(18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              msg.content?.text ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
                if (isMe) ...[
                  const SizedBox(width: 6),
                  Icon(
                    msg.status == 'sending'
                        ? Icons.access_time
                        : Icons.done_all,
                    size: 14,
                    color: Colors.white70,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff030D15),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
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
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (val) {
                          context.read<RealTimeMessageProvider>().updateTyping(
                            val.trim().isNotEmpty,
                          );
                          setState(() {}); // to toggle mic/send icon
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
                final text = _controller.text.trim();
                if (text.isEmpty) return;

                context.read<RealTimeMessageProvider>().sendTextMessage(text);
                _controller.clear();
                context.read<RealTimeMessageProvider>().updateTyping(false);
                setState(() {});
                _scrollToBottom();
              },
              child: Icon(
                _controller.text.trim().isEmpty ? Icons.mic_none : Icons.send,
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
