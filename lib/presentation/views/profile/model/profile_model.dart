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
  List<RoleUsers>? roleUsers;
  String? gender;
  String? dateOfBirth;
  String? experienceLevel;
  ActingGoals? actingGoals;
  String? createdAt;
  List<String>? roles;
  String? userRole;

  Data({
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.address,
    this.phoneNumber,
    this.type,
    this.roleUsers,
    this.gender,
    this.dateOfBirth,
    this.experienceLevel,
    this.actingGoals,
    this.createdAt,
    this.roles,
    this.userRole,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    address = json['address'];
    phoneNumber = json['phone_number'];
    type = json['type'];
    if (json['role_users'] != null) {
      roleUsers = <RoleUsers>[];
      json['role_users'].forEach((v) {
        roleUsers!.add(RoleUsers.fromJson(v));
      });
    }
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    experienceLevel = json['experience_level'];
    actingGoals = json['ActingGoals'] != null
        ? ActingGoals.fromJson(json['ActingGoals'])
        : null;
    createdAt = json['created_at'];
    roles = json['roles'].cast<String>();
    userRole = json['user_role'];
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
    if (roleUsers != null) {
      data['role_users'] = roleUsers!.map((v) => v.toJson()).toList();
    }
    data['gender'] = gender;
    data['date_of_birth'] = dateOfBirth;
    data['experience_level'] = experienceLevel;
    if (actingGoals != null) {
      data['ActingGoals'] = actingGoals!.toJson();
    }
    data['created_at'] = createdAt;
    data['roles'] = roles;
    data['user_role'] = userRole;
    return data;
  }
}

class RoleUsers {
  Role? role;

  RoleUsers({this.role});

  RoleUsers.fromJson(Map<String, dynamic> json) {
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (role != null) {
      data['role'] = role!.toJson();
    }
    return data;
  }
}

class Role {
  String? name;
  String? title;

  Role({this.name, this.title});

  Role.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['title'] = title;
    return data;
  }
}

class ActingGoals {
  String? id;
  String? actingGoals;
  String? userId;
  String? enrollmentId;

  ActingGoals({this.id, this.actingGoals, this.userId, this.enrollmentId});

  ActingGoals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    actingGoals = json['acting_goals'];
    userId = json['userId'];
    enrollmentId = json['enrollmentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['acting_goals'] = actingGoals;
    data['userId'] = userId;
    data['enrollmentId'] = enrollmentId;
    return data;
  }
}
