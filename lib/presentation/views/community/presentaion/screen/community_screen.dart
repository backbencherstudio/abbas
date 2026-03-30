import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/presentation/views/profile/view_model/profil_screen_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../domain/community/community_entity.dart';
import '../../widgets/create_post_widget.dart';
import '../provider/community/community_screen_provider.dart';

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

  String timeAgo(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return "N/A";
    }

    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dateTime);

      if (diff.inSeconds < 60) {
        return "Just now";
      } else if (diff.inMinutes < 60) {
        return "${diff.inMinutes} min${diff.inMinutes > 1 ? 's' : ''} ago.";
      } else if (diff.inHours < 24) {
        return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago.";
      } else if (diff.inDays < 7) {
        return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago.";
      } else if (diff.inDays < 30) {
        final weeks = (diff.inDays / 7).floor();
        return "$weeks week${weeks > 1 ? 's' : ''} ago.";
      } else {
        return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
      }
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
              padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 0.h),
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
            
                                        Navigator.pushNamed(
                                          context,
                                          RouteNames.othersProfile,
                                        );
            
                                        debugPrint("AuthorID: $authorId");
                                        debugPrint("PostID: ${feed.id}");
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
                                        profileName ?? "N/A",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        timeAgo(feed.createdAt ?? "N/A"),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFD2D2D5),
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
            
                              SizedBox(height: 10.h),
            
                              Text(
                                feed.content ?? "N/A",
                                style: TextStyle(color: Colors.white),
                              ),
            
                              SizedBox(height: 10.h),
            
                              feed.mediaUrl != null && feed.mediaUrl!.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {},
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(feed.mediaUrl!),
                                      ),
                                    )
                                  : Container(
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
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/icons/like_icon_red.png",
                                        width: 24.w,
                                        height: 24.h,
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await provider.getPostLike(
                                            feed.id ?? '',
                                          );
                                        },
                                        child: Text(
                                          '${provider.getPostLikeModel?.likesCount ?? 0}',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
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
                                  GestureDetector(
                                    onTap: () async {
                                      await provider.createPostLike(
                                        feed.id ?? '',
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/like_icon.png",
                                          width: 24.w,
                                          height: 24.h,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          "Like",
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
