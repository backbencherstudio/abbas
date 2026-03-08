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
  Author? author;

  List<dynamic>? likes;
  List<dynamic>? comments;
  List<dynamic>? shares;

  List<PollOptions>? pollOptions;

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

  GetFeedModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    authorId = json['author_Id'];
    content = json['content'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    mediaUrl = json['media_Url'];
    mediaType = json['mediaType'];
    postType = json['post_type'];
    visibility = json['visibility'];

    author =
    json['author'] != null ? Author.fromJson(json['author']) : null;

    likes = json['likes'];
    comments = json['comments'];
    shares = json['shares'];

    if (json['poll_options'] != null) {
      pollOptions = [];
      json['poll_options'].forEach((v) {
        pollOptions!.add(PollOptions.fromJson(v));
      });
    }

    likeCount = json['likeCount'];
    commentCount = json['commentCount'];
    shareCount = json['shareCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['author_Id'] = authorId;
    data['content'] = content;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['media_Url'] = mediaUrl;
    data['mediaType'] = mediaType;
    data['post_type'] = postType;
    data['visibility'] = visibility;

    if (author != null) {
      data['author'] = author!.toJson();
    }

    data['likes'] = likes;
    data['comments'] = comments;
    data['shares'] = shares;

    if (pollOptions != null) {
      data['poll_options'] =
          pollOptions!.map((v) => v.toJson()).toList();
    }

    data['likeCount'] = likeCount;
    data['commentCount'] = commentCount;
    data['shareCount'] = shareCount;

    return data;
  }
}

class Author {
  String? id;
  String? name;
  String? username;
  String? avatar;

  Author({this.id, this.name, this.username, this.avatar});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'avatar': avatar,
    };
  }
}

class PollOptions {
  String? id;
  String? postId;
  String? title;

  List<dynamic>? votes;

  PollOptions({
    this.id,
    this.postId,
    this.title,
    this.votes,
  });

  PollOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    title = json['title'];
    votes = json['votes'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'title': title,
      'votes': votes,
    };
  }
}