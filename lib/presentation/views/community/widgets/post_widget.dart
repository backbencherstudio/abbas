
import 'package:abbas/presentation/views/community/widgets/post_actions.dart';
import 'package:abbas/presentation/views/community/widgets/post_header.dart';
import 'package:abbas/presentation/views/community/widgets/post_image_card.dart';
import 'package:abbas/presentation/views/community/widgets/post_poll_card.dart';
import 'package:abbas/presentation/views/community/widgets/post_video_card.dart';
import 'package:flutter/material.dart';

import '../../../../cors/theme/app_colors.dart';

class PostWidget extends StatelessWidget {
  final Map<String, dynamic> feed;
  final VoidCallback? onTapComment;

  const PostWidget({super.key, required this.feed, this.onTapComment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final author = feed['author'] as Map<String, dynamic>? ?? {};

    final int likeCount = _toInt(feed['likeCount']);
    final int commentCount = _toInt(feed['commentCount']);
    final int shareCount = _toInt(feed['shareCount']);

    // Calculate minutes ago
    final int minutesAgo = _calculateMinutesAgo(feed['createdAt'] ?? '');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(
            avatarUrl: author['avatarUrl'] ?? '',
            name: author['name'] ?? 'Unknown',
            minutesAgo: minutesAgo,
          ),
          if ((feed['content'] as String?)?.isNotEmpty ?? false) ...[
            const SizedBox(height: 12),
            Text(
              feed['content'] ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
            ),
          ],
          const SizedBox(height: 12),
          if (feed['mediaType'] == 'image')
            PostImageCard(imageUrl: feed['mediaUrl'] ?? '')
          else if (feed['mediaType'] == 'video')
            PostVideoCard(thumbUrl: feed['mediaUrl'] ?? '')
          else if (feed['mediaType'] == 'poll')
              PostPollCard(
                options: _getPollOptions(likeCount, commentCount),
                totalVotes: likeCount,
                selectedIndex: 0,
              ),
          PostActions(
            likes: likeCount,
            comments: commentCount,
            shares: shareCount,
            onTapComment: onTapComment,
          ),
        ],
      ),
    );
  }

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  List<MapEntry<String, int>> _getPollOptions(int likeCount, int commentCount) {
    return [MapEntry("Like", likeCount), MapEntry("Comment", commentCount)];
  }

  int _calculateMinutesAgo(String createdAt) {
    try {
      final createdTime = DateTime.parse(createdAt);
      final difference = DateTime.now().difference(createdTime);
      return difference.inMinutes;
    } catch (_) {
      return 0;
    }
  }
}
