
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../cors/routes/route_names.dart';
import '../../../../cors/theme/app_colors.dart';
import '../../../widgets/custom_appbar.dart';
import '../widgets/create_post_widget.dart';
import '../widgets/post_widget.dart';

class CommunityScreen extends StatelessWidget {
  CommunityScreen({super.key});

  // Static feed data using Map<String, dynamic>
  final List<Map<String, dynamic>> _feeds = [
    {
      'id': '1',
      'author': {
        'id': 'a1',
        'name': 'Sophie Lambert',
        'avatarUrl': 'assets/images/avatar_1.png',
      },
      'content':
      'Behind the scenes of our latest project! The team has been working incredibly hard. ✨',
      'createdAt': '2026-02-04T10:20:00Z',
      'updatedAt': '2026-02-04T10:20:00Z',
      'mediaUrl': 'assets/images/ballet.jpg',
      'mediaType': 'image',
      'visibility': 'public',
      'likeCount': 4800,
      'commentCount': 12,
      'shareCount': 3,
    },
    {
      'id': '2',
      'author': {
        'id': 'a2',
        'name': 'Alex Morgan',
        'avatarUrl': null,
      },
      'content': 'Dress rehearsal was magical tonight 💃🕺',
      'createdAt': '2026-02-04T09:05:00Z',
      'updatedAt': '2026-02-04T09:05:00Z',
      'mediaUrl': 'assets/images/rehearsal.jpg',
      'mediaType': 'image',
      'visibility': 'public',
      'likeCount': 920,
      'commentCount': 8,
      'shareCount': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          CustomAppbar(title: "Community"),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: CreatePostWidget(),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: _feeds.isEmpty
                ? const Center(child: Text('No feeds yet'))
                : RefreshIndicator(
              onRefresh: () async {
                // Just a placeholder for RefreshIndicator
                await Future.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    _feeds.length,
                        (index) => PostWidget(
                      // Pass the map directly to PostWidget
                      feed: _feeds[index],
                      onTapComment: () => Navigator.pushNamed(
                        context,
                        RouteNames.commentScreen,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
