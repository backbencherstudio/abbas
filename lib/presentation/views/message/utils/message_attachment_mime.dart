import 'package:abbas/presentation/views/message/model/chat_message_model.dart';
import 'package:path/path.dart' as p;

/// MIME types for conversation message attachments.
String mimeTypeForMessageAttachment(String filePath) {
  switch (p.extension(filePath).toLowerCase()) {
    case '.jpg':
    case '.jpeg':
      return 'image/jpeg';
    case '.png':
      return 'image/png';
    case '.gif':
      return 'image/gif';
    case '.webp':
      return 'image/webp';
    case '.heic':
      return 'image/heic';
    case '.mp4':
    case '.mov':
      return 'video/mp4';
    case '.avi':
      return 'video/x-msvideo';
    case '.mkv':
      return 'video/x-matroska';
    case '.webm':
      return 'video/webm';
    case '.m4a':
      return 'audio/mp4';
    case '.aac':
      return 'audio/aac';
    case '.mp3':
      return 'audio/mpeg';
    case '.wav':
      return 'audio/wav';
    case '.ogg':
      return 'audio/ogg';
    case '.caf':
      return 'audio/x-caf';
    case '.pdf':
      return 'application/pdf';
    default:
      return 'application/octet-stream';
  }
}

String displayFileNameForMessageAttachment(
  String filePath,
  MessageKind kind,
) {
  final base = p.basename(filePath);
  if (base.isNotEmpty) return base;

  switch (kind) {
    case MessageKind.audio:
      return 'voice_message.m4a';
    case MessageKind.image:
      return 'image.jpg';
    case MessageKind.video:
      return 'video.mp4';
    default:
      return 'attachment';
  }
}
