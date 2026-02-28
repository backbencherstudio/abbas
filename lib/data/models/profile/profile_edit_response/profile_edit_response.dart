import 'dart:convert';

class UserResponse {
  final bool success;
  final UserData data;

  UserResponse({
    required this.success,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json['success'],
      data: UserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
  };

  static UserResponse fromRawJson(String str) =>
      UserResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}

class UserData {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String? address;
  final String phoneNumber;
  final String type;
  final List<RoleUser> roleUsers;
  final String? gender;
  final DateTime? dateOfBirth;
  final String experienceLevel;
  final ActingGoals? actingGoals;
  final DateTime createdAt;
  final String avatarUrl;
  final List<String> roles;
  final String userRole;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.address,
    required this.phoneNumber,
    required this.type,
    required this.roleUsers,
    required this.gender,
    required this.dateOfBirth,
    required this.experienceLevel,
    required this.actingGoals,
    required this.createdAt,
    required this.avatarUrl,
    required this.roles,
    required this.userRole,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      avatar: json["avatar"],
      address: json["address"],
      phoneNumber: json["phone_number"],
      type: json["type"],
      roleUsers: List<RoleUser>.from(
          json["role_users"].map((x) => RoleUser.fromJson(x))),
      gender: json["gender"],
      dateOfBirth: json["date_of_birth"] != null
          ? DateTime.tryParse(json["date_of_birth"])
          : null,
      experienceLevel: json["experience_level"],
      actingGoals: json["ActingGoals"] != null
          ? ActingGoals.fromJson(json["ActingGoals"])
          : null,
      createdAt: DateTime.parse(json["created_at"]),
      avatarUrl: json["avatar_url"],
      roles: List<String>.from(json["roles"]),
      userRole: json["user_role"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "avatar": avatar,
    "address": address,
    "phone_number": phoneNumber,
    "type": type,
    "role_users": List<dynamic>.from(roleUsers.map((x) => x.toJson())),
    "gender": gender,
    "date_of_birth": dateOfBirth?.toIso8601String(),
    "experience_level": experienceLevel,
    "ActingGoals": actingGoals?.toJson(),
    "created_at": createdAt.toIso8601String(),
    "avatar_url": avatarUrl,
    "roles": List<dynamic>.from(roles),
    "user_role": userRole,
  };
}

class RoleUser {
  final Role role;

  RoleUser({required this.role});

  factory RoleUser.fromJson(Map<String, dynamic> json) {
    return RoleUser(
      role: Role.fromJson(json["role"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "role": role.toJson(),
  };
}

class Role {
  final String name;
  final String title;

  Role({required this.name, required this.title});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      name: json["name"],
      title: json["title"],
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "title": title,
  };
}

class ActingGoals {
  final String id;
  final String actingGoals;
  final String userId;
  final String? enrollmentId;

  ActingGoals({
    required this.id,
    required this.actingGoals,
    required this.userId,
    this.enrollmentId,
  });

  factory ActingGoals.fromJson(Map<String, dynamic> json) {
    return ActingGoals(
      id: json["id"],
      actingGoals: json["acting_goals"],
      userId: json["userId"],
      enrollmentId: json["enrollmentId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "acting_goals": actingGoals,
    "userId": userId,
    "enrollmentId": enrollmentId,
  };
}
