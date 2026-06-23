import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/community/model/comment_model.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Renders comments using [comment_tree] — one tree per top-level comment with
/// its flat replies list and connector lines (Facebook-style).
class CommentThread extends StatelessWidget {
  final List<CommentModel> comments;
  final String? currentUserId;
  final ValueChanged<String> onLike;
  final ValueChanged<CommentModel> onReply;
  final ValueChanged<CommentModel> onCommentOptions;

  const CommentThread({
    super.key,
    required this.comments,
    required this.currentUserId,
    required this.onLike,
    required this.onReply,
    required this.onCommentOptions,
  });

  bool _isMine(CommentModel comment) {
    if (currentUserId == null || currentUserId!.isEmpty) return false;
    return comment.userId == currentUserId ||
        comment.user?.id == currentUserId;
  }

  PreferredSize _avatar(CommentModel data, double radius) {
    final user = data.user;
    return PreferredSize(
      preferredSize: Size.fromRadius(radius.r),
      child: CircleAvatar(
        radius: radius.r,
        backgroundColor: const Color(0xFF1B2A3A),
        backgroundImage: (user?.hasAvatar ?? false)
            ? NetworkImage(user!.avatar!)
            : null,
        child: (user?.hasAvatar ?? false)
            ? null
            : Icon(Icons.person, size: radius.r, color: Colors.grey),
      ),
    );
  }

  Widget _content(BuildContext context, CommentModel data) {
    return _CommentBubble(
      comment: data,
      showMenu: _isMine(data),
      onLike: onLike,
      onReply: onReply,
      onCommentOptions: onCommentOptions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final comment in comments)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: CommentTreeWidget<CommentModel, CommentModel>(
              comment,
              comment.replies,
              treeThemeData: const TreeThemeData(
                lineColor: Color(0xFF24344A),
                lineWidth: 2,
              ),
              avatarRoot: (context, data) => _avatar(data, 18),
              avatarChild: (context, data) => _avatar(data, 12),
              contentRoot: (context, data) => _content(context, data),
              contentChild: (context, data) => _content(context, data),
            ),
          ),
      ],
    );
  }
}

class _CommentBubble extends StatelessWidget {
  final CommentModel comment;
  final bool showMenu;
  final ValueChanged<String> onLike;
  final ValueChanged<CommentModel> onReply;
  final ValueChanged<CommentModel> onCommentOptions;

  const _CommentBubble({
    required this.comment,
    required this.showMenu,
    required this.onLike,
    required this.onReply,
    required this.onCommentOptions,
  });

  @override
  Widget build(BuildContext context) {
    final user = comment.user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.subContainerColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            user?.name ?? 'N/A',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          _timeAgo(comment.createdAt),
                          style: TextStyle(
                            color: const Color(0xFF8A93A6),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showMenu)
                    GestureDetector(
                      onTap: () => onCommentOptions(comment),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.white70,
                          size: 20.sp,
                        ),
                      ),
                    ),
                ],
              ),
              if ((comment.content ?? '').isNotEmpty ||
                  comment.replyToUser != null) ...[
                SizedBox(height: 3.h),
                _CommentContent(comment: comment),
              ],
            ],
          ),
        ),
        SizedBox(height: 5.h),
        Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => onLike(comment.id),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Image.asset(
                      comment.isLiked
                          ? 'assets/icons/like_icon_red.png'
                          : 'assets/icons/like_icon.png',
                      width: 15.w,
                      height: 15.h,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${comment.likeCount}',
                      style: TextStyle(
                        color: comment.isLiked
                            ? AppColors.activeButtonColor
                            : const Color(0xFFB7BECC),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 18.w),
              GestureDetector(
                onTap: () => onReply(comment),
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'Reply',
                  style: TextStyle(
                    color: const Color(0xFFB7BECC),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CommentContent extends StatelessWidget {
  final CommentModel comment;

  const _CommentContent({required this.comment});

  @override
  Widget build(BuildContext context) {
    final tagUser = comment.replyToUser;
    final text = comment.content ?? '';

    if (tagUser == null) {
      return Text(
        text,
        style: TextStyle(color: const Color(0xFFE3E6EC), fontSize: 13.sp),
      );
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '@${tagUser.displayTag} ',
            style: TextStyle(
              color: AppColors.activeButtonColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: text,
            style: TextStyle(color: const Color(0xFFE3E6EC), fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}

/// Bottom input bar for adding a comment or a reply.
class CommentInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isPosting;
  final String? replyingToName;
  final VoidCallback onCancelReply;
  final VoidCallback onSend;

  const CommentInputBar({
    super.key,
    required this.controller,
    required this.isPosting,
    required this.replyingToName,
    required this.onCancelReply,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: Color(0xFF202C43))),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (replyingToName != null)
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  children: [
                    Text(
                      'Replying to $replyingToName',
                      style: TextStyle(
                        color: const Color(0xFF8A93A6),
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    GestureDetector(
                      onTap: onCancelReply,
                      child: Icon(
                        Icons.close,
                        size: 14.sp,
                        color: const Color(0xFF8A93A6),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: TextField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: AppColors.activeButtonColor,
                      decoration: InputDecoration(
                        hintText: 'Comment Here...',
                        hintStyle: TextStyle(
                          color: AppColors.greyTextColor,
                          fontSize: 14.sp,
                        ),
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onSubmitted: (_) => onSend(),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: isPosting ? null : onSend,
                  child: Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: const BoxDecoration(
                      color: AppColors.activeButtonColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: isPosting
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _timeAgo(String? iso) {
  if (iso == null || iso.isEmpty) return '';
  final parsed = DateTime.tryParse(iso);
  if (parsed == null) return '';
  final diff = DateTime.now().difference(parsed.toLocal());
  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes} min${diff.inMinutes == 1 ? '' : 's'} ago';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
  }
  if (diff.inDays < 7) {
    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  }
  return '${parsed.day}/${parsed.month}/${parsed.year}';
}
