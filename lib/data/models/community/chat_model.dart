class ChatModel {
  final String id;
  final String? senderId;
  final String senderName;
  final String? receiverId;
  final String message;
  final String time;
  final bool? isRead;
  final bool isSender;

  ChatModel({
    required this.id,
    this.senderId,
    required this.senderName,
    this.receiverId,
    required this.message,
    required this.time,
    this.isRead,
    this.isSender = false,
  });
}