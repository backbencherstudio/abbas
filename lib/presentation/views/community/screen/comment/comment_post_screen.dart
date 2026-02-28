
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../cors/routes/route_names.dart';
import '../../../../../cors/theme/app_colors.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../widgets/comment_field.dart';
import '../../widgets/comment_widget.dart';
import '../../widgets/create_post_widget.dart';
import '../../widgets/post_widget.dart';

class CommentPostScreen extends StatelessWidget {
  CommentPostScreen({super.key});

  // Static feed data
  final List<Map<String, dynamic>> _feeds = [
    {
      'id': '1',
      'author': {
        'id': 'a1',
        'name': 'Sophie Lambert',
        'avatarUrl': 'assets/images/user1.png.png',
      },
      'content': 'Behind the scenes of our latest project! ✨',
      'createdAt': '2026-02-04T10:20:00Z',
      'mediaUrl': 'assets/images/background_img.png',
      'mediaType': 'image',
      'likeCount': '4800',
      'commentCount': 12,
      'shareCount': '3',
    },
  ];

  // Static comments
  final List<Map<String, dynamic>> _comments = [
    {
      'id': '1',
      'senderName': 'Alice',
      'message': 'Hey, how are you?',
      'isSender': false,
      'time': '2025-09-06 10:30:00',
    },
    {
      'id': '2',
      'senderName': 'Bob',
      'message': 'I\'m good, thanks! What about you?',
      'isSender': true,
      'time': '2025-09-06 10:31:00',
    },
    {
      'id': '3',
      'senderName': 'Alice',
      'message': 'I\'m doing great! Have you seen the latest episode?',
      'isSender': false,
      'time': '2025-09-06 10:32:00',
    },
    {
      'id': '4',
      'senderName': 'Bob',
      'message': 'Yes, I did! It was amazing!',
      'isSender': true,
      'time': '2025-09-06 10:33:00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppbar(title: "Comment"),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: CreatePostWidget(),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.containerColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Post
                    PostWidget(feed: _feeds[0]),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          SizedBox(height: 16.w),
                          const Text('All Comments', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 16.w),
                          Column(
                            children: List.generate(
                              _comments.length,
                                  (index) => CommentWidget(comment: _comments[index]),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),
                    const CommentField(),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
