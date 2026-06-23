import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/community/model/community_feed_model.dart';
import 'package:abbas/presentation/views/community/model/community_profile_model.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_feed_provider.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_profile_provider.dart';
import 'package:abbas/presentation/views/community/widgets/create_post_widget.dart';
import 'package:abbas/presentation/views/community/widgets/feed_post_card.dart';
import 'package:abbas/presentation/views/message/provider/create_chat_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart' as legacy_provider;

class CommunityProfileScreen extends ConsumerStatefulWidget {
  final String userId;

  const CommunityProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<CommunityProfileScreen> createState() =>
      _CommunityProfileScreenState();
}

class _CommunityProfileScreenState extends ConsumerState<CommunityProfileScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(
      () => ref.read(communityProfileProvider(widget.userId).notifier).load(),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      ref.read(communityProfileProvider(widget.userId).notifier).loadMore();
    }
  }

  Future<void> _onRefresh() =>
      ref.read(communityProfileProvider(widget.userId).notifier).refresh();

  void _openDetail(String postId) {
    Navigator.pushNamed(
      context,
      RouteNames.communityPostDetail,
      arguments: postId,
    );
  }

  Future<void> _voteOnPoll(String postId, String optionId) async {
    final error = await ref
        .read(communityProfileProvider(widget.userId).notifier)
        .voteOnPoll(postId, optionId);
    if (!mounted || error == null) return;
    Utils.showToast(
      msg: error,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void _comingSoon() {
    Utils.showToast(
      msg: 'Coming soon',
      backgroundColor: AppColors.cardBackground,
      textColor: Colors.white,
    );
  }

  Future<void> _editPost(FeedPost post) async {
    final updated = await Navigator.pushNamed(
      context,
      RouteNames.updatePost,
      arguments: {'id': post.id, 'content': post.content ?? ''},
    );
    if (!mounted) return;
    if (updated == true) {
      await ref.read(communityProfileProvider(widget.userId).notifier).refresh();
    }
  }

  Future<void> _confirmDeletePost(FeedPost post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0A1A29),
        title: const Text(
          'Delete post?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this post? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final error = await ref
        .read(communityProfileProvider(widget.userId).notifier)
        .deletePost(post.id);

    if (!mounted) return;

    if (error != null) {
      Utils.showToast(
        msg: error,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    ref.read(communityFeedProvider.notifier).removePost(post.id);
    Utils.showToast(
      msg: 'Post deleted successfully',
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityProfileProvider(widget.userId));
    final isOwn = state.isOwnProfile(widget.userId);
    final profile = state.profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SecondaryAppBar(
            title: isOwn ? 'My Profile' : 'Profile',
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.activeButtonColor,
              backgroundColor: AppColors.cardBackground,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  if (state.isLoading && profile == null)
                    SliverFillRemaining(
                      child: Padding(
                        padding: EdgeInsets.only(top: 80.h),
                        child: const Center(child: AnimatedLoading()),
                      ),
                    )
                  else if (state.error != null && profile == null)
                    SliverFillRemaining(
                      child: _ErrorView(
                        message: state.error!,
                        onRetry: () => ref
                            .read(
                              communityProfileProvider(widget.userId).notifier,
                            )
                            .load(),
                      ),
                    )
                  else ...[
              SliverToBoxAdapter(
                child: _ProfileHeader(
                  profile: profile,
                  isOwn: isOwn,
                  userId: widget.userId,
                ),
              ),
              if (isOwn)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: CreatePostWidget(
                      onOpenCreatePost: () async {
                        await Navigator.pushNamed(
                          context,
                          RouteNames.createPost,
                        );
                        if (!context.mounted) return;
                        await ref
                            .read(
                              communityProfileProvider(widget.userId).notifier,
                            )
                            .refresh();
                      },
                    ),
                  ),
                ),
              if (state.isEmpty && !state.isLoading)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No posts yet',
                      style: TextStyle(color: Colors.white54, fontSize: 14.sp),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = state.posts[index];
                      return FeedPostCard(
                        key: ValueKey(post.id),
                        post: post,
                        currentUserId: state.currentUserId,
                        showMoreMenu: isOwn,
                        onTap: () => _openDetail(post.id),
                        onLike: () => ref
                            .read(
                              communityProfileProvider(widget.userId).notifier,
                            )
                            .togglePostLike(post.id),
                        onComment: () => _openDetail(post.id),
                        onShare: _comingSoon,
                        onEdit: () => _editPost(post),
                        onDelete: () => _confirmDeletePost(post),
                        onVote: (optionId) => _voteOnPoll(post.id, optionId),
                      );
                    },
                    childCount: state.posts.length,
                  ),
                ),
              if (state.isLoadingMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.activeButtonColor,
                        ),
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final CommunityProfile? profile;
  final bool isOwn;
  final String userId;

  const _ProfileHeader({
    required this.profile,
    required this.isOwn,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final name = profile?.name ?? 'N/A';
    final username = profile?.displayUsername ?? '';
    final about = profile?.about?.trim();
    final avatar = profile?.avatar;
    final cover = profile?.coverImage;
    final hasAvatar = profile?.hasAvatar ?? false;
    final hasCover = profile?.hasCover ?? false;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: double.infinity,
                  height: 140.h,
                  child: hasCover
                      ? Image.network(cover!, fit: BoxFit.cover)
                      : Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF1B2A3A), Color(0xFF0A1A29)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(
                            Icons.landscape_outlined,
                            color: Colors.white24,
                            size: 48.sp,
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: -36.h,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 4.w),
                  ),
                  child: CircleAvatar(
                    radius: 42.r,
                    backgroundColor: const Color(0xFF1B2A3A),
                    backgroundImage:
                        hasAvatar ? NetworkImage(avatar!) : null,
                    child: hasAvatar
                        ? null
                        : Icon(Icons.person, size: 36.sp, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 44.h),
          Text(
            name,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          if (username.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              username,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF5F6CA0),
              ),
            ),
          ],
          SizedBox(height: 16.h),
          if (about != null && about.isNotEmpty)
            _AboutCard(title: profile!.aboutTitle, about: about),
          SizedBox(height: 16.h),
          _ActionRow(isOwn: isOwn, userId: userId, profileName: name),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final String title;
  final String about;

  const _AboutCard({required this.title, required this.about});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A29),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3D4566)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            about,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13.sp,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final bool isOwn;
  final String userId;
  final String profileName;

  const _ActionRow({
    required this.isOwn,
    required this.userId,
    required this.profileName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: legacy_provider.Consumer<CreateChatProvider>(
            builder: (context, chatProvider, _) {
              return ElevatedButton.icon(
                onPressed: userId.isEmpty
                    ? null
                    : () async {
                        await chatProvider.createConversation(userId);
                        if (!context.mounted) return;
                        Navigator.pushNamed(
                          context,
                          RouteNames.oneTwoOneChatScreen,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D4566),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
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
              );
            },
          ),
        ),
        if (isOwn) ...[
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, RouteNames.editProfile),
            child: Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: const Color(0xFF0A1A29),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF3D4566)),
              ),
              child: SvgPicture.asset(
                'assets/icons/edit.svg',
                width: 20.w,
                height: 20.h,
              ),
            ),
          ),
        ] else ...[
          SizedBox(width: 10.w),
          PopupMenuButton<String>(
            color: const Color(0xFF0A1A29),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            icon: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: const Color(0xFF0A1A29),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF3D4566)),
              ),
              child: Icon(Icons.more_horiz, color: Colors.white, size: 22.sp),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/report_icon.svg',
                      width: 18.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Report',
                      style: TextStyle(color: Colors.white, fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'report') {
                Navigator.pushNamed(
                  context,
                  RouteNames.reportUserScreen,
                  arguments: profileName,
                );
              }
            },
          ),
        ],
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 40.sp),
          SizedBox(height: 12.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.activeButtonColor,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
