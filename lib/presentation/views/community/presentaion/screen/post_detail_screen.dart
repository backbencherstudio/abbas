import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/community/model/comment_model.dart';
import 'package:abbas/presentation/views/community/model/community_feed_model.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_comments_provider.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_feed_provider.dart';
import 'package:abbas/presentation/views/community/widgets/comment_thread.dart';
import 'package:abbas/presentation/views/community/widgets/feed_post_card.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:abbas/presentation/views/profile/view_model/profile_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  CommentModel? _replyTarget;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(
      () => ref.read(commentsProvider(widget.postId).notifier).load(),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(commentsProvider(widget.postId).notifier).loadMore();
    }
  }

  FeedPost? get _post {
    final posts = ref.watch(communityFeedProvider).posts;
    final match = posts.where((p) => p.id == widget.postId);
    return match.isEmpty ? null : match.first;
  }

  void _startReply(CommentModel target) {
    setState(() => _replyTarget = target);
    _focusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() => _replyTarget = null);
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final notifier = ref.read(commentsProvider(widget.postId).notifier);
    final ok = await notifier.addComment(
      content: text,
      commentId: _replyTarget?.id,
    );

    if (!mounted) return;
    if (ok) {
      _controller.clear();
      setState(() => _replyTarget = null);
      FocusScope.of(context).unfocus();
    } else {
      Utils.showToast(
        msg: 'Failed to post comment',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _showCommentOptions(CommentModel comment) {
    final commentsState = ref.read(commentsProvider(widget.postId));
    final profileId = context.read<ProfileScreenProvider>().profile?.data?.id;
    final currentUserId = commentsState.currentUserId ?? profileId;

    final isMine = currentUserId != null &&
        (comment.userId == currentUserId || comment.user?.id == currentUserId);
    if (!isMine) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFF5F6CA0),
                borderRadius: BorderRadius.circular(99.r),
              ),
            ),
            SizedBox(height: 16.h),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Color(0xFFE9201D)),
              title: Text(
                'Delete comment',
                style: TextStyle(color: Colors.white, fontSize: 15.sp),
              ),
              subtitle: Text(
                'Remove this comment permanently',
                style: TextStyle(color: Colors.white54, fontSize: 12.sp),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                _confirmDelete(comment);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.white70),
              title: Text(
                'Cancel',
                style: TextStyle(color: Colors.white70, fontSize: 15.sp),
              ),
              onTap: () => Navigator.pop(sheetContext),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(CommentModel comment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text('Delete comment?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This comment will be removed and cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFE9201D)),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final ok = await ref
        .read(commentsProvider(widget.postId).notifier)
        .deleteComment(comment.id);

    if (!mounted) return;
    Utils.showToast(
      msg: ok ? 'Comment deleted successfully' : 'Failed to delete comment',
      backgroundColor: ok ? Colors.green : Colors.red,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = _post;
    final feedState = ref.watch(communityFeedProvider);
    final commentsState = ref.watch(commentsProvider(widget.postId));
    final currentUserId =
        feedState.currentUserId ?? commentsState.currentUserId;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Post'),
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.only(bottom: 16.h),
              children: [
                if (post != null)
                  FeedPostCard(
                    post: post,
                    contentAlwaysExpanded: true,
                    currentUserId: currentUserId,
                    onTapAuthor: () {
                      final authorId = post.author?.id;
                      if (authorId == null || authorId.isEmpty) return;
                      Navigator.pushNamed(
                        context,
                        RouteNames.communityProfile,
                        arguments: authorId,
                      );
                    },
                    onLike: () => ref
                        .read(communityFeedProvider.notifier)
                        .togglePostLike(post.id),
                    onComment: () => _focusNode.requestFocus(),
                    onShare: _comingSoon,
                    onVote: (optionId) => _voteOnPoll(post.id, optionId),
                  ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
                  child: Text(
                    'All Comments',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildComments(commentsState),
                if (commentsState.isLoadingMore)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
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
              ],
            ),
          ),
          CommentInputBar(
            controller: _controller,
            isPosting: commentsState.isPosting,
            replyingToName: _replyTarget?.user?.name,
            onCancelReply: _cancelReply,
            onSend: _send,
          ),
        ],
      ),
    );
  }

  Widget _buildComments(CommentsState state) {
    if (state.isLoading && state.comments.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: const Center(child: AnimatedLoading()),
      );
    }

    if (state.error != null && state.comments.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
        child: Center(
          child: Text(
            state.error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
        ),
      );
    }

    if (state.comments.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: Center(
          child: Text(
            'No comments yet. Be the first to comment.',
            style: TextStyle(color: Colors.white54, fontSize: 14.sp),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: CommentThread(
        comments: state.comments,
        currentUserId: state.currentUserId ??
            context.read<ProfileScreenProvider>().profile?.data?.id,
        onLike: (commentId) => ref
            .read(commentsProvider(widget.postId).notifier)
            .toggleCommentLike(commentId),
        onReply: _startReply,
        onCommentOptions: _showCommentOptions,
      ),
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
}
