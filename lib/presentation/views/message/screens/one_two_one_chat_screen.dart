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

  const OneToOneChatScreen({
    super.key,
    required this.conversationId,
    required this.receiverName,
    required this.myUserId,
    required this.token,
  });

  @override
  State<OneToOneChatScreen> createState() => _OneToOneChatScreenState();
}

class _OneToOneChatScreenState extends State<OneToOneChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<RealTimeMessageProvider>().initChat(
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
    context.read<RealTimeMessageProvider>().disposeResources();
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
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                style: const TextStyle(color: Colors.white),
                textCapitalization: TextCapitalization.sentences,
                onChanged: (val) {
                  context.read<RealTimeMessageProvider>().updateTyping(
                    val.trim().isNotEmpty,
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xff0A1A2A),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: const Color(0xffE9201D),
              radius: 24,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 24),
                onPressed: () {
                  final text = _controller.text.trim();
                  if (text.isEmpty) return;

                  context.read<RealTimeMessageProvider>().sendTextMessage(text);
                  _controller.clear();
                  context.read<RealTimeMessageProvider>().updateTyping(false);
                  _scrollToBottom();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
