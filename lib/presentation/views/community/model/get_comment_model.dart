class GetCommentModel {
  String? id;
  String? postId;
  String? userId;
  String? content;
  String? createdAt;
  String? avatar;
  String? name;
  String? username;
  dynamic parentId;
  User? user;
  List<Null>? likes;
  List<Replies>? replies;
  int? likeCount;

  GetCommentModel({
    this.id,
    this.postId,
    this.userId,
    this.content,
    this.createdAt,
    this.avatar,
    this.name,
    this.username,
    this.parentId,
    this.user,
    this.likes,
    this.replies,
    this.likeCount,
  });

  GetCommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    userId = json['userId'];
    content = json['content'];
    createdAt = json['createdAt'];
    avatar = json['avatar'];
    name = json['name'];
    username = json['username'];
    parentId = json['parentId'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['likes'] != null) {
      likes = <Null>[];
      json['likes'].forEach((v) {
        likes!.add(v);
      });
    }
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(Replies.fromJson(v));
      });
    }
    likeCount = json['likeCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['postId'] = postId;
    data['userId'] = userId;
    data['content'] = content;
    data['createdAt'] = createdAt;
    data['avatar'] = avatar;
    data['name'] = name;
    data['username'] = username;
    data['parentId'] = parentId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (likes != null) {
      data['likes'] = likes!.map((v) => v).toList();
    }
    if (replies != null) {
      data['replies'] = replies!.map((v) => v.toJson()).toList();
    }
    data['likeCount'] = likeCount;
    return data;
  }
}

class User {
  String? id;
  String? name;
  dynamic username;
  String? avatar;

  User({this.id, this.name, this.username, this.avatar});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['avatar'] = avatar;
    return data;
  }
}

class Replies {
  String? id;
  String? postId;
  String? userId;
  String? content;
  String? createdAt;
  String? avatar;
  String? name;
  dynamic username;
  String? parentId;
  User? user;
  List<Null>? likes;
  int? likeCount;

  Replies({
    this.id,
    this.postId,
    this.userId,
    this.content,
    this.createdAt,
    this.avatar,
    this.name,
    this.username,
    this.parentId,
    this.user,
    this.likes,
    this.likeCount,
  });

  Replies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    userId = json['userId'];
    content = json['content'];
    createdAt = json['createdAt'];
    avatar = json['avatar'];
    name = json['name'];
    username = json['username'];
    parentId = json['parentId'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['likes'] != null) {
      likes = <Null>[];
      json['likes'].forEach((v) {
        likes!.add(v);
      });
    }
    likeCount = json['likeCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['postId'] = postId;
    data['userId'] = userId;
    data['content'] = content;
    data['createdAt'] = createdAt;
    data['avatar'] = avatar;
    data['name'] = name;
    data['username'] = username;
    data['parentId'] = parentId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (likes != null) {
      data['likes'] = likes!.map((v) => v).toList();
    }
    data['likeCount'] = likeCount;
    return data;
  }
}
