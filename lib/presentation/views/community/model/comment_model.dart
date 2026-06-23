// Paginated comments:
// `GET /api/community/post/{postId}/comments?cursor=&limit=10`
//
// Response: { success, data: [top-level comments], meta_data: { next_cursor } }
// Each top-level comment has a flat `replies` list (one level only). Further
// replies to a reply are still stored in the same parent `replies` array and
// may include `reply_to_user` for UI tagging.

class CommentUser {
  final String? id;
  final String? name;
  final String? username;
  final String? avatar;

  const CommentUser({this.id, this.name, this.username, this.avatar});

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      username: json['username']?.toString(),
      avatar: json['avatar']?.toString(),
    );
  }

  bool get hasAvatar => avatar != null && avatar!.isNotEmpty;

  String get displayTag {
    if (username != null && username!.isNotEmpty) return username!;
    if (name != null && name!.isNotEmpty) return name!.replaceAll(' ', '');
    return 'user';
  }
}

class CommentsListResponse {
  final bool success;
  final String? message;
  final List<CommentModel> data;
  final CommentsMeta? metaData;

  const CommentsListResponse({
    required this.success,
    this.message,
    this.data = const [],
    this.metaData,
  });

  factory CommentsListResponse.fromJson(
    Map<String, dynamic> json, {
    String? currentUserId,
  }) {
    final rawList = json['data'];
    return CommentsListResponse(
      success: json['success'] == true,
      message: json['message']?.toString(),
      data: rawList is List
          ? rawList
                .whereType<Map>()
                .map(
                  (e) => CommentModel.fromJson(
                    Map<String, dynamic>.from(e),
                    currentUserId: currentUserId,
                    isTopLevel: true,
                  ),
                )
                .toList()
          : const [],
      metaData: json['meta_data'] is Map
          ? CommentsMeta.fromJson(
              Map<String, dynamic>.from(json['meta_data']),
            )
          : null,
    );
  }
}

class CommentsMeta {
  final int limit;
  final String? nextCursor;

  const CommentsMeta({this.limit = 10, this.nextCursor});

  factory CommentsMeta.fromJson(Map<String, dynamic> json) {
    final cursor = json['next_cursor']?.toString();
    return CommentsMeta(
      limit: _asInt(json['limit']),
      nextCursor: (cursor == null || cursor.isEmpty || cursor == 'null')
          ? null
          : cursor,
    );
  }
}

class CommentModel {
  final String id;
  final String? content;
  final String? createdAt;
  final String? parentId;
  final String? userId;
  final CommentUser? user;
  /// Who this reply is directed at (present when replying to another reply).
  final CommentUser? replyToUser;
  final List<CommentModel> replies;
  final int likeCount;
  final bool isLiked;

  const CommentModel({
    required this.id,
    this.content,
    this.createdAt,
    this.parentId,
    this.userId,
    this.user,
    this.replyToUser,
    this.replies = const [],
    this.likeCount = 0,
    this.isLiked = false,
  });

  factory CommentModel.fromJson(
    Map<String, dynamic> json, {
    String? currentUserId,
    bool isTopLevel = false,
  }) {
    final rawReplies = json['replies'];
    final rawLikes = json['likes'];

    return CommentModel(
      id: json['id']?.toString() ?? '',
      content: json['content']?.toString(),
      createdAt: json['created_at']?.toString(),
      parentId: json['parent_id']?.toString(),
      userId: json['user_id']?.toString(),
      user: json['user'] is Map
          ? CommentUser.fromJson(Map<String, dynamic>.from(json['user']))
          : null,
      replyToUser: _parseReplyToUser(json),
      replies: isTopLevel && rawReplies is List
          ? rawReplies
                .whereType<Map>()
                .map(
                  (e) => CommentModel.fromJson(
                    Map<String, dynamic>.from(e),
                    currentUserId: currentUserId,
                    isTopLevel: false,
                  ),
                )
                .toList()
          : const [],
      likeCount: _asInt(json['likeCount'] ?? json['like_count']),
      isLiked: json['is_liked'] == true ||
          _likedByUser(rawLikes, currentUserId),
    );
  }

  bool get isReply => parentId != null && parentId!.isNotEmpty;

  CommentModel copyWith({
    bool? isLiked,
    int? likeCount,
    List<CommentModel>? replies,
  }) {
    return CommentModel(
      id: id,
      content: content,
      createdAt: createdAt,
      parentId: parentId,
      userId: userId,
      user: user,
      replyToUser: replyToUser,
      replies: replies ?? this.replies,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

CommentUser? _parseReplyToUser(Map<String, dynamic> json) {
  for (final key in [
    'reply_to_user',
    'replied_to_user',
    'tagged_user',
    'reply_to',
    'replied_to',
  ]) {
    final value = json[key];
    if (value is Map) {
      return CommentUser.fromJson(Map<String, dynamic>.from(value));
    }
  }
  return null;
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

bool _likedByUser(dynamic rawLikes, String? currentUserId) {
  if (currentUserId == null || rawLikes is! List) return false;
  for (final like in rawLikes) {
    if (like is Map) {
      final byUserId = like['user_id']?.toString();
      final byNestedUser = like['user'] is Map
          ? like['user']['id']?.toString()
          : null;
      if (byUserId == currentUserId || byNestedUser == currentUserId) {
        return true;
      }
    }
  }
  return false;
}
