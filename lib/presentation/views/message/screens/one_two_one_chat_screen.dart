import 'dart:async';
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

  @override
  void initState() {
    super.initState();
    _initialize();
    _scrollController.addListener(_onScroll);
  }

  ///  Load more when scroll to top (for pagination)
  void _onScroll() {
    if (!_scrollController.hasClients || conversationId == null) return;

    final provider = context.read<CreateChatProvider>();

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (!provider.isLoading && provider.hasMore) {
        provider.getDmAllMessageRoom(conversationId!, isLoadMore: true);
      }
    }
  }

  Future<void> _initialize() async {
    currentUserId = await UserIdStorage().getUserId();

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args == null || args is! String || args.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Invalid conversation")));
        return;
      }

      setState(() {
        conversationId = args;
      });

      final provider = context.read<CreateChatProvider>();

      provider.clearMessages();

      // First load messages
      await provider.getDmAllMessageRoom(conversationId!);

      _setReceiverInfo(provider);

      // Initialize Socket
      final token = await TokenStorage().getToken();
      if (token != null && token.isNotEmpty) {
        await provider.initializeRealtime(token, conversationId!);
      }
    });
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || conversationId == null) return;

    context.read<CreateChatProvider>().sendMessageRealtime(
      conversationId: conversationId!,
      kind: "TEXT",
      text: text,
    );

    _messageController.clear();
  }

  void _setReceiverInfo(CreateChatProvider provider) {
    final messages = provider.dmAllMessageModel?.items ?? [];
    for (var msg in messages) {
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
    _scrollController.removeListener(_onScroll);
    _typingTimer?.cancel();
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Sort messages by time (oldest to newest)
    final messages = (provider.dmAllMessageModel?.items ?? []).toList()
      ..sort((a, b) {
        final aTime = DateTime.tryParse(a.createdAt ?? '') ?? DateTime.now();
        final bTime = DateTime.tryParse(b.createdAt ?? '') ?? DateTime.now();
        return aTime.compareTo(bTime);
      });

    // Auto scroll to bottom whenever messages update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return Scaffold(
      body: Column(
        children: [
          // AppBar
          ChatAppBer(
            title: receiverName ?? "Chat",
            image: receiverAvatar ?? "",
            conId: conversationId!,
          ),

          // Messages List
          Expanded(
            child: provider.isLoading && messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
                ? const Center(child: Text("No messages yet"))
                : ListView.builder(
                    controller: _scrollController,
                    reverse: false,
                    padding: EdgeInsets.all(16.w),
                    itemCount: messages.length + (provider.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length) {
                        return const Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }

                      final msg = messages[index];
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
          // Message Input
          Padding(
            padding: EdgeInsets.only(bottom: 24.h, left: 6.w, right: 6.w),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _messageController,
                    onChanged: _onTextChanged,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
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
      return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
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
          mainAxisAlignment: isSentByMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!isSentByMe)
              CircleAvatar(
                radius: 16.r,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl)
                    : null,
              ),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: BoxDecoration(
                  color: isSentByMe ? Color(0xff4A5D83) : Color(0xff0A1A2A),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(text, style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
