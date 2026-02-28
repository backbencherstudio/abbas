// domain/entities/profile/personal_info_entity.dart
class PersonalInfoEntity {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? address;
  final String phoneNumber;
  final String? gender;
  final String dateOfBirth;
  final String experienceLevel;
  final String actingGoals;
  final List<String> roles;
  final String userRole;
  final DateTime createdAt;

  PersonalInfoEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.address,
    required this.phoneNumber,
    this.gender,
    required this.dateOfBirth,
    required this.experienceLevel,
    required this.actingGoals,
    required this.roles,
    required this.userRole,
    required this.createdAt,
  });

  factory PersonalInfoEntity.fromJson(Map<String, dynamic> json) {
    // Handle nested ActingGoals structure
    final actingGoalsData = json['ActingGoals'] ?? {};
    final actingGoals = actingGoalsData is Map<String, dynamic>
        ? actingGoalsData['acting_goals']?.toString() ?? ''
        : '';

    // Handle roles array
    final roles = List<String>.from(json['roles'] ?? []);

    // Parse date
    DateTime createdAt;
    try {
      createdAt = DateTime.parse(json['created_at'] ?? '');
    } catch (e) {
      createdAt = DateTime.now();
    }

    return PersonalInfoEntity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar_url'] ?? json['avatar'],
      address: json['address'],
      phoneNumber: json['phone_number'] ?? '',
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'] ?? '',
      experienceLevel: json['experience_level'] ?? '',
      actingGoals: actingGoals,
      roles: roles,
      userRole: json['user_role'] ?? '',
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'address': address,
      'phone_number': phoneNumber,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'experience_level': experienceLevel,
      'acting_goals': actingGoals,
      'roles': roles,
      'user_role': userRole,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PersonalInfoEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? address,
    String? phoneNumber,
    String? gender,
    String? dateOfBirth,
    String? experienceLevel,
    String? actingGoals,
    List<String>? roles,
    String? userRole,
    DateTime? createdAt,
  }) {
    return PersonalInfoEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      actingGoals: actingGoals ?? this.actingGoals,
      roles: roles ?? this.roles,
      userRole: userRole ?? this.userRole,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}