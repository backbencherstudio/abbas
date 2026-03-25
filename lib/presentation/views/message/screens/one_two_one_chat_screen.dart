import 'package:abbas/cors/services/user_id_storage.dart';
import 'package:camera/camera.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:abbas/presentation/views/message/provider/create_chat_provider.dart';
import '../../../widgets/chat_appber.dart';



class OneTwoOneChatScreen extends StatefulWidget {
  const OneTwoOneChatScreen({super.key});

  @override
  State<OneTwoOneChatScreen> createState() => _OneTwoOneChatScreenState();
}

class _OneTwoOneChatScreenState extends State<OneTwoOneChatScreen> {
  final UserIdStorage _userIdStorage = UserIdStorage();

  String? currentUserId;
  late String conversationId;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  /// ---------------- Format Time --------------------------------------------
  String _formatTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return "";
    try {
      final dt = DateTime.parse(dateTime);

      final localDt = dt.toLocal();
      return "${localDt.hour.toString().padLeft(2, '0')}:${localDt.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateTime;
    }
  }

  /// --------------- Auto-scroll to bottom when new message arrives -----------
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool _showEmoji = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateChatProvider>();

    ///----------- Get messages and sort them chronologically (oldest first) ---
    final messages = (provider.dmAllMessageModel?.items ?? []).toList()
      ..sort((a, b) {
        final aDate = DateTime.tryParse(a.createdAt ?? '');
        final bDate = DateTime.tryParse(b.createdAt ?? '');
        if (aDate == null || bDate == null) return 0;
        return aDate.compareTo(bDate);
      });

    ///  Scroll to bottom when messages change
    if (messages.isNotEmpty) {
      _scrollToBottom();
    }

    return Scaffold(
      // backgroundColor: const Color(0xff030D15),
      body: Column(
        children: [
          ChatAppBer(title: "Chat", image: "", conId: conversationId),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
                ? Center(
              child: Text(
                "No messages yet",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                ),
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
                  isGroup: false,
                );
              },
            ),
          ),

          /// -------------- Create Input Card ---------------------------------
          Padding(
            padding: EdgeInsets.only(bottom: 24.h, right: 6.w),
            child: Column(
              children: [
                Row(
                  children: [
                    // Replace IconButton with PopupMenuButton for the add button
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        // Handle menu item selection
                        switch (value) {
                          case 'file':
                          // Handle file selection
                            debugPrint('File selected');
                            break;
                          case 'contact':
                          // Handle contact selection
                            debugPrint('Contact selected');
                            break;
                          case 'location':
                          // Handle location selection
                            debugPrint('Location selected');
                            break;
                        }
                      },
                      icon: Icon(
                        Icons.add_circle_outline_rounded,
                        color: const Color(0xFF3D4566),
                        size: 24.sp,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'file',
                          child: Row(
                            children: [
                              Icon(
                                Icons.attach_file,
                                color: const Color(0xFF3D4566),
                                size: 20.sp,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'File',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'contact',
                          child: Row(
                            children: [
                              Icon(
                                Icons.contact_phone,
                                color: const Color(0xFF3D4566),
                                size: 20.sp,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Contact',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'location',
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: const Color(0xFF3D4566),
                                size: 20.sp,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Location',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      // Optional: Customize the menu appearance
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      color: const Color(0xFF0A1A29),
                      elevation: 8,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        color: const Color(0xFF3D4566),
                        size: 24.sp,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.image,
                        color: const Color(0xFF3D4566),
                        size: 24.sp,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.mic,
                        color: const Color(0xFF3D4566),
                        size: 24.sp,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: "Message",
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: const Color(0XFF0A1A29),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showEmoji = !_showEmoji;
                              });
                            },
                            icon: Icon(
                              Icons.emoji_emotions,
                              color: const Color(0xFF3D4566),
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () async {
                        final text = _messageController.text.trim();
                        if (text.isNotEmpty) {
                          // Clear input immediately for better UX
                          _messageController.clear();

                          // Send message
                          await context.read<CreateChatProvider>().dmSendMessage(
                            kind: "TEXT",
                            text: text,
                            conversationId: conversationId,
                          );

                          // Refresh messages after sending
                          context.read<CreateChatProvider>().getDmAllMessageRoom(
                            conversationId,
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: const Color(0xffE9201D),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                // Show emoji picker below the input row
                if (_showEmoji)
                  SizedBox(
                    height: 250.h,
                    child: _emojiSelect(),
                  ),
              ],
            ),
          ),
        ],
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
              Container(
                margin: EdgeInsets.only(right: 8.w),
                child: CircleAvatar(
                  radius: 16.r,
                  backgroundColor: Colors.grey[800],
                  child: avatarUrl != null && avatarUrl.isNotEmpty
                      ? ClipOval(
                    child: Image.network(
                      avatarUrl,
                      height: 32.h,
                      width: 32.w,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20.r,
                      ),
                    ),
                  )
                      : Icon(Icons.person, color: Colors.white, size: 20.r),
                ),
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
                    if (!isSentByMe && isGroup && senderName != null)
                      Text(
                        senderName,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                    Text(
                      text,
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
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

  Widget _emojiSelect() {
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {
        setState(() {
          _messageController.text += emoji.emoji;
        });
      },
      config: Config(height: 256.h),
    );
  }


}