import '../../../domain/entities/community/post.dart';

class PollOptionModel extends PollOption {
  const PollOptionModel({required super.label, required super.votes});

  factory PollOptionModel.fromJson(Map<String, dynamic> j) =>
      PollOptionModel(label: j['label'], votes: j['votes'] ?? 0);
}

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.authorName,
    required super.authorAvatarUrl,
    required super.minutesAgo,
    required super.text,
    required super.type,
    super.imageUrl,
    super.videoUrl,
    super.videoThumbUrl,
    super.pollOptions,
    super.totalVotes,
    super.selectedIndex,
    required super.likes,
    required super.comments,
    required super.shares,
  });

  factory PostModel.fromJson(Map<String, dynamic> j) {
    final t = switch (j['type']) {
      'image' => PostType.image,
      'video' => PostType.video,
      _ => PostType.poll,
    };

    return PostModel(
      id: j['id'],
      authorName: j['author_name'],
      authorAvatarUrl: j['author_avatar'],
      minutesAgo: j['minutes_ago'],
      text: j['text'] ?? '',
      type: t,
      imageUrl: j['image_url'],
      videoUrl: j['video_url'],
      videoThumbUrl: j['video_thumb_url'],
      pollOptions: j['poll_options'] == null
          ? null
          : (j['poll_options'] as List)
          .map((e) => PollOptionModel.fromJson(e))
          .toList(),
      totalVotes: j['total_votes'],
      selectedIndex: j['selected_index'],
      likes: j['likes'] ?? 0,
      comments: j['comments'] ?? 0,
      shares: j['shares'] ?? 0,
    );
  }
}
