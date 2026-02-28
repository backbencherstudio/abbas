import 'author.dart';

class Feed {
  final String id;
  final String authorId;
  final String content;
  final String createdAt;
  final String updatedAt;
  final String mediaUrl;
  final String mediaType;
  final String visibility;
  final Author author;
  final int likeCount;
  final int commentCount;
  final int shareCount;

  Feed({
    required this.id,
    required this.authorId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.mediaUrl,
    required this.mediaType,
    required this.visibility,
    required this.author,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
  });
}
