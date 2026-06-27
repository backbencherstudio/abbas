class ConversationAttachment {
  final String id;
  final String type;
  final String fileName;
  final String filePath;
  final String mimeType;
  final String messageId;

  const ConversationAttachment({
    required this.id,
    this.type = '',
    this.fileName = '',
    this.filePath = '',
    this.mimeType = '',
    this.messageId = '',
  });

  factory ConversationAttachment.fromJson(Map<String, dynamic> json) {
    return ConversationAttachment(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString().toUpperCase() ?? '',
      fileName: json['file_name']?.toString() ?? '',
      filePath: json['file_path']?.toString() ?? '',
      mimeType: json['mime_type']?.toString() ?? '',
      messageId: json['message_id']?.toString() ?? '',
    );
  }

  bool get isImage => type == 'IMAGE';
  bool get isVideo => type == 'VIDEO';
  bool get isPdf =>
      mimeType.toLowerCase().contains('pdf') ||
      fileName.toLowerCase().endsWith('.pdf');
}

class ConversationAttachmentsResponse {
  final List<ConversationAttachment> items;
  final String? nextCursor;
  final int limit;

  const ConversationAttachmentsResponse({
    this.items = const [],
    this.nextCursor,
    this.limit = 10,
  });

  factory ConversationAttachmentsResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final meta = json['meta_data'];
    return ConversationAttachmentsResponse(
      items: raw is List
          ? raw
              .whereType<Map>()
              .map((e) => ConversationAttachment.fromJson(
                    Map<String, dynamic>.from(e),
                  ))
              .toList()
          : const [],
      nextCursor: meta is Map ? meta['next_cursor']?.toString() : null,
      limit: meta is Map ? _asInt(meta['limit'], fallback: 10) : 10,
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}
