// Strongly-typed model for the community feed endpoint:
// `GET /api/community/feed?cursor=&limit=10`
//
// Designed to be defensive about missing/unknown values so the UI can switch
// cleanly on the enums below without ever crashing on unexpected payloads.

/// POLL vs POST.
enum PostType {
  post,
  poll,
  unknown;

  static PostType fromApi(String? value) {
    switch (value?.toUpperCase()) {
      case 'POST':
        return PostType.post;
      case 'POLL':
        return PostType.poll;
      default:
        return PostType.unknown;
    }
  }

  bool get isPoll => this == PostType.poll;
}

/// Visibility of a post.
enum PostVisibility {
  public,
  private,
  unknown;

  static PostVisibility fromApi(String? value) {
    switch (value?.toUpperCase()) {
      case 'PUBLIC':
        return PostVisibility.public;
      case 'PRIVATE':
        return PostVisibility.private;
      default:
        return PostVisibility.unknown;
    }
  }

  String get label {
    switch (this) {
      case PostVisibility.public:
        return 'Public';
      case PostVisibility.private:
        return 'Private';
      case PostVisibility.unknown:
        return '';
    }
  }
}

/// Moderation status of a post.
enum PostStatus {
  approved,
  request,
  rejected,
  unknown;

  static PostStatus fromApi(String? value) {
    switch (value?.toUpperCase()) {
      case 'APPROVED':
        return PostStatus.approved;
      case 'REQUEST':
        return PostStatus.request;
      case 'REJECTED':
        return PostStatus.rejected;
      default:
        return PostStatus.unknown;
    }
  }
}

/// Type of a single attachment on a post.
enum AttachmentType {
  image,
  video,
  unknown;

  static AttachmentType fromApi(String? value) {
    switch (value?.toUpperCase()) {
      case 'IMAGE':
        return AttachmentType.image;
      case 'VIDEO':
        return AttachmentType.video;
      default:
        return AttachmentType.unknown;
    }
  }

  bool get isImage => this == AttachmentType.image;

  bool get isVideo => this == AttachmentType.video;
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

class CommunityFeedResponse {
  final bool success;
  final String? message;
  final List<FeedPost> data;
  final FeedMeta? metaData;

  const CommunityFeedResponse({
    required this.success,
    this.message,
    this.data = const [],
    this.metaData,
  });

  factory CommunityFeedResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'];
    return CommunityFeedResponse(
      success: json['success'] == true,
      message: json['message']?.toString(),
      data: rawList is List
          ? rawList
                .whereType<Map>()
                .map((e) => FeedPost.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : const [],
      metaData: json['meta_data'] is Map
          ? FeedMeta.fromJson(Map<String, dynamic>.from(json['meta_data']))
          : null,
    );
  }
}

class FeedMeta {
  final int limit;
  final String? nextCursor;

  const FeedMeta({this.limit = 10, this.nextCursor});

  factory FeedMeta.fromJson(Map<String, dynamic> json) {
    final cursor = json['next_cursor']?.toString();
    return FeedMeta(
      limit: _asInt(json['limit']),
      nextCursor: (cursor == null || cursor.isEmpty || cursor == 'null')
          ? null
          : cursor,
    );
  }
}

class FeedPost {
  final String id;
  final String? content;
  final PostType postType;
  final PostVisibility visibility;
  final PostStatus status;
  final FeedAuthor? author;
  final List<PollOption> pollOptions;
  final List<PostAttachment> attachments;
  final bool isLiked;
  final int totalLikes;
  final int totalComments;
  final int totalShares;
  final String? createdAt;

  const FeedPost({
    required this.id,
    this.content,
    this.postType = PostType.unknown,
    this.visibility = PostVisibility.unknown,
    this.status = PostStatus.unknown,
    this.author,
    this.pollOptions = const [],
    this.attachments = const [],
    this.isLiked = false,
    this.totalLikes = 0,
    this.totalComments = 0,
    this.totalShares = 0,
    this.createdAt,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    final rawPollOptions = json['poll_options'];
    final rawAttachments = json['attachments'];
    return FeedPost(
      id: json['id']?.toString() ?? '',
      content: json['content']?.toString(),
      postType: PostType.fromApi(json['post_type']?.toString()),
      visibility: PostVisibility.fromApi(json['visibility']?.toString()),
      status: PostStatus.fromApi(json['status']?.toString()),
      author: json['author'] is Map
          ? FeedAuthor.fromJson(Map<String, dynamic>.from(json['author']))
          : null,
      pollOptions: rawPollOptions is List
          ? rawPollOptions
                .whereType<Map>()
                .map((e) => PollOption.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : const [],
      attachments: rawAttachments is List
          ? rawAttachments
                .whereType<Map>()
                .map(
                  (e) => PostAttachment.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList()
          : const [],
      isLiked: json['is_liked'] == true,
      totalLikes: _asInt(json['total_likes']),
      totalComments: _asInt(json['total_comments']),
      totalShares: _asInt(json['total_shares']),
      createdAt: json['created_at']?.toString(),
    );
  }

  bool get isPoll => postType.isPoll;

  bool get hasAttachment => attachments.isNotEmpty;

  List<PostAttachment> get imageAttachments => attachments
      .where((a) => a.type.isImage && a.hasFile)
      .toList();

  List<PostAttachment> get videoAttachments => attachments
      .where((a) => a.type.isVideo && a.hasFile)
      .toList();

  PostAttachment? get firstAttachment =>
      attachments.isEmpty ? null : attachments.first;

  int get pollTotalVotes =>
      pollOptions.fold(0, (sum, option) => sum + option.totalVotes);

  /// Returns the poll option id the given user voted for, if any.
  String? votedOptionIdFor(String? userId) {
    if (userId == null || userId.isEmpty) return null;
    for (final option in pollOptions) {
      if (option.votes.any((v) => v.userId == userId)) return option.id;
    }
    return null;
  }

  /// Returns a copy with locally-mutated like state. Useful for optimistic
  /// updates without refetching the whole feed.
  FeedPost copyWith({
    bool? isLiked,
    int? totalLikes,
    int? totalComments,
    List<PollOption>? pollOptions,
  }) {
    return FeedPost(
      id: id,
      content: content,
      postType: postType,
      visibility: visibility,
      status: status,
      author: author,
      pollOptions: pollOptions ?? this.pollOptions,
      attachments: attachments,
      isLiked: isLiked ?? this.isLiked,
      totalLikes: totalLikes ?? this.totalLikes,
      totalComments: totalComments ?? this.totalComments,
      totalShares: totalShares,
      createdAt: createdAt,
    );
  }
}

class FeedAuthor {
  final String? id;
  final String? name;
  final String? username;
  final String? avatar;

  const FeedAuthor({this.id, this.name, this.username, this.avatar});

  factory FeedAuthor.fromJson(Map<String, dynamic> json) {
    return FeedAuthor(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      username: json['username']?.toString(),
      avatar: json['avatar']?.toString(),
    );
  }

  bool get hasAvatar => avatar != null && avatar!.isNotEmpty;
}

class PollOption {
  final String id;
  final String? title;
  final String? postId;
  final List<PollVote> votes;
  final int totalVotes;

  const PollOption({
    required this.id,
    this.title,
    this.postId,
    this.votes = const [],
    this.totalVotes = 0,
  });

  factory PollOption.fromJson(Map<String, dynamic> json) {
    final rawVotes = json['votes'];
    return PollOption(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString(),
      postId: json['post_id']?.toString(),
      votes: rawVotes is List
          ? rawVotes
                .whereType<Map>()
                .map((e) => PollVote.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : const [],
      totalVotes: _asInt(json['total_votes']),
    );
  }
}

class PollVote {
  final String? userId;
  final String? avatar;

  const PollVote({this.userId, this.avatar});

  factory PollVote.fromJson(Map<String, dynamic> json) {
    return PollVote(
      userId: json['user_id']?.toString() ?? json['userId']?.toString(),
      avatar: json['avatar']?.toString(),
    );
  }

  bool get hasAvatar => avatar != null && avatar!.isNotEmpty;
}

class PostAttachment {
  final String? filePath;
  final AttachmentType type;
  final String? mimeType;

  const PostAttachment({
    this.filePath,
    this.type = AttachmentType.unknown,
    this.mimeType,
  });

  factory PostAttachment.fromJson(Map<String, dynamic> json) {
    return PostAttachment(
      filePath: json['file_path']?.toString(),
      type: AttachmentType.fromApi(json['type']?.toString()),
      mimeType: json['mime_type']?.toString(),
    );
  }

  bool get hasFile => filePath != null && filePath!.isNotEmpty;
}
