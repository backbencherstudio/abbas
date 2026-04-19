import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:social_sharing_plus/social_sharing_plus.dart';
import '../../../../../cors/routes/route_names.dart';
import '../../../../../cors/services/user_id_storage.dart';
import '../../../../../cors/theme/app_colors.dart';
import '../../../../../cors/utils/app_utils.dart';
import '../../../../widgets/animated_loading.dart';
import '../../../../widgets/secondary_appber.dart';
import '../../../message/provider/create_chat_provider.dart';
import '../../../profile/view_model/profile_screen_provider.dart';
import '../../domain/community/community_entity.dart';
import '../../widgets/comment_bottom_sheet.dart';
import '../../widgets/community_video_widget.dart';
import '../../widgets/reaction_button.dart';
import '../provider/community/community_screen_provider.dart';

class MyProfilePrivate extends StatelessWidget {
  final String userId;

  const MyProfilePrivate({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileScreenProvider>(
      context,
      listen: false,
    );
    final createChatProvider = Provider.of<CreateChatProvider>(context);

    final data = profileProvider.myProfileModel?.data;
    final name = data?.name ?? "N/A";
    final userName = data?.username ?? "N/A";
    final about = data?.about ?? "N/A";
    final myUserId = data?.id ?? "N/A";
    final avatar = data?.avatar ?? "N/A";
    final coverImage = data?.coverImage ?? 'N/A';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SecondaryAppBar(title: "My Profile", hasButton: true),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                children: [
                  _buildProfileHeader(context, avatar, coverImage),
                  SizedBox(height: 60.h),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF5F6CA0),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildAboutSection(userName, about),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Row(
                      children: [
                        _buildChatButton(myUserId, context, createChatProvider),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF0A1A29),
                              borderRadius: BorderRadius.circular(12.r),
                            ),

                            child: PopupMenuButton(
                              color: Color(0xFF030C15AB),
                              borderRadius: BorderRadius.circular(16.r),
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
                                      onTap: () => showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return AlertDialog(
                                            titlePadding: EdgeInsets.symmetric(
                                              horizontal: 16.w,
                                            ),
                                            backgroundColor: Color(0xFF07121D),
                                            title: Column(
                                              children: [
                                                SizedBox(height: 6.h),
                                                Container(
                                                  width: 33.w,
                                                  height: 4.h,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF5F6CA0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          99.r,
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(height: 24.h),
                                                Image.asset(
                                                  'assets/images/report_img.png',
                                                  width: 48.r,
                                                  height: 48.r,
                                                ),
                                                SizedBox(height: 16.h),
                                                Text(
                                                  "Report Post",
                                                  style: TextStyle(
                                                    fontSize: 18.sp,
                                                    color: Color(0xFFFFFFFF),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(height: 10.h),
                                                Text(
                                                  "Are you sure you to Report the User?",
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Color(0xFFB2B5B8),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(height: 16.h),
                                                FilledButton(
                                                  style: FilledButton.styleFrom(
                                                    fixedSize: Size(
                                                      335.w,
                                                      48.h,
                                                    ),
                                                    backgroundColor: Color(
                                                      0xFFE9201D,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      RouteNames.reportListPage,
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/icons/report_icon.svg',
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      Text(
                                                        "Yes, Report",
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          color: Color(
                                                            0xFFFFFFFF,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 16.h),
                                                OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                        fixedSize: Size(
                                                          335.w,
                                                          48.h,
                                                        ),
                                                        side: BorderSide(
                                                          color: Color(
                                                            0xFF3D4566,
                                                          ),
                                                        ),
                                                      ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.cancel_outlined,
                                                        color: Colors.white,
                                                        size: 16.sp,
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          color: Color(
                                                            0xFFFFFFFF,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 16.h),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF3D4566),
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/report_icon.svg",
                                            ),
                                            SizedBox(width: 6.w),
                                            Text(
                                              "Report",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "share",
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF3D4566),
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/icons/share.png",
                                              width: 18.w,
                                              height: 18.h,
                                            ),
                                            SizedBox(width: 6.w),
                                            Text(
                                              "Share",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ];
                              },
                              // onSelected: (value) {
                              //   if (value == "delete") {
                              //     _deletePost(feed.id ?? "");
                              //   }
                              // },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  //_buildPostCard(context),
                  _myPostCard(profileProvider, myUserId),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    String avatar,
    String coverImage,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: 130.h,
            width: double.infinity,
            child: Image.network(coverImage, fit: BoxFit.cover),
          ),
          Transform.translate(
            offset: Offset(0, 50.h),
            child: Container(
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 50.r,
                backgroundImage: NetworkImage(avatar),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(String userName, String about) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF05111C),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3D4566), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About $userName',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            about,
            style: TextStyle(fontSize: 16.sp, color: Color(0xFFD2D2D5)),
          ),
        ],
      ),
    );
  }

  Widget _buildChatButton(
    String userId,
    BuildContext context,
    CreateChatProvider provider,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: 280.w,
      child: ElevatedButton.icon(
        onPressed: () async {
          if (userId.isNotEmpty) {
            debugPrint("THe userId is for create conversation $userId");
            await provider.createConversation(userId);
          } else {}
          Navigator.pushNamed(context, RouteNames.oneTwoOneChatScreen);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3D4566),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        icon: Image.asset(
          'assets/icons/chat_icon.png',
          width: 20.w,
          height: 20.h,
          color: Colors.white,
        ),
        label: Text(
          'Chat',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _myPostCard(ProfileScreenProvider profileProvider, String myUserId) {
    return Consumer<CommunityScreenProvider>(
      builder: (context, provider, child) {
        final myFeeds = provider.feeds
            .where((element) => element.authorId == myUserId)
            .toList();

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

        if (myFeeds.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.post_add_outlined,
                  size: 24.sp,
                  color: Colors.grey.shade400,
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
          itemCount: myFeeds.length,
          itemBuilder: (context, index) {
            final CommunityEntity feed = myFeeds[index];

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 7.h),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff0A1A2A),
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
                              final UserIdStorage userIdStorage =
                                  UserIdStorage();

                              final userId = await userIdStorage.getUserId();

                              if (authorId == userId) {
                                await profileProvider.getMyProfile();
                                if (context.mounted) {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.myProfilePrivate,
                                    arguments: feed.id,
                                  );
                                }
                              } else if (authorId != null &&
                                  authorId.isNotEmpty) {
                                await profileProvider.getOtherProfile(authorId);

                                if (context.mounted) {
                                  Navigator.pushNamed(
                                    context,
                                    RouteNames.othersProfile,
                                  );
                                }
                              }
                            },
                            child: CircleAvatar(
                              radius: 24.r,
                              backgroundImage: NetworkImage(
                                feed.author?.avatar ?? '',
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feed.author?.name ?? "name : N/A",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                _getTimeAgo(feed.createdAt, feed.updatedAt),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFD2D2D5),
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),

                          PopupMenuButton<String>(
                            color: const Color(0x030C15AB),
                            borderRadius: BorderRadius.circular(16.r),
                            icon: Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                            onSelected: (value) {
                              if (value == "edit") {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.updatePost,
                                  arguments: {
                                    "id": feed.id,
                                    "content": feed.content,
                                  },
                                );
                              } else if (value == "delete") {
                                _showDeleteDialog(context, feed.id ?? '');
                              }
                            },
                            itemBuilder: (context) {
                              return [
                                const PopupMenuItem<String>(
                                  value: "edit",
                                  child: _PopupMenuItemContent(
                                    iconPath: "assets/icons/edit.svg",
                                    label: "Edit",
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: "delete",
                                  child: _PopupMenuItemContent(
                                    iconPath: "assets/icons/delete.svg",
                                    label: "Delete",
                                  ),
                                ),
                              ];
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 10.h),

                      Text(
                        feed.content ?? "content : N/A",
                        style: const TextStyle(color: Colors.white),
                      ),

                      SizedBox(height: 10.h),

                      if (feed.mediaUrl != null && feed.mediaUrl!.isNotEmpty)
                        if (feed.mediaType == 'VIDEO')
                          CommunityVideoWidget(videoUrl: feed.mediaUrl!)
                        else
                          GestureDetector(
                            onTap: () {},
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.network(
                                feed.mediaUrl!,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      height: 200.h,
                                      width: double.infinity,
                                      color: Colors.black12,
                                      child: Center(
                                        child: Icon(
                                          Icons.image,
                                          size: 48.sp,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          )
                      else if (feed.postType == 'POLL' &&
                          feed.pollOptions != null &&
                          feed.pollOptions!.isNotEmpty)
                        Column(
                          children: List.generate(feed.pollOptions!.length, (
                            index,
                          ) {
                            final option = feed.pollOptions![index];
                            // Calculate which option (if any) the user voted for in this poll
                            String? votedOptionId;
                            if (feed.pollOptions != null) {
                              for (var opt in feed.pollOptions!) {
                                if (opt.votes != null &&
                                    opt.votes!.any(
                                      (v) =>
                                          v['userId'] == provider.currentUserId,
                                    )) {
                                  votedOptionId = opt.id;
                                  break;
                                }
                              }
                            }

                            final bool isOptionSelected =
                                votedOptionId == option.id;

                            return Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: isOptionSelected
                                        ? Colors.white
                                        : Colors.white30,
                                    width: 1.w,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                  ),
                                  leading: Radio<String>(
                                    value: option.id ?? '',
                                    groupValue: votedOptionId,
                                    activeColor: Colors.white,
                                    fillColor:
                                        WidgetStateProperty.resolveWith<Color>((
                                          states,
                                        ) {
                                          if (states.contains(
                                            WidgetState.selected,
                                          )) {
                                            return Colors.white;
                                          }
                                          return Colors.white30;
                                        }),
                                    onChanged: (val) {
                                      provider.voteOnAPoll(
                                        feed.id ?? '',
                                        option.id ?? '',
                                      );
                                    },
                                  ),
                                  title: Text(
                                    option.title ?? "Option ${index + 1}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  trailing: CircleAvatar(
                                    radius: 14.r,
                                    backgroundImage: NetworkImage(
                                      feed.author?.avatar ?? '',
                                    ),
                                    child:
                                        (feed.author?.avatar == null ||
                                            feed.author!.avatar!.isEmpty)
                                        ? Icon(
                                            Icons.person,
                                            size: 14.sp,
                                            color: Colors.grey,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          }),
                        )
                      else
                        const SizedBox.shrink(),

                      SizedBox(height: 12.h),

                      Row(
                        children: [
                          Consumer<CommunityScreenProvider>(
                            builder: (context, provider, _) {
                              final reactionLabel = provider.getReaction(
                                feed.id ?? '',
                              );
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
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${provider.getPostLikeCount(feed.id ?? '', feed.likeCount ?? 0)}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
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
                                Consumer<CommunityScreenProvider>(
                                  builder: (context, provider, _) {
                                    return Text(
                                      '${provider.getPostCommentCount(feed.id ?? '', feed.commentCount ?? 0)}',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  },
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
                            decoration: const BoxDecoration(
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
                      Divider(color: const Color(0xFF202C43), height: 1.h),
                      SizedBox(height: 12.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReactionButton(postId: feed.id ?? ''),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (ctx) =>
                                    CommentBottomSheet(postId: feed.id ?? ''),
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

                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (ctx) =>
                                    _buildShareSheet(context, feed),
                              );
                            },
                            child: Row(
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
    );
  }

  /// ---------------------------- time ago --------------------------
  String _getTimeAgo(String? createdAt, String? updatedAt) {
    /// If no timestamps available
    if ((createdAt == null || createdAt.isEmpty) &&
        (updatedAt == null || updatedAt.isEmpty)) {
      return "time : N/A";
    }

    try {
      /// Parse dates
      final DateTime? createdDateTime =
          createdAt != null && createdAt.isNotEmpty
          ? DateTime.parse(createdAt).toLocal()
          : null;
      final DateTime? updatedDateTime =
          updatedAt != null && updatedAt.isNotEmpty
          ? DateTime.parse(updatedAt).toLocal()
          : null;

      /// Determine which time to show
      DateTime displayTime;
      bool isUpdated = false;

      if (updatedDateTime != null && createdDateTime != null) {
        /// If updated time is different from created time (post was edited)
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

      return isUpdated ? "$timeAgo (edited)" : timeAgo;
    } catch (e) {
      return "Invalid time";
    }
  }

  void _showDeleteDialog(BuildContext context, String postId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            titlePadding: EdgeInsets.symmetric(horizontal: 16.w),
            backgroundColor: const Color(0xFF07121D),
            title: Column(
              children: [
                SizedBox(height: 6.h),
                Container(
                  width: 33.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5F6CA0),
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                ),
                SizedBox(height: 24.h),
                Image.asset(
                  'assets/images/report_img.png',
                  width: 48.r,
                  height: 48.r,
                ),
                SizedBox(height: 16.h),
                const Text(
                  "Delete Post",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                const Text(
                  "Are you sure you want to Delete this Post?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFB2B5B8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 16.h),
                FilledButton(
                  style: FilledButton.styleFrom(
                    fixedSize: Size(335.w, 48.h),
                    backgroundColor: const Color(0xFFE9201D),
                  ),
                  onPressed: () {
                    _deletePost(context, postId);
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/delete.svg'),
                      SizedBox(width: 10.w),
                      const Text(
                        "Delete",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size(335.w, 48.h),
                    side: const BorderSide(color: Color(0xFF3D4566)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        size: 16.sp,
                        color: const Color(0xFFFFFFFF),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ---------------------------- delete post --------------------------
  Future<void> _deletePost(BuildContext context, String postId) async {
    final provider = Provider.of<CommunityScreenProvider>(
      context,
      listen: false,
    );
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

  Widget _buildShareSheet(BuildContext context, CommunityEntity feed) {
    final String postId = feed.id ?? "";

    return Container(
      height: 250.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A2A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          SizedBox(height: 16.h),

          Text(
            "Share",
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 20.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _shareItem(
                imageText: 'assets/icons/facebook_icon.png',
                label: "Facebook",
                onTap: () => _shareTo(context, SocialPlatform.facebook, postId),
              ),
              _shareItem(
                imageText: 'assets/icons/linkedin_icon.png',
                label: "LinkedIn",
                onTap: () => _shareTo(context, SocialPlatform.linkedin, postId),
              ),
              _shareItem(
                imageText: 'assets/icons/whatsapp_icon.png',
                label: "WhatsApp",
                onTap: () => _shareTo(context, SocialPlatform.whatsapp, postId),
              ),
              _shareItem(
                imageText: 'assets/icons/telegram_icon.png',
                label: "Telegram",
                onTap: () => _shareTo(context, SocialPlatform.telegram, postId),
              ),
              _shareItem(
                imageText: 'assets/icons/twitter_icon.png',
                label: "Twitter",
                onTap: () => _shareTo(context, SocialPlatform.twitter, postId),
              ),
              _shareItem(
                imageText: 'assets/icons/reddit_icon.png',
                label: "Reddit",
                onTap: () => _shareTo(context, SocialPlatform.reddit, postId),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _shareTo(
    BuildContext context,
    SocialPlatform platform,
    String content,
  ) async {
    try {
      await SocialSharingPlus.shareToSocialMedia(
        platform,
        content,
        media: null, // or add media path if needed
        isOpenBrowser: true,
      );
    } catch (e) {
      if (context.mounted) {
        Utils.showToast(
          msg: 'Error sharing to $platform: $e',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  Widget _shareItem({
    required String imageText,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(radius: 24.sp, backgroundImage: AssetImage(imageText)),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /*  Widget _buildPostCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A29),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: AssetImage('assets/images/girls_profile.png'),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sophie Lambert',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '10 min ago.',
                    style: TextStyle(fontSize: 12.sp, color: Colors.white54),
                  ),
                ],
              ),
              Spacer(),
              PopupMenuButton<String>(
                color: Color(0xFF05111C),
                borderRadius: BorderRadius.circular(20.r),
                onSelected: (String result) {
                  if (result == 'Share') {
                  } else if (result == 'Report') {}
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'Report',
                      child: Container(
                        width: double.infinity,
                        height: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: Color(0xFF3D4566),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/user_report.svg',
                              width: 16.w,
                              height: 16.h,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Report',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Share',
                      child: Container(
                        width: double.infinity,
                        height: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: Color(0xFF3D4566),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/share.png',
                              width: 16.w,
                              height: 16.h,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Share',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                child: Icon(
                  Icons.more_horiz_outlined,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Behind the scenes of our latest project! The team has been working incredibly hard.',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              image: DecorationImage(
                image: AssetImage('assets/images/profile_cover.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          PostActions(likes: 12, comments: 3, shares: 4),
        ],
      ),
    );
  }*/
}

// Separate widget for popup menu items
class _PopupMenuItemContent extends StatelessWidget {
  final String iconPath;
  final String label;

  const _PopupMenuItemContent({required this.iconPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFF3D4566),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(iconPath),
          SizedBox(width: 6.w),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
