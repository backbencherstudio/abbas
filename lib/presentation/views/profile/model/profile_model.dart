class CheckMeModel {
  bool? success;
  Data? data;

  CheckMeModel({this.success, this.data});

  CheckMeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
  String? email;
  String? avatar;
  String? address;
  String? phoneNumber;
  String? type;
  String? dateOfBirth;
  String? experience;
  String? about;
  String? createdAt;

  Data({
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.address,
    this.phoneNumber,
    this.type,
    this.dateOfBirth,
    this.experience,
    this.about,
    this.createdAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    address = json['address'];
    phoneNumber = json['phone_number'];
    type = json['type'];
    dateOfBirth = json['date_of_birth'];
    experience = json['experience'];
    about = json['about'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['avatar'] = avatar;
    data['address'] = address;
    data['phone_number'] = phoneNumber;
    data['type'] = type;
    data['date_of_birth'] = dateOfBirth;
    data['experience'] = experience;
    data['about'] = about;
    data['created_at'] = createdAt;
    return data;
  }
}
