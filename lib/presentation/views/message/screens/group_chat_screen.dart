import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abbas/presentation/views/message/provider/create_chat_provider.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() =>
      _GroupChatScreenState();
}

class _GroupChatScreenState
    extends State<GroupChatScreen> {

  late String conversationId;

  // 🔥 Replace with your logged-in user id
  final String currentUserId = "YOUR_USER_ID";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    conversationId =
    ModalRoute.of(context)!.settings.arguments as String;

    Future.microtask(() {
      context
          .read<CreateChatProvider>()
          .getDmAllMessageRoom(conversationId);
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider =
    context.watch<CreateChatProvider>();

    final messages =
        provider.dmAllMessageModel?.items ?? [];

    return Scaffold(
      backgroundColor: const Color(0xff030D15),

      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 10),

            const Text(
              "Group Chat",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            /// Messages List
            Expanded(
              child: provider.isLoading
                  ? const Center(
                child:
                CircularProgressIndicator(),
              )
                  : ListView.builder(
                reverse: true,
                padding:
                EdgeInsets.all(16.w),
                itemCount: messages.length,
                itemBuilder:
                    (context, index) {

                  final msg =
                  messages[index];

                  final text =
                      msg.content.text;

                  final time =
                      msg.createdAt;

                  final isSentByMe =
                      msg.senderId ==
                          currentUserId;

                  return _buildMessage(
                    text: text,
                    time: time,
                    isSentByMe:
                    isSentByMe,
                    senderName:
                    msg.sender.name,
                    avatar:
                    msg.sender.avatar,
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

  /// Message Bubble
  Widget _buildMessage({
    required String text,
    required String time,
    required bool isSentByMe,
    required String senderName,
    required String avatar,
  }) {
    return Align(
      alignment: isSentByMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin:
        EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSentByMe
              ? const Color(0xff4A5D83)
              : const Color(0xff0A1A2A),
          borderRadius:
          BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            /// Sender Name (for group)
            if (!isSentByMe)
              Text(
                senderName,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),

            Text(
              text,
              style: const TextStyle(
                  color: Colors.white),
            ),

            const SizedBox(height: 4),

            Text(
              time,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Input Field
  Widget _messageInput() {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [

          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Type message...",
                filled: true,
                fillColor:
                const Color(0xff0A1A2A),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(30),
                  borderSide:
                  BorderSide.none,
                ),
              ),
            ),
          ),

          SizedBox(width: 10.w),

          const Icon(
            Icons.send,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}