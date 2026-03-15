import 'package:abbas/presentation/views/message/provider/create_chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../widgets/chat_appber.dart';

class OneTwoOneChatScreen extends StatelessWidget {
  const OneTwoOneChatScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final createChatProvider = context.watch<CreateChatProvider>();
    final receiverName =
        createChatProvider.createConversationModel?.receiverTitle ?? "N/A";
    final receiverAvatar =
        createChatProvider.createConversationModel?.avatarUrl ?? "N/A";
    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: Column(
        children: [
          ChatAppBer(title: receiverName, image: receiverAvatar),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff5F6CA0)),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Color(0xff5F6CA0)),
                ),
                SizedBox(width: 12.w),
                const Icon(Icons.file_copy_outlined, color: Color(0xff5F6CA0)),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(48),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(48),
                      ),
                      filled: true,
                      fillColor: const Color(0xff0A1A2A),
                      hintText: "Type message ...",
                      hintStyle: const TextStyle(color: Color(0xff8C9196)),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                const Icon(
                  Icons.keyboard_voice_outlined,
                  color: Color(0xff5F6CA0),
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
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: isSentByMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSentByMe) const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSentByMe
                    ? const Color(0xff4A5D83)
                    : const Color(0xff0A1A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(text, style: const TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            time,
            style: const TextStyle(color: Color(0xff8C9196), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
