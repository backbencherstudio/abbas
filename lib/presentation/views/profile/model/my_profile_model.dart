class MyProfileModel {
  bool? success;
  String? message;
  Data? data;

  MyProfileModel({this.success, this.message, this.data});

  MyProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
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
  String? about;
  String? avatar;
  String? coverImage;

  Data(
      {this.id,
        this.name,
        this.username,
        this.email,
        this.about,
        this.avatar,
        this.coverImage});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    about = json['about'];
    avatar = json['avatar'];
    coverImage = json['cover_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['about'] = about;
    data['avatar'] = avatar;
    data['cover_image'] = coverImage;
    return data;
  }
}
