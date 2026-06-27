import 'package:abbas/presentation/views/message/model/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageReplyPreview extends StatelessWidget {
  final MessageReply reply;
  final bool isMe;
  final bool compact;
  final bool fillWidth;

  const MessageReplyPreview({
    super.key,
    required this.reply,
    required this.isMe,
    this.compact = false,
    this.fillWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isMe ? const Color(0xffA8C4FF) : const Color(0xffE9201D);
    final name = reply.senderName ?? 'User';
    final preview = reply.previewText();

    return Container(
      width: fillWidth ? double.infinity : null,
      margin: EdgeInsets.only(bottom: compact ? 0 : 6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8.r),
        border: Border(left: BorderSide(color: accent, width: 3.w)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: accent,
              fontSize: compact ? 12.sp : 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            preview,
            maxLines: compact ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: compact ? 12.sp : 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class ReplyInputBanner extends StatelessWidget {
  final MessageReply reply;
  final VoidCallback onCancel;

  const ReplyInputBanner({
    super.key,
    required this.reply,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 8.w, 6.h),
      decoration: BoxDecoration(
        color: const Color(0xff0A1520),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.reply, color: const Color(0xffE9201D), size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: MessageReplyPreview(
              reply: reply,
              isMe: false,
              compact: true,
            ),
          ),
          IconButton(
            onPressed: onCancel,
            icon: Icon(Icons.close, color: Colors.white54, size: 20.sp),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
