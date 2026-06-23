class CommunityProfileResponse {
  final bool success;
  final CommunityProfile? data;

  const CommunityProfileResponse({required this.success, this.data});

  factory CommunityProfileResponse.fromJson(Map<String, dynamic> json) {
    return CommunityProfileResponse(
      success: json['success'] == true,
      data: json['data'] is Map
          ? CommunityProfile.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }
}

class CommunityProfile {
  final String id;
  final String? name;
  final String? username;
  final String? email;
  final String? avatar;
  final String? coverImage;
  final String? about;

  const CommunityProfile({
    required this.id,
    this.name,
    this.username,
    this.email,
    this.avatar,
    this.coverImage,
    this.about,
  });

  factory CommunityProfile.fromJson(Map<String, dynamic> json) {
    return CommunityProfile(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString(),
      username: json['username']?.toString(),
      email: json['email']?.toString(),
      avatar: json['avatar']?.toString(),
      coverImage: json['cover_image']?.toString(),
      about: json['about']?.toString(),
    );
  }

  bool get hasAvatar => avatar != null && avatar!.isNotEmpty;

  bool get hasCover => coverImage != null && coverImage!.isNotEmpty;

  String get displayUsername {
    if (username != null && username!.isNotEmpty) {
      return username!.startsWith('@') ? username! : '@$username';
    }
    if (email != null && email!.contains('@')) {
      return '@${email!.split('@').first}';
    }
    return '';
  }

  String get aboutTitle {
    final n = name?.trim();
    if (n != null && n.isNotEmpty) {
      final first = n.split(' ').first;
      return 'About $first';
    }
    return 'About';
  }
}
