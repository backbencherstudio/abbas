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
  final String? avatar;
  final String? address;
  final String phoneNumber;
  final String type;
  final DateTime? dateOfBirth;
  final String? experience;
  final String? about;
  final DateTime createdAt;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.address,
    required this.phoneNumber,
    required this.type,
    this.dateOfBirth,
    this.experience,
    this.about,
    required this.createdAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      avatar: json["avatar"],
      address: json["address"],
      phoneNumber: json["phone_number"] ?? "",
      type: json["type"] ?? "",
      dateOfBirth: json["date_of_birth"] != null
          ? DateTime.tryParse(json["date_of_birth"])
          : null,
      experience: json["experience"],
      about: json["about"],
      createdAt: json["created_at"] != null 
          ? DateTime.parse(json["created_at"])
          : DateTime.now(),
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
    "date_of_birth": dateOfBirth?.toIso8601String(),
    "experience": experience,
    "about": about,
    "created_at": createdAt.toIso8601String(),
  };
}
