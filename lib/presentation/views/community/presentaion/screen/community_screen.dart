import 'package:abbas/cors/network/api_response_handle.dart';
import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/profile/view_model/profil_screen_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../domain/community/community_entity.dart';
import '../../widgets/create_post_widget.dart';
import '../../widgets/community_video_widget.dart';
import '../provider/community/community_screen_provider.dart';
import '../../widgets/reaction_button.dart';
import '../../widgets/comment_bottom_sheet.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CommunityScreenProvider>().fetchFeeds();
    });
  }

  /// ---------------------------- delete post --------------------------
  Future<void> _deletePost(String postId) async {
    final provider = context.read<CommunityScreenProvider>();
    try {
      provider.setIsDeletePost(true);
      final response = await provider.deletePost(postId);
      if (response.success) {
        Utils.showToast(
          msg: response.message,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        await provider.fetchFeeds();
      } else {
        Utils.showToast(
          msg: response.message,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Utils.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      provider.setIsDeletePost(false);
    }
  }

  /// ---------------------------- time ago --------------------------
  String _getTimeAgo(String? createdAt, String? updatedAt) {
    // If no timestamps available
    if ((createdAt == null || createdAt.isEmpty) &&
        (updatedAt == null || updatedAt.isEmpty)) {
      return "time : N/A";
    }

    try {
      // Parse dates
      final DateTime? createdDateTime =
          createdAt != null && createdAt.isNotEmpty
          ? DateTime.parse(createdAt).toLocal()
          : null;
      final DateTime? updatedDateTime =
          updatedAt != null && updatedAt.isNotEmpty
          ? DateTime.parse(updatedAt).toLocal()
          : null;

      // Determine which time to show
      DateTime displayTime;
      bool isUpdated = false;

      if (updatedDateTime != null && createdDateTime != null) {
        // If updated time is different from created time (post was edited)
        if (updatedDateTime.isAfter(createdDateTime)) {
          displayTime = updatedDateTime;
          isUpdated = true;
        } else {
          displayTime = createdDateTime;
        }
      } else if (updatedDateTime != null) {
        displayTime = updatedDateTime;
        isUpdated = true;
      } else if (createdDateTime != null) {
        displayTime = createdDateTime;
      } else {
        return "N/A";
      }

      final now = DateTime.now();
      final diff = now.difference(displayTime);

      String timeAgo;
      if (diff.inSeconds < 60) {
        timeAgo = "Just now";
      } else if (diff.inMinutes < 60) {
        timeAgo = "${diff.inMinutes} min${diff.inMinutes > 1 ? 's' : ''} ago";
      } else if (diff.inHours < 24) {
        timeAgo = "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago";
      } else if (diff.inDays < 7) {
        timeAgo = "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago";
      } else if (diff.inDays < 30) {
        final weeks = (diff.inDays / 7).floor();
        timeAgo = "$weeks week${weeks > 1 ? 's' : ''} ago";
      } else {
        timeAgo = "${displayTime.day}/${displayTime.month}/${displayTime.year}";
      }

      // Add "(edited)" suffix if the post was updated
      return isUpdated ? "$timeAgo (edited)" : timeAgo;
    } catch (e) {
      return "Invalid time";
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileScreenProvider>(context);
    final profileImage = profileProvider.profile?.data?.avatar;
    final profileName = profileProvider.profile?.data?.name;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomAppbar(title: "Community"),

            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 8.h),
              child: CreatePostWidget(),
            ),

            Consumer<CommunityScreenProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: AnimatedLoading());
                }

                if (provider.error != null) {
                  return Center(
                    child: Text(
                      provider.error!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                if (provider.feeds.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.post_add_outlined,
                          size: 24.sp,
                          color: Colors.grey.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "No Posts Available",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.feeds.length,
                  itemBuilder: (context, index) {
                    final CommunityEntity feed = provider.feeds[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 7.h,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff0A1A2A),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final authorId = feed.authorId;

                                      if (authorId != null &&
                                          authorId.isNotEmpty) {
                                        await profileProvider.getOtherProfile(
                                          authorId,
                                        );

                                        if (context.mounted) {
                                          Navigator.pushNamed(
                                            context,
                                            RouteNames.othersProfile,
                                          );
                                        }

                                        logger.d("AuthorID: $authorId");
                                        logger.d("PostID: ${feed.id}");
                                      }
                                    },
                                    child: CircleAvatar(
                                      radius: 24.r,
                                      backgroundImage: NetworkImage(
                                        profileImage ?? '',
                                      ),
                                      child:
                                          (feed.author?.avatar == null ||
                                              feed.author!.avatar!.isEmpty)
                                          ? Icon(
                                              Icons.person,
                                              size: 24.sp,
                                              color: Colors.grey,
                                            )
                                          : null,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        profileName ?? "name : N/A",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        _getTimeAgo(
                                          feed.createdAt,
                                          feed.updatedAt,
                                        ),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFD2D2D5),
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),

                                  PopupMenuButton(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    icon: Icon(
                                      Icons.more_horiz,
                                      color: Colors.white,
                                      size: 24.sp,
                                    ),
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                          value: "edit",
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                RouteNames.updatePost,
                                                arguments: {
                                                  "id": feed.id,
                                                  "content": feed.content,
                                                },
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.edit,
                                                  color: Color(0xFF0A1A29),
                                                  size: 24.sp,
                                                ),
                                                SizedBox(width: 10.w),
                                                Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                    color: Color(0xFF0A1A29),
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: "delete",
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: 24.sp,
                                              ),
                                              SizedBox(width: 10.w),
                                              Text(
                                                "Delete",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ];
                                    },
                                    onSelected: (value) {
                                      if (value == "delete") {
                                        _deletePost(feed.id ?? "");
                                      }
                                    },
                                  ),
                                ],
                              ),

                              SizedBox(height: 10.h),

                              Text(
                                feed.content ?? "content : N/A",
                                style: TextStyle(color: Colors.white),
                              ),

                              SizedBox(height: 10.h),

                              if (feed.mediaUrl != null &&
                                  feed.mediaUrl!.isNotEmpty)
                                if (feed.mediaType == 'VIDEO')
                                  CommunityVideoWidget(videoUrl: feed.mediaUrl!)
                                else if (feed.postType == 'POST')
                                  GestureDetector(
                                    onTap: () {},
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: Image.network(
                                        feed.mediaUrl!,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  height: 200.h,
                                                  width: double.infinity,
                                                  color: Colors.black12,
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                      ),
                                    ),
                                  )
                                else if (feed.postType == 'POLL')
                                  Column(
                                    children: List.generate(
                                      feed.pollOptions!.length,
                                      (index) {
                                        logger.d(
                                          "Poll Options : ${feed.pollOptions}",
                                        );
                                        final option = feed.pollOptions![index];
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 8.h),
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                                vertical: 12.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800],
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border: Border.all(
                                                  color: Colors.grey[600]!,
                                                  width: 1.w,
                                                ),
                                              ),
                                              child: ListTile(
                                                title: Text(
                                                  option.title ??
                                                      "Option ${index + 1}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.sp,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.image,
                                  size: 50.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Consumer<CommunityScreenProvider>(
                                    builder: (context, provider, _) {
                                      final reactionLabel = provider
                                          .getReaction(feed.id ?? '');
                                      final reaction = reactionLabel != null
                                          ? kReactions.firstWhere(
                                              (r) => r.label == reactionLabel,
                                              orElse: () => kReactions.first,
                                            )
                                          : kReactions.first;

                                      return Row(
                                        children: [
                                          Text(
                                            reaction.emoji,
                                            style: TextStyle(fontSize: 16.sp),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await provider.getPostLike(
                                                feed.id ?? '',
                                              );
                                            },
                                            child: Text(
                                              '${provider.getPostLikeCount(feed.id ?? '', feed.likeCount ?? 0)}',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "12",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          "comments",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Container(
                                    width: 4.w,
                                    height: 4.h,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF3D4566),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Row(
                                    children: [
                                      Text(
                                        "3",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        "shares",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Divider(color: Color(0xFF202C43), height: 1.h),
                              SizedBox(height: 12.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ReactionButton(postId: feed.id ?? ''),
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (ctx) => CommentBottomSheet(
                                          postId: feed.id ?? '',
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/comment_icon.png",
                                          width: 24.w,
                                          height: 24.h,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          "Comment",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/icons/share_icon.png",
                                        width: 24.w,
                                        height: 24.h,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        "Share",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
