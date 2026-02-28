// feed_model.dart
import '../../../domain/entities/community/author.dart';
import '../../../domain/entities/community/feed.dart';

class FeedResponse {
  String? id;
  String? authorId;
  String? content;
  String? createdAt;
  String? updatedAt;
  String? mediaUrl;
  String? mediaType;
  String? visibility;
  AuthorResponse? author;
  List<dynamic>? likes;
  List<dynamic>? comments;
  List<dynamic>? shares;
  int? likeCount;
  int? commentCount;
  int? shareCount;

  FeedResponse({
    this.id,
    this.authorId,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.mediaUrl,
    this.mediaType,
    this.visibility,
    this.author,
    this.likes,
    this.comments,
    this.shares,
    this.likeCount,
    this.commentCount,
    this.shareCount,
  });

  FeedResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    authorId = json['author_Id'];
    content = json['content'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    mediaUrl = json['media_Url'];
    mediaType = json['mediaType'];
    visibility = json['visibility'];
    author =
    json['author'] != null ? AuthorResponse.fromJson(json['author']) : null;

    if (json['likes'] != null) {
      likes = <dynamic>[];
      json['likes'].forEach((v) {
        likes!.add(v);
      });
    }

    if (json['comments'] != null) {
      comments = <dynamic>[];
      json['comments'].forEach((v) {
        comments!.add(v);
      });
    }

    if (json['shares'] != null) {
      shares = <dynamic>[];
      json['shares'].forEach((v) {
        shares!.add(v);
      });
    }

    likeCount = json['likeCount'];
    commentCount = json['commentCount'];
    shareCount = json['shareCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['author_Id'] = this.authorId;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['media_Url'] = this.mediaUrl;
    data['mediaType'] = this.mediaType;
    data['visibility'] = this.visibility;

    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }

    if (this.likes != null) {
      data['likes'] = this.likes;
    }

    if (this.comments != null) {
      data['comments'] = this.comments;
    }

    if (this.shares != null) {
      data['shares'] = this.shares;
    }

    data['likeCount'] = this.likeCount;
    data['commentCount'] = this.commentCount;
    data['shareCount'] = this.shareCount;

    return data;
  }

  Feed toEntity() {
    return Feed(
      id: id ?? '',
      authorId: authorId ?? '',
      content: content ?? '',
      createdAt: createdAt ?? '',
      updatedAt: updatedAt ?? '',
      mediaUrl: mediaUrl ?? '',
      mediaType: mediaType ?? '',
      visibility: visibility ?? '',
      author: author?.toEntity() ?? Author(id: '', name: '', username: '', avatar: ''),
      likeCount: likeCount ?? 0,
      commentCount: commentCount ?? 0,
      shareCount: shareCount ?? 0,
    );
  }
}

class AuthorResponse {
  String? id;
  String? name;
  String? username;
  String? avatar;

  AuthorResponse({this.id, this.name, this.username, this.avatar});

  AuthorResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    return data;
  }

  Author toEntity() {
    return Author(
      id: id ?? '',
      name: name ?? '',
      username: username ?? '',
      avatar: avatar ?? '',
    );
  }
}
