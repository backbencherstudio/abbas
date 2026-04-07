import '../../data/community/community_model.dart';

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
  final List<LikeEntity>? likes;
  final List<CommentEntity>? comments;
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


  factory CommunityEntity.fromModel(GetFeedModel model) {
    return CommunityEntity(
      id: model.id,
      authorId: model.authorId,
      content: model.content,
      status: model.status,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      mediaUrl: model.mediaUrl,
      mediaType: model.mediaType,
      postType: model.postType,
      visibility: model.visibility,
      author: model.author != null ? AuthorEntity.fromModel(model.author!) : null,
      likes: model.likes?.map((l) => LikeEntity.fromModel(l)).toList(),
      comments: model.comments?.map((c) => CommentEntity.fromModel(c)).toList(),
      shares: model.shares,
      pollOptions: model.pollOptions?.map((p) => PollOptionEntity.fromModel(p)).toList(),
      likeCount: model.likeCount,
      commentCount: model.commentCount,
      shareCount: model.shareCount,
    );
  }
}

class AuthorEntity {
  final String? id;
  final String? name;
  final String? username;
  final String? avatar;

  const AuthorEntity({this.id, this.name, this.username, this.avatar});

  factory AuthorEntity.fromModel(AuthorModel model) {
    return AuthorEntity(
      id: model.id,
      name: model.name,
      username: model.username,
      avatar: model.avatar,
    );
  }
}

class LikeEntity {
  final String? id;
  final String? postId;
  final String? userId;
  final String? createdAt;

  const LikeEntity({this.id, this.postId, this.userId, this.createdAt});

  factory LikeEntity.fromModel(LikeModel model) {
    return LikeEntity(
      id: model.id,
      postId: model.postId,
      userId: model.userId,
      createdAt: model.createdAt,
    );
  }
}

class CommentEntity {
  final String? id;
  final String? postId;
  final String? userId;
  final String? content;
  final String? createdAt;
  final UserEntity? user;

  const CommentEntity({
    this.id,
    this.postId,
    this.userId,
    this.content,
    this.createdAt,
    this.user,
  });

  factory CommentEntity.fromModel(CommentModel model) {
    return CommentEntity(
      id: model.id,
      postId: model.postId,
      userId: model.userId,
      content: model.content,
      createdAt: model.createdAt,
      user: model.user != null ? UserEntity.fromModel(model.user!) : null,
    );
  }
}

class UserEntity {
  final String? id;
  final String? name;
  final String? username;
  final String? avatar;

  const UserEntity({this.id, this.name, this.username, this.avatar});

  factory UserEntity.fromModel(UserModel model) {
    return UserEntity(
      id: model.id,
      name: model.name,
      username: model.username,
      avatar: model.avatar,
    );
  }
}

class PollOptionEntity {
  final String? id;
  final String? postId;
  final String? title;
  final List<dynamic>? votes;

  const PollOptionEntity({this.id, this.postId, this.title, this.votes});

  factory PollOptionEntity.fromModel(PollOptionModel model) {
    return PollOptionEntity(
      id: model.id,
      postId: model.postId,
      title: model.title,
      votes: model.votes,
    );
  }
}