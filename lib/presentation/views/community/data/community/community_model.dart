class GetFeedModel {
  String? id;
  String? authorId;
  String? content;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? mediaUrl;
  String? mediaType;
  String? postType;
  String? visibility;

  AuthorModel? author;
  List<LikeModel>? likes;
  List<CommentModel>? comments;
  List<dynamic>? shares;
  List<PollOptionModel>? pollOptions;

  int? likeCount;
  int? commentCount;
  int? shareCount;

  GetFeedModel({
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

  factory GetFeedModel.fromJson(Map<String, dynamic> json) {
    return GetFeedModel(
      id: json['id']?.toString(),
      authorId: json['author_Id']?.toString() ?? json['authorId']?.toString(),
      content: json['content']?.toString(),
      status: json['status']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      mediaUrl: json['media_Url']?.toString() ?? json['mediaUrl']?.toString(),
      mediaType: json['mediaType']?.toString(),
      postType: json['post_type']?.toString() ?? json['postType']?.toString(),
      visibility: json['visibility']?.toString(),

      author: json['author'] != null
          ? AuthorModel.fromJson(json['author'] as Map<String, dynamic>)
          : null,

      likes: json['likes'] != null
          ? (json['likes'] as List)
                .map((v) => LikeModel.fromJson(v as Map<String, dynamic>))
                .toList()
          : null,

      comments: json['comments'] != null
          ? (json['comments'] as List)
                .map((v) => CommentModel.fromJson(v as Map<String, dynamic>))
                .toList()
          : null,

      shares: json['shares'] != null
          ? List<dynamic>.from(json['shares'] as List)
          : null,

      pollOptions: json['poll_options'] != null
          ? (json['poll_options'] as List)
                .map((v) => PollOptionModel.fromJson(v as Map<String, dynamic>))
                .toList()
          : null,

      likeCount: json['likeCount'] != null
          ? int.tryParse(json['likeCount'].toString())
          : json['likes'] != null
          ? (json['likes'] as List).length
          : 0,

      commentCount: json['commentCount'] != null
          ? int.tryParse(json['commentCount'].toString())
          : json['comments'] != null
          ? (json['comments'] as List).length
          : 0,

      shareCount: json['shareCount'] != null
          ? int.tryParse(json['shareCount'].toString())
          : json['shares'] != null
          ? (json['shares'] as List).length
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_Id': authorId,
      'content': content,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'media_Url': mediaUrl,
      'mediaType': mediaType,
      'post_type': postType,
      'visibility': visibility,
      'author': author?.toJson(),
      'likes': likes?.map((v) => v.toJson()).toList(),
      'comments': comments?.map((v) => v.toJson()).toList(),
      'shares': shares ?? [],
      'poll_options': pollOptions?.map((v) => v.toJson()).toList(),
      'likeCount': likeCount ?? likes?.length ?? 0,
      'commentCount': commentCount ?? comments?.length ?? 0,
      'shareCount': shareCount ?? shares?.length ?? 0,
    };
  }
}

class AuthorModel {
  String? id;
  String? name;
  String? username;
  String? avatar;

  AuthorModel({this.id, this.name, this.username, this.avatar});

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      username: json['username']?.toString(),
      avatar: json['avatar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'username': username, 'avatar': avatar};
  }
}

class LikeModel {
  String? id;
  String? postId;
  String? userId;
  String? createdAt;

  LikeModel({this.id, this.postId, this.userId, this.createdAt});

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      id: json['id']?.toString(),
      postId: json['postId']?.toString(),
      userId: json['userId']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'createdAt': createdAt,
    };
  }
}

class CommentModel {
  String? id;
  String? postId;
  String? userId;
  String? content;
  String? createdAt;
  UserModel? user; // কিছু API তে user object থাকে

  CommentModel({
    this.id,
    this.postId,
    this.userId,
    this.content,
    this.createdAt,
    this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id']?.toString(),
      postId: json['postId']?.toString(),
      userId: json['userId']?.toString(),
      content: json['content']?.toString(),
      createdAt: json['createdAt']?.toString(),
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'content': content,
      'createdAt': createdAt,
      'user': user?.toJson(),
    };
  }
}

class UserModel {
  String? id;
  String? name;
  String? username;
  String? avatar;

  UserModel({this.id, this.name, this.username, this.avatar});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      username: json['username']?.toString(),
      avatar: json['avatar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'username': username, 'avatar': avatar};
  }
}

class PollOptionModel {
  String? id;
  String? postId;
  String? title;
  List<dynamic>? votes;

  PollOptionModel({this.id, this.postId, this.title, this.votes});

  factory PollOptionModel.fromJson(Map<String, dynamic> json) {
    return PollOptionModel(
      id: json['id']?.toString(),
      postId: json['postId']?.toString(),
      title: json['title']?.toString(),
      votes: json['votes'] != null
          ? List<dynamic>.from(json['votes'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'postId': postId, 'title': title, 'votes': votes ?? []};
  }
}
