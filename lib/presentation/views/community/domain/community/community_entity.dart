class CommunityEntity {
  final String? id;
  final String? authorId;
  final String? content;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? mediaUrl;
  final String? mediaType;
  final String? postType;
  final String? visibility;
  final AuthorEntity? author;
  final List<dynamic>? likes;
  final List<dynamic>? comments;
  final List<dynamic>? shares;
  final List<PollOptionEntity>? pollOptions;
  final int? likeCount;
  final int? commentCount;
  final int? shareCount;

  const CommunityEntity({
    this.id,
    this.authorId,
    this.content,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.mediaUrl,
    this.mediaType,
    this.postType,
    this.visibility,
    this.author,
    this.likes,
    this.comments,
    this.shares,
    this.pollOptions,
    this.likeCount,
    this.commentCount,
    this.shareCount,
  });
}

class AuthorEntity {
  final String? id;
  final String? name;
  final String? username;
  final String? avatar;

  const AuthorEntity({this.id, this.name, this.username, this.avatar});
}

class PollOptionEntity {
  final String? id;
  final String? postId;
  final String? title;
  final List<dynamic>? votes;

  const PollOptionEntity({this.id, this.postId, this.title, this.votes});
}
