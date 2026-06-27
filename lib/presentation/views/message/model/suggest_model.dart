class SuggestModel {
  List<Items> items;
  String? nextCursor;

  SuggestModel({required this.items, this.nextCursor});

  factory SuggestModel.fromJson(Map<String, dynamic> json) {
    return SuggestModel(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((v) => Items.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Parses `GET /api/users/discover` response body.
  factory SuggestModel.fromDiscoverResponse(Map<String, dynamic> json) {
    final raw = json['data'];
    final meta = json['meta_data'];
    return SuggestModel(
      items: raw is List
          ? raw
              .whereType<Map>()
              .map((e) => Items.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : [],
      nextCursor: meta is Map ? meta['next_cursor']?.toString() : null,
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
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      username: json['username']?.toString(),
      avatarUrl: json['avatar']?.toString() ?? json['avatar_url']?.toString(),
    );
  }
}
