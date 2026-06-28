import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/presentation/views/message/model/chat_message_model.dart';
import 'package:abbas/presentation/views/message/screens/chat_image_viewer_screen.dart';
import 'package:abbas/presentation/views/message/widgets/message_reply_preview.dart';
import 'package:abbas/presentation/views/message/widgets/voice_message_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_filex/open_filex.dart';

class ChatMessageBody extends StatelessWidget {
  final ChatMessage message;
  final String text;
  final bool isMe;

  const ChatMessageBody({
    super.key,
    required this.message,
    required this.text,
    required this.isMe,
  });

  void _openImages(BuildContext context, List<MessageAttachment> images, int index) {
    final urls = images.map((a) => a.filePath ?? '').where((u) => u.isNotEmpty).toList();
    if (urls.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ChatImageViewerScreen(
          urls: urls,
          initialIndex: index.clamp(0, urls.length - 1),
        ),
      ),
    );
  }

  void _openVideo(BuildContext context, MessageAttachment attachment) {
    final url = attachment.filePath ?? '';
    if (url.isEmpty) return;
    Navigator.pushNamed(
      context,
      RouteNames.videoPlayerScreen,
      arguments: {
        'asset_url': url,
        'file_name': attachment.fileName ?? 'Video',
      },
    );
  }

  void _openPdf(BuildContext context, MessageAttachment attachment) {
    final url = attachment.filePath ?? '';
    if (url.isEmpty) return;
    Navigator.pushNamed(
      context,
      RouteNames.pdfViewerScreen,
      arguments: {
        'asset_url': url,
        'file_name': attachment.fileName ?? 'Document',
        'mime_type': attachment.mimeType,
      },
    );
  }

  Future<void> _openFile(MessageAttachment attachment) async {
    final url = attachment.filePath ?? '';
    if (url.isEmpty) return;
    await OpenFilex.open(url);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (message.replyTo != null)
          MessageReplyPreview(reply: message.replyTo!, isMe: isMe),
        _buildContent(context),
        if (isMe) ...[
          SizedBox(height: 4.h),
          _StatusIcon(status: message.status),
        ],
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (message.kind == MessageKind.audio ||
        message.attachments.any((a) => a.isAudio)) {
      final url = message.attachments
              .firstWhere((a) => a.isAudio, orElse: () => message.attachments.first)
              .filePath ??
          '';
      return VoiceMessagePlayer(
        messageId: message.id,
        audioUrl: url,
        isMe: isMe,
      );
    }

    final imageAttachments =
        message.attachments.where((a) => a.isImage).toList();
    if (message.kind == MessageKind.image || imageAttachments.isNotEmpty) {
      return _buildImages(context, imageAttachments, text);
    }

    final videoAttachments =
        message.attachments.where((a) => a.isVideo).toList();
    if (message.kind == MessageKind.video || videoAttachments.isNotEmpty) {
      return _buildVideoTiles(context, videoAttachments, text);
    }

    final pdfAttachments =
        message.attachments.where((a) => a.isPdf).toList();
    if (pdfAttachments.isNotEmpty) {
      return _buildFileTiles(context, pdfAttachments, text, isPdf: true);
    }

    if (message.kind == MessageKind.file && message.attachments.isNotEmpty) {
      return _buildFileTiles(context, message.attachments, text);
    }

    if (message.kind == MessageKind.call) {
      final isVideoCall = message.content is Map &&
          (message.content as Map)['call_kind']?.toString().toUpperCase() ==
              'VIDEO';
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVideoCall ? Icons.videocam : Icons.phone,
            color: Colors.white70,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 15.sp),
    );
  }

  Widget _buildImages(
    BuildContext context,
    List<MessageAttachment> images,
    String caption,
  ) {
    if (images.isEmpty) {
      return Text(text, style: const TextStyle(color: Colors.white));
    }

    if (images.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _openImages(context, images, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                images.first.filePath ?? '',
                width: 220.w,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _brokenMedia('Image'),
              ),
            ),
          ),
          if (_showCaption(caption)) ...[
            SizedBox(height: 6.h),
            Text(caption, style: const TextStyle(color: Colors.white)),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6.w,
          runSpacing: 6.h,
          children: List.generate(images.length, (index) {
            final attachment = images[index];
            return GestureDetector(
              onTap: () => _openImages(context, images, index),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  attachment.filePath ?? '',
                  width: 100.w,
                  height: 100.w,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 100.w,
                    height: 100.w,
                    color: const Color(0xff1F283D),
                    child: Icon(Icons.broken_image, color: Colors.white54, size: 28.sp),
                  ),
                ),
              ),
            );
          }),
        ),
        if (_showCaption(caption)) ...[
          SizedBox(height: 6.h),
          Text(caption, style: const TextStyle(color: Colors.white)),
        ],
      ],
    );
  }

  Widget _buildVideoTiles(
    BuildContext context,
    List<MessageAttachment> videos,
    String caption,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...videos.map((attachment) {
          return Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: GestureDetector(
              onTap: () => _openVideo(context, attachment),
              child: Container(
                width: 220.w,
                height: 130.h,
                decoration: BoxDecoration(
                  color: const Color(0xff1F283D),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.videocam_outlined,
                        color: Colors.white38, size: 48.sp),
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.play_arrow,
                          color: Colors.white, size: 28.sp),
                    ),
                    if (attachment.fileName != null)
                      Positioned(
                        left: 8.w,
                        right: 8.w,
                        bottom: 8.h,
                        child: Text(
                          attachment.fileName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
        if (_showCaption(caption))
          Text(caption, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildFileTiles(
    BuildContext context,
    List<MessageAttachment> files,
    String caption, {
    bool isPdf = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...files.map((attachment) {
          final isPdfFile = isPdf || attachment.isPdf;
          return Padding(
            padding: EdgeInsets.only(bottom: 6.h),
            child: GestureDetector(
              onTap: () {
                if (isPdfFile) {
                  _openPdf(context, attachment);
                } else {
                  _openFile(attachment);
                }
              },
              child: Container(
                width: 220.w,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPdfFile
                          ? Icons.picture_as_pdf_outlined
                          : Icons.insert_drive_file_outlined,
                      color: isPdfFile
                          ? const Color(0xffE9201D)
                          : Colors.white70,
                      size: 28.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        attachment.fileName ?? 'File',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 13.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        if (_showCaption(caption))
          Text(caption, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  bool _showCaption(String caption) {
    if (caption.isEmpty) return false;
    const placeholders = {'Photo', 'Video', 'Voice message', 'File'};
    return !placeholders.contains(caption);
  }

  Widget _brokenMedia(String label) {
    return Container(
      width: 220.w,
      height: 120.h,
      color: const Color(0xff1F283D),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white54)),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final DeliveryStatus status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case DeliveryStatus.sending:
        return Icon(Icons.access_time, size: 14.sp, color: Colors.white54);
      case DeliveryStatus.sent:
        return Icon(Icons.done, size: 14.sp, color: Colors.white54);
      case DeliveryStatus.delivered:
        return Icon(Icons.done_all, size: 14.sp, color: Colors.white54);
      case DeliveryStatus.read:
        return Icon(Icons.done_all, size: 14.sp, color: Colors.lightBlueAccent);
      case DeliveryStatus.unknown:
        return const SizedBox.shrink();
    }
  }
}
