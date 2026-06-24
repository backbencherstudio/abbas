import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_feed_provider.dart';
import 'package:abbas/presentation/views/community/widgets/feed_post_card.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../widgets/create_post_widget.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(
      () => ref.read(communityFeedProvider.notifier).loadInitial(),
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
      ref.read(communityFeedProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() =>
      ref.read(communityFeedProvider.notifier).refresh();

  void _openDetail(String postId) {
    Navigator.pushNamed(
      context,
      RouteNames.communityPostDetail,
      arguments: postId,
    );
  }

  void _comingSoon() {
    Utils.showToast(
      msg: 'Coming soon',
      backgroundColor: AppColors.cardBackground,
      textColor: Colors.white,
    );
  }

  Future<void> _voteOnPoll(String postId, String optionId) async {
    final error = await ref
        .read(communityFeedProvider.notifier)
        .voteOnPoll(postId, optionId);
    if (!mounted || error == null) return;
    Utils.showToast(
      msg: error,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> _openSearch() async {
    final result = await Navigator.pushNamed(
      context,
      RouteNames.communitySearch,
    );
    final query = result is String ? result : null;
    if (!mounted || query == null || query.isEmpty) return;
    await ref.read(communityFeedProvider.notifier).search(query);
  }

  Future<void> _clearSearch() =>
      ref.read(communityFeedProvider.notifier).clearSearch();

  void _openAuthorProfile(String? authorId) {
    if (authorId == null || authorId.isEmpty) return;
    Navigator.pushNamed(
      context,
      RouteNames.communityProfile,
      arguments: authorId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityFeedProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          CustomAppbar(
            title: 'Community',
            trailing: GestureDetector(
              onTap: _openSearch,
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 24.w,
                height: 24.h,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.activeButtonColor,
              backgroundColor: AppColors.cardBackground,
              child: _buildBody(state),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(CommunityFeedState state) {
    final children = <Widget>[];

    if (state.isSearchMode) {
      children.add(
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
          child: _SearchResultsHeader(
            query: state.searchQuery!,
            onClear: _clearSearch,
            onEditSearch: _openSearch,
          ),
        ),
      );
    } else {
      children.add(
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
          child: const CreatePostWidget(),
        ),
      );
    }

    if (state.isInitialLoading && state.isEmpty) {
      children.add(
        Padding(
          padding: EdgeInsets.only(top: 80.h),
          child: const Center(child: AnimatedLoading()),
        ),
      );
    } else if (state.error != null && state.isEmpty) {
      children.add(_ErrorView(message: state.error!, onRetry: _onRefresh));
    } else if (state.isEmpty) {
      children.add(
        state.isSearchMode
            ? Padding(
                padding: EdgeInsets.only(top: 80.h),
                child: Center(
                  child: Text(
                    'No posts found for "${state.searchQuery}"',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white54,
                    ),
                  ),
                ),
              )
            : const _EmptyView(),
      );
    } else {
      for (final post in state.posts) {
        children.add(
          FeedPostCard(
            key: ValueKey(post.id),
            post: post,
            currentUserId: state.currentUserId,
            onTap: () => _openDetail(post.id),
            onTapAuthor: () => _openAuthorProfile(post.author?.id),
            onLike: () =>
                ref.read(communityFeedProvider.notifier).togglePostLike(post.id),
            onComment: () => _openDetail(post.id),
            onShare: _comingSoon,
            onVote: (optionId) => _voteOnPoll(post.id, optionId),
          ),
        );
      }
      children.add(_PaginationFooter(state: state));
    }

    return ListView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 24.h),
      children: children,
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  final CommunityFeedState state;

  const _PaginationFooter({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isSearchMode) return const SizedBox.shrink();

    if (state.isLoadingMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: const Center(
          child: SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.activeButtonColor,
            ),
          ),
        ),
      );
    }
    if (!state.hasMore && state.posts.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Center(
          child: Text(
            "You're all caught up",
            style: TextStyle(color: Colors.white38, fontSize: 13.sp),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 80.h),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.post_add_outlined,
              size: 44.sp,
              color: Colors.grey.shade500,
            ),
            SizedBox(height: 14.h),
            Text(
              'No posts yet',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 80.h, left: 24.w, right: 24.w),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.white70, size: 44.sp),
            SizedBox(height: 14.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.white70),
            ),
            SizedBox(height: 16.h),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                'Retry',
                style: TextStyle(color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.borderColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultsHeader extends StatelessWidget {
  final String query;
  final VoidCallback onClear;
  final VoidCallback onEditSearch;

  const _SearchResultsHeader({
    required this.query,
    required this.onClear,
    required this.onEditSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A29),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3D4566)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white54, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: GestureDetector(
              onTap: onEditSearch,
              child: Text(
                query,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GestureDetector(
            onTap: onClear,
            child: Icon(Icons.close, color: Colors.white54, size: 20.sp),
          ),
        ],
      ),
    );
  }
}
