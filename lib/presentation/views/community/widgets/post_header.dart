import 'package:flutter/material.dart';

import '../../../../cors/routes/route_names.dart';
import '../../../../cors/theme/app_colors.dart';

class PostHeader extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final int minutesAgo;

  const PostHeader({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.minutesAgo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        GestureDetector(
         onTap: (){Navigator.pushNamed(context, RouteNames.othersProfile);},
          child: CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
            radius: 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$minutesAgo min ago',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
        const Icon(Icons.more_horiz, color: Colors.grey),
      ],
    );
  }
}
