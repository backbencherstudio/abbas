class OtherProfileModel {
  bool? success;
  Data? data;

  OtherProfileModel({this.success, this.data});

  OtherProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? username;
  String? email;
  String? avatar;
  String? about;
  String? coverImage;

  Data({
    this.id,
    this.name,
    this.username,
    this.email,
    this.avatar,
    this.about,
    this.coverImage,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    username = json['username']?.toString();
    email = json['email']?.toString();
    avatar = json['avatar']?.toString();
    about = json['about']?.toString();
    coverImage = json['cover_image']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['avatar'] = avatar;
    data['about'] = about;
    data['cover_image'] = coverImage;
    return data;
  }
}
