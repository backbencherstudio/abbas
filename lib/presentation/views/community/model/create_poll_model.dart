class CreatePollModel {
  String? id;
  Author? author;
  String? content;
  dynamic mediaUrl;
  dynamic mediaType;
  String? postType;
  String? visibility;
  String? status;
  List<PollOptions>? pollOptions;
  String? createdAt;
  String? updatedAt;

  CreatePollModel(
      {this.id,
      this.author,
      this.content,
      this.mediaUrl,
      this.mediaType,
      this.postType,
      this.visibility,
      this.status,
      this.pollOptions,
      this.createdAt,
      this.updatedAt});

  CreatePollModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author =
        json['author'] != null ? Author.fromJson(json['author']) : null;
    content = json['content'];
    mediaUrl = json['media_Url'];
    mediaType = json['mediaType'];
    postType = json['post_type'];
    visibility = json['visibility'];
    status = json['status'];
    if (json['poll_options'] != null) {
      pollOptions = <PollOptions>[];
      json['poll_options'].forEach((v) {
        pollOptions!.add(PollOptions.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    if (author != null) {
      data['author'] = author!.toJson();
    }
    data['content'] = content;
    data['media_Url'] = mediaUrl;
    data['mediaType'] = mediaType;
    data['post_type'] = postType;
    data['visibility'] = visibility;
    data['status'] = status;
    if (pollOptions != null) {
      data['poll_options'] = pollOptions!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Author {
  String? id;
  String? name;
  dynamic username;
  String? avatar;

  Author({this.id, this.name, this.username, this.avatar});

  Author.fromJson(Map<String, dynamic> json) {
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

class PollOptions {
  String? id;
  String? postId;
  String? title;

  PollOptions({this.id, this.postId, this.title});

  PollOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['postId'] = postId;
    data['title'] = title;
    return data;
  }
}
