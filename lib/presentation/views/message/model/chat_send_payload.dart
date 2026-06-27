import 'package:abbas/presentation/views/message/model/chat_message_model.dart';

class ChatSendPayload {
  final String? text;
  final MessageKind kind;
  final List<String> filePaths;
  final String? replyToId;

  const ChatSendPayload({
    this.text,
    required this.kind,
    this.filePaths = const [],
    this.replyToId,
  });

  bool get hasFiles => filePaths.isNotEmpty;
  bool get hasText => text != null && text!.trim().isNotEmpty;
}
