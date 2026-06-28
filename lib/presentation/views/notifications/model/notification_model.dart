class NotificationsResponse {
  final bool success;
  final String message;
  final List<AppNotification> data;
  final NotificationsMeta? metaData;

  NotificationsResponse({
    required this.success,
    this.message = '',
    this.data = const [],
    this.metaData,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'];
    return NotificationsResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: rawList is List
          ? rawList
                .map(
                  (e) => AppNotification.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : const [],
      metaData: json['meta_data'] is Map
          ? NotificationsMeta.fromJson(
              Map<String, dynamic>.from(json['meta_data'] as Map),
            )
          : null,
    );
  }
}

class NotificationsMeta {
  final int unreadCount;
  final String? nextCursor;
  final int total;
  final int limit;
  final String? search;
  final String? type;

  NotificationsMeta({
    this.unreadCount = 0,
    this.nextCursor,
    this.total = 0,
    this.limit = 10,
    this.search,
    this.type,
  });

  factory NotificationsMeta.fromJson(Map<String, dynamic> json) {
    return NotificationsMeta(
      unreadCount: _asInt(json['unread_count']),
      nextCursor: json['next_cursor']?.toString(),
      total: _asInt(json['total']),
      limit: _asInt(json['limit'], fallback: 10),
      search: json['search']?.toString(),
      type: json['type']?.toString(),
    );
  }
}

class AppNotification {
  final String id;
  final String? title;
  final String? content;
  final String? type;
  final String? createdAt;
  final String? readAt;
  final bool isRead;

  AppNotification({
    required this.id,
    this.title,
    this.content,
    this.type,
    this.createdAt,
    this.readAt,
    this.isRead = false,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? content,
    String? type,
    String? createdAt,
    String? readAt,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
      isRead: isRead ?? this.isRead,
    );
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString(),
      content: json['content']?.toString(),
      type: json['type']?.toString(),
      createdAt: json['created_at']?.toString(),
      readAt: json['read_at']?.toString(),
      isRead: json['is_read'] == true,
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}
