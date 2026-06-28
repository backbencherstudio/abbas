enum MessageKind {
  text,
  image,
  file,
  audio,
  video,
  call,
  unknown;

  static MessageKind fromApi(String? value) {
    switch (value?.toUpperCase()) {
      case 'TEXT':
        return MessageKind.text;
      case 'IMAGE':
        return MessageKind.image;
      case 'FILE':
        return MessageKind.file;
      case 'AUDIO':
        return MessageKind.audio;
      case 'VIDEO':
        return MessageKind.video;
      case 'CALL':
        return MessageKind.call;
      default:
        return MessageKind.unknown;
    }
  }

  String get apiValue {
    switch (this) {
      case MessageKind.text:
        return 'TEXT';
      case MessageKind.image:
        return 'IMAGE';
      case MessageKind.file:
        return 'FILE';
      case MessageKind.audio:
        return 'AUDIO';
      case MessageKind.video:
        return 'VIDEO';
      case MessageKind.call:
        return 'CALL';
      case MessageKind.unknown:
        return 'TEXT';
    }
  }

  bool get isMedia =>
      this == MessageKind.image ||
      this == MessageKind.file ||
      this == MessageKind.audio ||
      this == MessageKind.video;

  bool get hasAttachments =>
      this == MessageKind.image ||
      this == MessageKind.file ||
      this == MessageKind.audio ||
      this == MessageKind.video;
}

enum DeliveryStatus {
  sent,
  delivered,
  read,
  sending,
  unknown;

  static DeliveryStatus fromApi(String? value) {
    switch (value?.toUpperCase()) {
      case 'SENT':
        return DeliveryStatus.sent;
      case 'DELIVERED':
        return DeliveryStatus.delivered;
      case 'READ':
        return DeliveryStatus.read;
      default:
        return DeliveryStatus.unknown;
    }
  }
}

class MessagesResponse {
  final bool success;
  final String? message;
  final List<ChatMessage> data;
  final MessagesMeta? meta;

  const MessagesResponse({
    required this.success,
    this.message,
    this.data = const [],
    this.meta,
  });

  factory MessagesResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    return MessagesResponse(
      success: json['success'] == true,
      message: json['message']?.toString(),
      data: raw is List
          ? raw
              .whereType<Map>()
              .map((e) => ChatMessage.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      meta: json['meta_data'] is Map
          ? MessagesMeta.fromJson(
              Map<String, dynamic>.from(json['meta_data'] as Map),
            )
          : null,
    );
  }
}

class MessagesMeta {
  final int limit;
  final String? nextCursor;

  const MessagesMeta({this.limit = 20, this.nextCursor});

  factory MessagesMeta.fromJson(Map<String, dynamic> json) {
    final cursor = json['next_cursor']?.toString();
    return MessagesMeta(
      limit: _asInt(json['limit']),
      nextCursor: (cursor == null || cursor.isEmpty || cursor == 'null')
          ? null
          : cursor,
    );
  }
}

class MessageReply {
  final String id;
  final MessageKind kind;
  final dynamic content;
  final String? senderId;
  final MessageSender? sender;
  final List<MessageAttachment> attachments;

  const MessageReply({
    required this.id,
    this.kind = MessageKind.unknown,
    this.content,
    this.senderId,
    this.sender,
    this.attachments = const [],
  });

  factory MessageReply.fromJson(Map<String, dynamic> json) {
    final rawAttachments = json['attachments'];
    return MessageReply(
      id: json['id']?.toString() ?? '',
      kind: MessageKind.fromApi(json['kind']?.toString()),
      content: json['content'],
      senderId: json['sender_id']?.toString(),
      sender: json['sender'] is Map
          ? MessageSender.fromJson(
              Map<String, dynamic>.from(json['sender'] as Map),
            )
          : null,
      attachments: rawAttachments is List
          ? rawAttachments
              .whereType<Map>()
              .map((e) => MessageAttachment.fromJson(
                    Map<String, dynamic>.from(e),
                  ))
              .toList()
          : const [],
    );
  }

  String previewText() {
    if (kind == MessageKind.call && content is Map) {
      final map = Map<String, dynamic>.from(content as Map);
      final callKind = map['call_kind']?.toString() ?? 'Call';
      final status = map['status']?.toString() ?? '';
      if (status == 'MISSED') return 'Missed $callKind call';
      if (status == 'ONGOING') {
        return '${_callKindLabel(callKind)} call in progress';
      }
      return '$callKind call';
    }
    if (content is String) {
      final text = (content as String).trim();
      if (text.isNotEmpty) return text;
    }
    if (attachments.isNotEmpty) {
      final first = attachments.first;
      if (first.isImage) return 'Photo';
      if (first.isVideo) return 'Video';
      if (first.isAudio) return 'Voice message';
      return first.fileName ?? 'File';
    }
    switch (kind) {
      case MessageKind.image:
        return 'Photo';
      case MessageKind.video:
        return 'Video';
      case MessageKind.audio:
        return 'Voice message';
      case MessageKind.file:
        return 'File';
      default:
        return 'Message';
    }
  }

  String? get senderName => sender?.name;
}

class ChatMessage {
  final String id;
  final String conversationId;
  final MessageKind kind;
  final dynamic content;
  final String? createdAt;
  final String? deletedAt;
  final DeliveryStatus status;
  final MessageReply? replyTo;
  final List<MessageAttachment> attachments;
  final MessageSender? sender;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    this.kind = MessageKind.unknown,
    this.content,
    this.createdAt,
    this.deletedAt,
    this.status = DeliveryStatus.unknown,
    this.replyTo,
    this.attachments = const [],
    this.sender,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final rawAttachments = json['attachments'];
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      conversationId: json['conversation_id']?.toString() ?? '',
      kind: MessageKind.fromApi(json['kind']?.toString()),
      content: json['content'],
      createdAt: json['created_at']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
      status: DeliveryStatus.fromApi(json['status']?.toString()),
      replyTo: json['reply_to'] is Map
          ? MessageReply.fromJson(
              Map<String, dynamic>.from(json['reply_to'] as Map),
            )
          : null,
      attachments: rawAttachments is List
          ? rawAttachments
              .whereType<Map>()
              .map((e) => MessageAttachment.fromJson(
                    Map<String, dynamic>.from(e),
                  ))
              .toList()
          : const [],
      sender: json['sender'] is Map
          ? MessageSender.fromJson(
              Map<String, dynamic>.from(json['sender'] as Map),
            )
          : null,
    );
  }

  factory ChatMessage.fromSocket(dynamic raw) {
    final map = _unwrapSocketPayload(raw);
    return ChatMessage.fromJson(_normalizeMessageMap(map));
  }

  static Map<String, dynamic> _unwrapSocketPayload(dynamic raw) {
    if (raw is! Map) return {};
    var map = Map<String, dynamic>.from(raw);
    if (map['message'] is Map) {
      map = Map<String, dynamic>.from(map['message'] as Map);
    } else if (map['data'] is Map) {
      map = Map<String, dynamic>.from(map['data'] as Map);
    }
    return map;
  }

  static Map<String, dynamic> _normalizeMessageMap(Map<String, dynamic> json) {
    final replyRaw = json['reply_to'] ?? json['replyTo'];
    Map<String, dynamic>? replyMap;
    if (replyRaw is Map) {
      replyMap = Map<String, dynamic>.from(replyRaw);
    }

    return {
      'id': json['id'],
      'conversation_id': json['conversation_id'] ?? json['conversationId'],
      'kind': json['kind'],
      'content': json['content'],
      'created_at': json['created_at'] ?? json['createdAt'],
      'deleted_at': json['deleted_at'] ?? json['deletedAt'],
      'status': json['status'],
      'reply_to': replyMap,
      'attachments': json['attachments'],
      'sender': json['sender'],
    };
  }

  static String? conversationIdFromSocket(dynamic raw) {
    final map = _normalizeMessageMap(_unwrapSocketPayload(raw));
    final id = map['conversation_id']?.toString();
    return (id != null && id.isNotEmpty) ? id : null;
  }

  factory ChatMessage.local({
    required String conversationId,
    required String senderId,
    required String text,
    String? senderName,
  }) {
    return ChatMessage(
      id: 'local_${DateTime.now().microsecondsSinceEpoch}',
      conversationId: conversationId,
      kind: MessageKind.text,
      content: text,
      createdAt: DateTime.now().toUtc().toIso8601String(),
      status: DeliveryStatus.sending,
      sender: MessageSender(id: senderId, name: senderName),
    );
  }

  ChatMessage copyWith({DeliveryStatus? status, String? id}) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId,
      kind: kind,
      content: content,
      createdAt: createdAt,
      deletedAt: deletedAt,
      status: status ?? this.status,
      replyTo: replyTo,
      attachments: attachments,
      sender: sender,
    );
  }

  String? get senderId => sender?.id;

  bool isMine(String? currentUserId) =>
      currentUserId != null &&
      currentUserId.isNotEmpty &&
      senderId == currentUserId;

  String bodyText() {
    if (kind == MessageKind.call && content is Map) {
      final map = Map<String, dynamic>.from(content as Map);
      final callKind = map['call_kind']?.toString() ?? 'Call';
      final callStatus = map['status']?.toString() ?? '';
      if (callStatus == 'MISSED') return 'Missed $callKind call';
      if (callStatus == 'ONGOING') {
        return '${_callKindLabel(callKind)} call in progress';
      }
      if (callStatus == 'ENDED') {
        final secs = map['duration_seconds'];
        if (secs != null) {
          return '$callKind call · ${_formatDuration(secs)}';
        }
        return '$callKind call ended';
      }
      return '$callKind call';
    }

    if (content is String) {
      final text = (content as String).trim();
      if (text.isNotEmpty) return text;
    }
    if (content is Map) {
      final text = Map<String, dynamic>.from(content)['text']?.toString();
      if (text != null && text.isNotEmpty) return text;
    }

    if (attachments.isNotEmpty) {
      final name = attachments.first.fileName;
      if (name != null && name.isNotEmpty) return name;
    }

    switch (kind) {
      case MessageKind.image:
        return 'Photo';
      case MessageKind.file:
        return 'File';
      case MessageKind.audio:
        return 'Voice message';
      case MessageKind.video:
        return 'Video';
      default:
        return '';
    }
  }

  bool get hasImageAttachment =>
      attachments.any((a) => a.isImage) ||
      kind == MessageKind.image;

  bool get hasVideoAttachment =>
      attachments.any((a) => a.isVideo) || kind == MessageKind.video;
}

class MessageAttachment {
  final String? fileName;
  final String? filePath;
  final String? mimeType;
  final String? type;

  const MessageAttachment({
    this.fileName,
    this.filePath,
    this.mimeType,
    this.type,
  });

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      fileName: json['file_name']?.toString(),
      filePath: json['file_path']?.toString(),
      mimeType: json['mime_type']?.toString(),
      type: json['type']?.toString(),
    );
  }

  bool get isImage =>
      type?.toUpperCase() == 'IMAGE' ||
      mimeType?.startsWith('image/') == true;

  bool get isVideo =>
      type?.toUpperCase() == 'VIDEO' ||
      mimeType?.startsWith('video/') == true;

  bool get isAudio =>
      type?.toUpperCase() == 'AUDIO' ||
      mimeType?.startsWith('audio/') == true;

  bool get isPdf =>
      type?.toUpperCase() == 'PDF' ||
      mimeType?.contains('pdf') == true ||
      fileName?.toLowerCase().endsWith('.pdf') == true;
}

class MessageSender {
  final String? id;
  final String? name;
  final String? avatar;

  const MessageSender({this.id, this.name, this.avatar});

  factory MessageSender.fromJson(Map<String, dynamic> json) {
    return MessageSender(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      avatar: json['avatar']?.toString(),
    );
  }
}

String _callKindLabel(String callKind) {
  if (callKind.toUpperCase() == 'AUDIO') return 'Audio';
  if (callKind.toUpperCase() == 'VIDEO') return 'Video';
  return callKind;
}

String _formatDuration(dynamic seconds) {
  final s = _asInt(seconds);
  if (s < 60) return '${s}s';
  final m = s ~/ 60;
  final rem = s % 60;
  return rem > 0 ? '${m}m ${rem}s' : '${m}m';
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
