import 'package:abbas/presentation/views/message/model/chat_message_model.dart';

enum ConversationType {
  dm,
  group,
  unknown;

  static ConversationType fromApi(String? value) {
    switch (value?.toUpperCase()) {
      case 'DM':
        return ConversationType.dm;
      case 'GROUP':
        return ConversationType.group;
      default:
        return ConversationType.unknown;
    }
  }

  String get apiValue {
    switch (this) {
      case ConversationType.dm:
        return 'DM';
      case ConversationType.group:
        return 'GROUP';
      case ConversationType.unknown:
        return '';
    }
  }

  bool get isGroup => this == ConversationType.group;
  bool get isDm => this == ConversationType.dm;
}

class ConversationsResponse {
  final bool success;
  final String? message;
  final List<ConversationItem> data;
  final ConversationsMeta? meta;

  const ConversationsResponse({
    required this.success,
    this.message,
    this.data = const [],
    this.meta,
  });

  factory ConversationsResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    return ConversationsResponse(
      success: json['success'] == true,
      message: json['message']?.toString(),
      data: raw is List
          ? raw
              .whereType<Map>()
              .map((e) => ConversationItem.fromJson(
                    Map<String, dynamic>.from(e),
                  ))
              .toList()
          : const [],
      meta: json['meta_data'] is Map
          ? ConversationsMeta.fromJson(
              Map<String, dynamic>.from(json['meta_data'] as Map),
            )
          : null,
    );
  }
}

class ConversationsMeta {
  final int limit;
  final String? search;
  final String? nextCursor;

  const ConversationsMeta({
    this.limit = 10,
    this.search,
    this.nextCursor,
  });

  factory ConversationsMeta.fromJson(Map<String, dynamic> json) {
    final cursor = json['next_cursor']?.toString();
    return ConversationsMeta(
      limit: _asInt(json['limit']),
      search: json['search']?.toString(),
      nextCursor: (cursor == null || cursor.isEmpty || cursor == 'null')
          ? null
          : cursor,
    );
  }
}

class ConversationItem {
  final String id;
  final String? title;
  final String? avatar;
  final ConversationType type;
  final int totalMembers;
  final int unreadMessages;
  final ConversationParticipant? participant;
  final bool isSilenced;
  final String? mutedUntil;
  final ConversationLastMessage? lastMessage;

  const ConversationItem({
    required this.id,
    this.title,
    this.avatar,
    this.type = ConversationType.unknown,
    this.totalMembers = 0,
    this.unreadMessages = 0,
    this.participant,
    this.isSilenced = false,
    this.mutedUntil,
    this.lastMessage,
  });

  factory ConversationItem.fromJson(Map<String, dynamic> json) {
    return ConversationItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString(),
      avatar: json['avatar']?.toString(),
      type: ConversationType.fromApi(json['type']?.toString()),
      totalMembers: _asInt(json['total_members']),
      unreadMessages: _asInt(json['unread_messages']),
      participant: json['participant'] is Map
          ? ConversationParticipant.fromJson(
              Map<String, dynamic>.from(json['participant'] as Map),
            )
          : null,
      isSilenced: json['is_silenced'] == true,
      mutedUntil: json['muted_until']?.toString(),
      lastMessage: json['last_message'] is Map
          ? ConversationLastMessage.fromJson(
              Map<String, dynamic>.from(json['last_message'] as Map),
            )
          : null,
    );
  }

  String displayTitle(String? currentUserId) {
    if (type.isGroup) {
      final t = title?.trim();
      return (t != null && t.isNotEmpty) ? t : 'Group';
    }
    final t = title?.trim();
    if (t != null && t.isNotEmpty) return t;
    return participant?.name ?? 'Direct Message';
  }

  String? displayAvatar(String? currentUserId) {
    if (type.isGroup) {
      // Group avatar is optional — never fall back to a user/creator profile photo.
      return null;
    }
    if (avatar != null && avatar!.isNotEmpty) return avatar;
    if (type.isDm) return participant?.avatar;
    return null;
  }
}

class ConversationParticipant {
  final String? id;
  final String? name;
  final String? username;
  final String? avatar;

  const ConversationParticipant({this.id, this.name, this.username, this.avatar});

  factory ConversationParticipant.fromJson(Map<String, dynamic> json) {
    return ConversationParticipant(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      username: json['username']?.toString(),
      avatar: json['avatar']?.toString(),
    );
  }
}

class ConversationLastMessage {
  final String? id;
  final MessageKind kind;
  final dynamic content;
  final String? createdAt;
  final ConversationParticipant? sender;
  final bool isMe;

  const ConversationLastMessage({
    this.id,
    this.kind = MessageKind.unknown,
    this.content,
    this.createdAt,
    this.sender,
    this.isMe = false,
  });

  factory ConversationLastMessage.fromJson(Map<String, dynamic> json) {
    return ConversationLastMessage(
      id: json['id']?.toString(),
      kind: MessageKind.fromApi(json['kind']?.toString()),
      content: json['content'],
      createdAt: json['created_at']?.toString(),
      sender: json['sender'] is Map
          ? ConversationParticipant.fromJson(
              Map<String, dynamic>.from(json['sender'] as Map),
            )
          : null,
      isMe: json['is_me'] == true,
    );
  }

  String previewText() {
    if (kind == MessageKind.call && content is Map) {
      final map = Map<String, dynamic>.from(content as Map);
      final callKind = map['call_kind']?.toString() ?? 'Call';
      final status = map['status']?.toString() ?? '';
      if (status == 'MISSED') return 'Missed $callKind call';
      if (status == 'ENDED') {
        final secs = map['duration_seconds'];
        if (secs != null) return '$callKind call · ${_formatDuration(secs)}';
        return '$callKind call ended';
      }
      return '$callKind call';
    }

    if (kind == MessageKind.image) return 'Photo';
    if (kind == MessageKind.file) return 'File';
    if (kind == MessageKind.audio) return 'Voice message';
    if (kind == MessageKind.video) return 'Video';

    if (content == null) {
      return kind.hasAttachments ? _kindLabel(kind) : 'Message';
    }
    if (content is String) {
      final text = content.toString().trim();
      return text.isNotEmpty ? text : 'Message';
    }
    if (content is Map) {
      final map = Map<String, dynamic>.from(content);
      if (map.containsKey('call_kind')) {
        final callKind = map['call_kind']?.toString() ?? 'Call';
        final status = map['status']?.toString() ?? '';
        if (status == 'MISSED') return 'Missed $callKind call';
        if (status == 'ENDED') {
          final secs = map['duration_seconds'];
          if (secs != null) return '$callKind call · ${_formatDuration(secs)}';
          return '$callKind call ended';
        }
        return '$callKind call';
      }
      final text = map['text']?.toString();
      if (text != null && text.isNotEmpty) return text;
    }
    return 'Message';
  }

  static String _kindLabel(MessageKind kind) {
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
        return 'Attachment';
    }
  }

  static String _formatDuration(dynamic seconds) {
    final s = _asInt(seconds);
    if (s < 60) return '${s}s';
    final m = s ~/ 60;
    final rem = s % 60;
    return rem > 0 ? '${m}m ${rem}s' : '${m}m';
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
