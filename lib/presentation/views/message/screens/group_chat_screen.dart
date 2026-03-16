import 'package:abbas/cors/services/user_id_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:abbas/presentation/views/message/provider/create_chat_provider.dart';
import '../../../widgets/chat_appber.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _OneTwoOneChatScreenState();
}

class _OneTwoOneChatScreenState extends State<GroupChatScreen> {
  final UserIdStorage _userIdStorage = UserIdStorage();

  String? currentUserId;
  late String conversationId;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    currentUserId = await _userIdStorage.getUserId();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      conversationId = ModalRoute.of(context)!.settings.arguments as String;

      debugPrint("CurrentUserId: $currentUserId");
      debugPrint("ConversationId: $conversationId");

      context.read<CreateChatProvider>().getDmAllMessageRoom(conversationId);
    });

    setState(() {});
  }

  String _formatTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return "";
    try {
      final dt = DateTime.parse(dateTime);
      return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateChatProvider>();
    final messages = (provider.dmAllMessageModel?.items ?? []).reversed
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: SafeArea(
        child: Column(
          children: [
            const ChatAppBer(title: "Chat", image: ""),
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : messages.isEmpty
                  ? const Center(
                      child: Text(
                        "No messages yet",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.all(16.w),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isSentByMe = msg.senderId == currentUserId;
                        return _buildMessage(
                          text: msg.content?.text ?? "",
                          time: _formatTime(msg.createdAt),
                          isSentByMe: isSentByMe,
                          avatarUrl: msg.sender?.avatar,
                          senderName: msg.sender?.name,
                          isGroup: false,
                        );
                      },
                    ),
            ),
            _messageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage({
    required String text,
    required String time,
    required bool isSentByMe,
    String? avatarUrl,
    String? senderName,
    bool isGroup = false,
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
                child: avatarUrl != null && avatarUrl.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          avatarUrl,
                          height: 32.h,
                          width: 32.w,
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
            SizedBox(width: 8.w),
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
                    if (!isSentByMe && isGroup && senderName != null)
                      Text(
                        senderName,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    Text(text, style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
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

  Widget _messageInput() {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type message...",
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
              if (text.isNotEmpty) {
                _messageController.clear();
              }
            },
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xffE9201D),
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
