enum PostType { image, video, poll }

class PollOption {
  final String label;
  final int votes;
  const PollOption({required this.label, required this.votes});
}

class Post {
  final String id;
  final String authorName;
  final String authorAvatarUrl;
  final int minutesAgo;
  final String text;
  final PostType type;

  // media
  final String? imageUrl;
  final String? videoUrl;
  final String? videoThumbUrl;

  // poll
  final List<PollOption>? pollOptions;
  final int? totalVotes;
  final int? selectedIndex;

  // social
  final int likes;
  final int comments;
  final int shares;

  const Post({
    required this.id,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.minutesAgo,
    required this.text,
    required this.type,
    this.imageUrl,
    this.videoUrl,
    this.videoThumbUrl,
    this.pollOptions,
    this.totalVotes,
    this.selectedIndex,
    required this.likes,
    required this.comments,
    required this.shares,
  });
}
