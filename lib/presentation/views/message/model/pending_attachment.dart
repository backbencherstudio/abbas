import 'dart:io';

import 'package:abbas/presentation/views/message/model/chat_message_model.dart';

class PendingAttachment {
  final String path;
  final String fileName;
  final MessageKind kind;

  const PendingAttachment({
    required this.path,
    required this.fileName,
    required this.kind,
  });

  bool get isImage => kind == MessageKind.image;
  bool get isVideo => kind == MessageKind.video;
  bool get isAudio => kind == MessageKind.audio;

  File get file => File(path);
}
