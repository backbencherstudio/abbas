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
  String? conversationId; // Changed from late to nullable
  String? receiverName;
  String? receiverAvatar;
  Timer? _typingTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    currentUserId = await UserIdStorage().getUserId();

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      // Get conversationId from route arguments
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args == null || args is! String || args.isEmpty) {
        debugPrint("❌ Invalid or missing conversationId");
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Invalid conversation")));
        }
        return;
      }

      setState(() {
        conversationId = args;
      });

      final provider = context.read<CreateChatProvider>();

      // Clear previous messages to prevent showing messages from other chats
      provider.clearMessages(); // ← You must add this method in your provider

      // Load messages
      await provider.getDmAllMessageRoom(conversationId!);
      _setReceiverInfo(provider);
      // Initialize socket
      final token = await _getJwtToken();
      if (token != null && token.isNotEmpty && mounted) {
        debugPrint(" JWT Token found, connecting to socket...");
        await provider.initializeRealtime(token, conversationId!);
      } else if (mounted) {
        debugPrint(" No JWT token found!");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login expired. Please login again.")),
        );
      }
    });
  }

  Future<String?> _getJwtToken() async {
    try {
      final token = await TokenStorage().getToken();
      if (token != null && token.isNotEmpty) {
        debugPrint("Token retrieved successfully");
      } else {
        debugPrint("Token is null or empty");
      }
      return token;
    } catch (e) {
      debugPrint("Error retrieving token: $e");
      return null;
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
    if (messages.isEmpty) return;

    // Find the first message that is NOT sent by me
    for (var msg in messages) {
      if (msg.senderId != currentUserId && msg.sender != null) {
        setState(() {
          debugPrint("Recever name ${msg.sender?.name}");
          debugPrint("Recever name ${msg.sender!.avatar}");
          receiverName = msg.sender!.name;
          receiverAvatar = msg.sender!.avatar;
        });
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
    _messageController.dispose();
    _scrollController.dispose();

    // Optional: Leave conversation when leaving screen
    if (conversationId != null) {
      context.read<CreateChatProvider>().leaveConversation(conversationId!);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateChatProvider>();

    // Show loading if conversationId not yet loaded
    if (conversationId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Get and sort messages (newest at bottom when reverse: true)
    final messages = (provider.dmAllMessageModel?.items ?? []).toList()
      ..sort((a, b) {
        final aTime = DateTime.tryParse(a.createdAt ?? '') ?? DateTime.now();
        final bTime = DateTime.tryParse(b.createdAt ?? '') ?? DateTime.now();
        return aTime.compareTo(bTime);
      });

    // Auto scroll to bottom when new messages arrive
    if (messages.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }

    return Scaffold(
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
                ? const Center(
                    child: Text(
                      "No messages yet",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: EdgeInsets.all(16.w),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[messages.length - 1 - index];
                      final isSentByMe = msg.senderId == currentUserId;

                      return _buildMessage(
                        text: msg.content?.text ?? "",
                        time: _formatTime(msg.createdAt),
                        isSentByMe: isSentByMe,
                        avatarUrl: msg.sender?.avatar,
                        senderName: msg.sender?.name,
                      );
                    },
                  ),
          ),

          // Input Field
          Padding(
            padding: EdgeInsets.only(bottom: 24.h, left: 6.w, right: 6.w),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _messageController,
                    onChanged: _onTextChanged,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: const TextStyle(color: Colors.white54),
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isSentByMe)
              CircleAvatar(
                radius: 16.r,
                backgroundImage: avatarUrl != null
                    ? NetworkImage(avatarUrl)
                    : null,
                child: avatarUrl == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
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
                    if (!isSentByMe && senderName != null)
                      Text(
                        senderName,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                    Text(
                      text,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      time,
                      style: TextStyle(fontSize: 10.sp, color: Colors.white70),
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
