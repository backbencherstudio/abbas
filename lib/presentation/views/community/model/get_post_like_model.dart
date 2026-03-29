class GetPostLikeModel {
  List<Likes>? likes;
  int? likesCount;

  GetPostLikeModel({this.likes, this.likesCount});

  GetPostLikeModel.fromJson(Map<String, dynamic> json) {
    if (json['likes'] != null) {
      likes = <Likes>[];
      json['likes'].forEach((v) {
        likes!.add(Likes.fromJson(v));
      });
    }
    likesCount = json['likesCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (likes != null) {
      data['likes'] = likes!.map((v) => v.toJson()).toList();
    }
    data['likesCount'] = likesCount;
    return data;
  }
}

class Likes {
  String? id;
  String? postId;
  String? createdAt;
  User? user;

  Likes({this.id, this.postId, this.createdAt, this.user});

  Likes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    createdAt = json['createdAt'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['postId'] = postId;
    data['createdAt'] = createdAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
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
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['avatar'] = avatar;
    return data;
  }
}
