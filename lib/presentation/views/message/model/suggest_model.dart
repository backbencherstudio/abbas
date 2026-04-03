class SuggestModel {
  List<Items> items;

  SuggestModel({required this.items});

  factory SuggestModel.fromJson(Map<String, dynamic> json) {
    return SuggestModel(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((v) => Items.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Items {
  final String id;
  final String name;
  final String? username;
  final String? avatarUrl;

  Items({
    required this.id,
    required this.name,
    this.username,
    this.avatarUrl,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      username: json['username'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}