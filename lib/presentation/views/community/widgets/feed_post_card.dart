import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/community/model/community_feed_model.dart';
import 'package:abbas/presentation/views/community/widgets/community_image_viewer.dart';
import 'package:abbas/presentation/views/community/widgets/community_video_widget.dart';
import 'package:abbas/presentation/views/community/widgets/expandable_post_text.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A single feed item. Renders differently based on [FeedPost.postType] and
/// the attachment type, but keeps a consistent header / footer chrome.
class FeedPostCard extends StatelessWidget {
  final FeedPost post;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onMore;
  final VoidCallback? onTapAuthor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<String>? onVote;
  final bool contentAlwaysExpanded;
  final String? currentUserId;
  final bool showMoreMenu;

  const FeedPostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onMore,
    this.onTapAuthor,
    this.onEdit,
    this.onDelete,
    this.onVote,
    this.contentAlwaysExpanded = false,
    this.currentUserId,
    this.showMoreMenu = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.containerColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12.r, 12.r, 12.r, 0),
              child: _Header(
                post: post,
                onTapAuthor: onTapAuthor,
                onMore: onMore,
                showMoreMenu: showMoreMenu,
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ),
            GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.r, 10.h, 12.r, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((post.content ?? '').isNotEmpty)
                      ExpandablePostText(
                        text: post.content!,
                        alwaysExpanded: contentAlwaysExpanded,
                      ),
                    _Body(
                      post: post,
                      onVote: onVote,
                      votedOptionId: post.votedOptionIdFor(currentUserId),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.r, 12.h, 12.r, 8.h),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: onTap,
                    behavior: HitTestBehavior.opaque,
                    child: _CountsRow(post: post),
                  ),
                  SizedBox(height: 12.h),
                  Divider(color: const Color(0xFF202C43), height: 1.h),
                  SizedBox(height: 8.h),
                  _ActionsRow(
                    post: post,
                    onLike: onLike,
                    onComment: onComment,
                    onShare: onShare,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final FeedPost post;
  final VoidCallback? onTapAuthor;
  final VoidCallback? onMore;
  final bool showMoreMenu;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _Header({
    required this.post,
    this.onTapAuthor,
    this.onMore,
    this.showMoreMenu = false,
    this.onEdit,
    this.onDelete,
  });

  String _subtitle() {
    final timeAgo = _timeAgo(post.createdAt);
    if (timeAgo.isNotEmpty) return timeAgo;
    return post.visibility.label;
  }

  @override
  Widget build(BuildContext context) {
    final author = post.author;
    final subtitle = _subtitle();

    return Row(
      children: [
        GestureDetector(
          onTap: onTapAuthor,
          child: CircleAvatar(
            radius: 22.r,
            backgroundColor: const Color(0xFF1B2A3A),
            backgroundImage: (author?.hasAvatar ?? false)
                ? NetworkImage(author!.avatar!)
                : null,
            child: (author?.hasAvatar ?? false)
                ? null
                : Icon(Icons.person, size: 22.sp, color: Colors.grey),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: GestureDetector(
            onTap: onTapAuthor,
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author?.name ?? 'N/A',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: const Color(0xFFD2D2D5),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (showMoreMenu)
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            color: const Color(0xFF0A1A29),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onSelected: (value) {
              if (value == 'edit') onEdit?.call();
              if (value == 'delete') onDelete?.call();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, color: Colors.white, size: 18.sp),
                    SizedBox(width: 10.w),
                    Text('Edit', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red, size: 18.sp),
                    SizedBox(width: 10.w),
                    Text('Delete', style: TextStyle(color: Colors.red, fontSize: 14.sp)),
                  ],
                ),
              ),
            ],
          )
        else if (onMore != null)
          IconButton(
            onPressed: onMore,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.more_horiz, color: Colors.white),
          ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final FeedPost post;
  final ValueChanged<String>? onVote;
  final String? votedOptionId;

  const _Body({
    required this.post,
    this.onVote,
    this.votedOptionId,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (post.isPoll && post.pollOptions.isNotEmpty) {
      children.add(
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: _PollBody(
            post: post,
            onVote: onVote,
            votedOptionId: votedOptionId,
          ),
        ),
      );
    }

    final images = post.imageAttachments;
    if (images.isNotEmpty) {
      children.add(
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: _ImageAttachmentsGrid(attachments: images),
        ),
      );
    }

    final videos = post.videoAttachments;
    if (videos.isNotEmpty) {
      children.add(
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: CommunityVideoWidget(videoUrl: videos.first.filePath!),
        ),
      );
    }

    if (children.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _ImageAttachmentsGrid extends StatelessWidget {
  final List<PostAttachment> attachments;

  const _ImageAttachmentsGrid({required this.attachments});

  List<String> get _urls =>
      attachments.map((a) => a.filePath!).where((u) => u.isNotEmpty).toList();

  void _openViewer(BuildContext context, int index) {
    CommunityImageViewer.open(
      context,
      imageUrls: _urls,
      initialIndex: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    final urls = _urls;
    if (urls.isEmpty) return const SizedBox.shrink();

    if (urls.length == 1) {
      return _ImageTile(
        url: urls.first,
        height: 220.h,
        onTap: () => _openViewer(context, 0),
      );
    }

    if (urls.length == 2) {
      return SizedBox(
        height: 180.h,
        child: Row(
          children: [
            Expanded(
              child: _ImageTile(
                url: urls[0],
                onTap: () => _openViewer(context, 0),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(8.r),
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _ImageTile(
                url: urls[1],
                onTap: () => _openViewer(context, 1),
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final visible = urls.take(4).toList();
    final extra = urls.length - visible.length;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: visible.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.h,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final isLastWithMore = extra > 0 && index == visible.length - 1;
        return _ImageTile(
          url: visible[index],
          onTap: () => _openViewer(context, index),
          overlay: isLastWithMore ? '+$extra' : null,
        );
      },
    );
  }
}

class _ImageTile extends StatelessWidget {
  final String url;
  final VoidCallback onTap;
  final double? height;
  final BorderRadius? borderRadius;
  final String? overlay;

  const _ImageTile({
    required this.url,
    required this.onTap,
    this.height,
    this.borderRadius,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        child: SizedBox(
          height: height,
          width: height == null ? double.infinity : null,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ExtendedImage.network(
                url,
                fit: BoxFit.cover,
                cache: true,
                loadStateChanged: (state) {
                  if (state.extendedImageLoadState == LoadState.loading) {
                    return Container(
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: AppColors.activeButtonColor,
                        strokeWidth: 2,
                      ),
                    );
                  }
                  if (state.extendedImageLoadState == LoadState.failed) {
                    return Container(
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 32.sp,
                        color: Colors.grey.shade500,
                      ),
                    );
                  }
                  return null;
                },
              ),
              if (overlay != null)
                Container(
                  color: Colors.black54,
                  alignment: Alignment.center,
                  child: Text(
                    overlay!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PollBody extends StatelessWidget {
  final FeedPost post;
  final ValueChanged<String>? onVote;
  final String? votedOptionId;

  const _PollBody({
    required this.post,
    this.onVote,
    this.votedOptionId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...post.pollOptions.map(
          (option) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _PollOptionTile(
              option: option,
              isSelected: votedOptionId == option.id,
              onTap: onVote == null ? null : () => onVote!(option.id),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          '${post.pollTotalVotes} ${post.pollTotalVotes == 1 ? 'vote' : 'votes'}',
          style: TextStyle(
            color: const Color(0xFFD2D2D5),
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _PollOptionTile extends StatelessWidget {
  final PollOption option;
  final bool isSelected;
  final VoidCallback? onTap;

  const _PollOptionTile({
    required this.option,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white24,
            width: 1.w,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20.sp,
              color: isSelected ? AppColors.activeButtonColor : Colors.white54,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                option.title ?? 'Option',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _VoterAvatars(votes: option.votes, totalVotes: option.totalVotes),
          ],
        ),
      ),
    );
  }
}

class _VoterAvatars extends StatelessWidget {
  final List<PollVote> votes;
  final int totalVotes;

  const _VoterAvatars({required this.votes, required this.totalVotes});

  @override
  Widget build(BuildContext context) {
    if (totalVotes <= 0) return const SizedBox.shrink();

    final displayVotes = votes.take(3).toList();
    const double size = 22;
    const double overlap = 14;

    if (displayVotes.isEmpty) {
      return _DefaultVoterAvatar(size: size);
    }

    return SizedBox(
      height: size.r,
      width: (size + overlap * (displayVotes.length - 1)).r,
      child: Stack(
        children: [
          for (int i = 0; i < displayVotes.length; i++)
            Positioned(
              left: (overlap * i).r,
              child: _DefaultVoterAvatar(
                size: size,
                avatarUrl: displayVotes[i].avatar,
              ),
            ),
        ],
      ),
    );
  }
}

class _DefaultVoterAvatar extends StatelessWidget {
  final double size;
  final String? avatarUrl;

  const _DefaultVoterAvatar({required this.size, this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl != null && avatarUrl!.isNotEmpty;
    return CircleAvatar(
      radius: (size / 2).r,
      backgroundColor: const Color(0xFF1B2A3A),
      backgroundImage: hasAvatar ? NetworkImage(avatarUrl!) : null,
      child: hasAvatar
          ? null
          : Icon(Icons.person, size: 14.sp, color: Colors.grey),
    );
  }
}

class _CountsRow extends StatelessWidget {
  final FeedPost post;

  const _CountsRow({required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          post.isLiked
              ? 'assets/icons/like_icon_red.png'
              : 'assets/icons/like_icon.png',
          width: 18.w,
          height: 18.h,
        ),
        SizedBox(width: 4.w),
        Text(
          '${post.totalLikes}',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          '${post.totalComments} ${post.totalComments == 1 ? 'comment' : 'comments'}',
          style: TextStyle(fontSize: 13.sp, color: Colors.white70),
        ),
        SizedBox(width: 6.w),
        Container(
          width: 3.w,
          height: 3.w,
          decoration: const BoxDecoration(
            color: Color(0xFF3D4566),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          '${post.totalShares} ${post.totalShares == 1 ? 'share' : 'shares'}',
          style: TextStyle(fontSize: 13.sp, color: Colors.white70),
        ),
      ],
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final FeedPost post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const _ActionsRow({
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ActionButton(
          iconPath: post.isLiked
              ? 'assets/icons/like_icon_red.png'
              : 'assets/icons/like_icon.png',
          label: 'Like',
          highlighted: post.isLiked,
          onTap: onLike,
        ),
        _ActionButton(
          iconPath: 'assets/icons/comment_icon.png',
          label: 'Comment',
          onTap: onComment,
        ),
        _ActionButton(
          iconPath: 'assets/icons/share_icon.png',
          label: 'Share',
          onTap: onShare,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool highlighted;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.iconPath,
    required this.label,
    this.highlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        child: Row(
          children: [
            Image.asset(iconPath, width: 22.w, height: 22.h),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: highlighted
                    ? AppColors.activeButtonColor
                    : Colors.white,
                fontWeight: FontWeight.w500,
              ),
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
  if (diff.inSeconds < 60) return 'Just now';
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
