import 'dart:async';

import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/message/provider/create_chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../cors/services/token_storage.dart';
import '../../../../cors/services/user_id_storage.dart';
import '../../../widgets/chat_appber.dart';

class OneTwoOneChatScreen extends StatefulWidget {
  const OneTwoOneChatScreen({super.key});

  @override
  State<OneTwoOneChatScreen> createState() => _OneTwoOneChatScreenState();
}

class _OneTwoOneChatScreenState extends State<OneTwoOneChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? currentUserId;
  String? conversationId;
  String? receiverName;
  String? receiverAvatar;

  Timer? _typingTimer;
  bool _isTyping = false;
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients || conversationId == null) return;

    final provider = context.read<CreateChatProvider>();

    if (_scrollController.position.pixels <= 120) {
      provider.getDmAllMessageRoom(conversationId!, isLoadMore: true);
    }
  }

  Future<void> _initialize() async {
    currentUserId = await UserIdStorage().getUserId();
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args == null || args is! String || args.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid conversation")),
        );
        return;
      }

      conversationId = args.trim();
      setState(() {});

      final provider = context.read<CreateChatProvider>();
      provider.clearMessages();

      await provider.getDmAllMessageRoom(conversationId!);
      _setReceiverInfo(provider);

      final token = await TokenStorage().getToken();
      if (token != null && token.isNotEmpty) {
        await provider.initializeRealtime(token, conversationId!);
      }

      _scrollToBottom(jump: true);
    });
  }

  void _scrollToBottom({bool jump = false}) {
    if (!_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      final position = _scrollController.position.maxScrollExtent;

      if (jump) {
        _scrollController.jumpTo(position);
      } else {
        _scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || conversationId == null) return;

    _messageController.clear();

    await context.read<CreateChatProvider>().sendMessageRealtime(
      conversationId: conversationId!,
      kind: "TEXT",
      text: text,
    );

    if (!mounted) return;
    _scrollToBottom();
  }

  void _setReceiverInfo(CreateChatProvider provider) {
    final messages = provider.dmAllMessageModel?.items ?? [];
    for (final msg in messages) {
      if (msg.senderId != currentUserId && msg.sender != null) {
        receiverName = msg.sender!.name;
        receiverAvatar = msg.sender!.avatar;
        break;
      }
    }
  }

  void _onTextChanged(String value) {
    if (conversationId == null) return;

    final isTypingNow = value.trim().isNotEmpty;

    if (isTypingNow != _isTyping) {
      _isTyping = isTypingNow;
      context.read<CreateChatProvider>().sendTyping(conversationId!, _isTyping);
    }

    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      if (_isTyping && mounted) {
        _isTyping = false;
        context.read<CreateChatProvider>().sendTyping(conversationId!, false);
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _messageController.dispose();
    _scrollController.dispose();

    if (conversationId != null) {
      context.read<CreateChatProvider>().leaveConversation(conversationId!);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateChatProvider>();

    if (conversationId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final messages = List.of(provider.dmAllMessageModel?.items ?? []);

    if (messages.length != _lastMessageCount) {
      final oldCount = _lastMessageCount;
      _lastMessageCount = messages.length;

      if (messages.length > oldCount) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    }

    if ((receiverName == null || receiverName!.isEmpty) && messages.isNotEmpty) {
      _setReceiverInfo(provider);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ChatAppBer(
            title: receiverName ?? "Chat",
            image: receiverAvatar ?? "",
            conId: conversationId!,
          ),
          Expanded(
            child: provider.isLoading && messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
                ? const Center(child: Text("No messages yet"))
                : ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              itemCount: messages.length + (provider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0 && provider.hasMore) {
                  return const Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                final adjustedIndex =
                provider.hasMore ? index - 1 : index;

                final msg = messages[adjustedIndex];
                final isMe = msg.senderId == currentUserId;

                return _buildMessage(
                  text: msg.content?.text ?? "",
                  time: _formatTime(msg.createdAt),
                  isSentByMe: isMe,
                  avatarUrl: msg.sender?.avatar,
                  senderName: msg.sender?.name,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.h, left: 6.w, right: 6.w),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _messageController,
                    onChanged: _onTextChanged,
                    onFieldSubmitted: (_) => _sendMessage(),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: const Color(0XFF0A1A29),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: const BoxDecoration(
                      color: Color(0xffE9201D),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return "";
    try {
      final dt = DateTime.parse(dateTime).toLocal();
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final amPm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $amPm';
    } catch (_) {
      return "";
    }
  }

  Widget _buildMessage({
    required String text,
    required String time,
    required bool isSentByMe,
    String? avatarUrl,
    String? senderName,
  }) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          mainAxisAlignment:
          isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isSentByMe)
              CircleAvatar(
                radius: 16.r,
                backgroundImage:
                avatarUrl != null && avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : null,
                child: (avatarUrl == null || avatarUrl.isEmpty)
                    ? const Icon(Icons.person, size: 16)
                    : null,
              ),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: BoxDecoration(
                  color: isSentByMe
                      ? const Color(0xff4A5D83)
                      : const Color(0xff0A1A2A),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: isSentByMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10.sp,
                      ),
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
}
