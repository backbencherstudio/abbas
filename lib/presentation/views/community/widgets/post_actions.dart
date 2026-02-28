import 'package:flutter/material.dart';

class PostActions extends StatelessWidget {
  final int likes, comments, shares;
  final VoidCallback? onTapComment;
  const PostActions({
    super.key,
    required this.likes,
    required this.comments,
    required this.shares, this.onTapComment,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(color: Colors.grey.shade300);

    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.favorite, size: 16, color: Colors.redAccent),
            const SizedBox(width: 6),
            Text('$likes', style: textStyle),
            const Spacer(),
            Text('$comments comments · $shares shares', style: textStyle),
          ],
        ),
        const Divider(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Action(icon: Icons.thumb_up_alt_outlined, label: 'Like'),
            GestureDetector(onTap: onTapComment, child: _Action(icon: Icons.mode_comment_outlined, label: 'Comment')),
            _Action(icon: Icons.ios_share_outlined, label: 'Share'),
          ],
        ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Action({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade300, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey.shade300),
        ),
      ],
    );
  }
}
