import 'package:abbas/presentation/views/profile/view_model/profil_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../presentaion/provider/community/community_screen_provider.dart';

class CommentBottomSheet extends StatefulWidget {
  final String postId;

  const CommentBottomSheet({super.key, required this.postId});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();

  String? _replyingToCommentId;
  String? _replyingToUserName;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CommunityScreenProvider>().getComment(widget.postId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  /// ---------------------------- submit comment --------------------------
  Future<void> _submitComment(CommunityScreenProvider provider) async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    provider.setIsSubmitting(true);

    await provider.createComment(widget.postId, text);
    _commentController.clear();
    await provider.getComment(widget.postId);

    if (mounted) {
      provider.setIsSubmitting(false);
    }
  }

  /// ---------------------------- submit reply --------------------------
  Future<void> _submitReply(CommunityScreenProvider provider) async {
    if (_replyingToCommentId == null) return;

    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    provider.setIsSubmitting(true);

    await provider.replyComment(widget.postId, _replyingToCommentId!, text);
    _commentController.clear();
    _cancelReply();
    await provider.getComment(widget.postId);

    if (mounted) {
      provider.setIsSubmitting(false);
    }
  }

  /// ---------------------------- cancel reply --------------------------
  void _cancelReply() {
    setState(() {
      _replyingToCommentId = null;
      _replyingToUserName = null;
    });
  }

  /// ---------------------------- time ago --------------------------
  String _timeAgo(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return 'N/A';
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      final diff = DateTime.now().difference(dateTime);
      if (diff.inSeconds < 60) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (_) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Consumer<CommunityScreenProvider>(
      builder: (context, provider, child) {
        final profileProvider = context.read<ProfileScreenProvider>();
        final comments = provider.comments;
        final isLoading = provider.isLoadingComments;

        return Container(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 16.h,
            bottom: bottomPadding + 24.h,
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          decoration: BoxDecoration(
            color: const Color(0xff0A1A2A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// --------------------- Drag handle ---------------------
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              /// --------------------- Title ---------------------
              Text(
                'Comments',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),

              /// --------------------- Comment list ---------------------
              Flexible(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : comments.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: Text(
                            'No comments yet. Be the first!',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: comments.length,
                        separatorBuilder: (_, _) => Divider(
                          color: const Color(0xFF202C43),
                          height: 1.h,
                        ),
                        itemBuilder: (context, index) {
                          final comment = comments[index];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Main comment
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 18.r,
                                      backgroundImage:
                                          (comment.user?.avatar != null &&
                                              comment.user!.avatar!.isNotEmpty)
                                          ? NetworkImage(comment.user!.avatar!)
                                          : null,
                                      backgroundColor: const Color(0xFF1E2D3D),
                                      child:
                                          (comment.user?.avatar == null ||
                                              comment.user!.avatar!.isEmpty)
                                          ? Icon(
                                              Icons.person,
                                              size: 18.sp,
                                              color: Colors.grey,
                                            )
                                          : null,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment.user?.name ?? 'Unknown',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            comment.content ?? '',
                                            style: TextStyle(
                                              color: const Color(0xFFD2D2D5),
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          Row(
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _replyingToCommentId =
                                                        comment.id;
                                                    _replyingToUserName =
                                                        comment.user?.name ??
                                                        'User';
                                                  });
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  minimumSize: Size.zero,
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                child: Text(
                                                  "Reply",
                                                  style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                              ),
                                              if (comment.replies != null &&
                                                  comment
                                                      .replies!
                                                      .isNotEmpty) ...[
                                                SizedBox(width: 12.w),
                                                Text(
                                                  '${comment.replies!.length} replies',
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 11.sp,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      _timeAgo(comment.createdAt),
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// Replies section
                              if (comment.replies != null &&
                                  comment.replies!.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(left: 28.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: comment.replies!.map((reply) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8.h,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 14.r,
                                              backgroundImage:
                                                  (reply.user?.avatar != null &&
                                                      reply
                                                          .user!
                                                          .avatar!
                                                          .isNotEmpty)
                                                  ? NetworkImage(
                                                      reply.user!.avatar!,
                                                    )
                                                  : null,
                                              backgroundColor: const Color(
                                                0xFF1E2D3D,
                                              ),
                                              child:
                                                  (reply.user?.avatar == null ||
                                                      reply
                                                          .user!
                                                          .avatar!
                                                          .isEmpty)
                                                  ? Icon(
                                                      Icons.person,
                                                      size: 14.sp,
                                                      color: Colors.grey,
                                                    )
                                                  : null,
                                            ),
                                            SizedBox(width: 8.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        reply.user?.name ??
                                                            'Unknown',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(width: 6.w),
                                                      Text(
                                                        _timeAgo(
                                                          reply.createdAt,
                                                        ),
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[500],
                                                          fontSize: 10.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Text(
                                                    reply.content ?? '',
                                                    style: TextStyle(
                                                      color: const Color(
                                                        0xFFD2D2D5,
                                                      ),
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
              ),

              SizedBox(height: 12.h),
              Divider(color: const Color(0xFF202C43), height: 1.h),
              SizedBox(height: 12.h),

              /// ------------------- Input row -------------------
              Row(
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundImage:
                        (profileProvider.profile?.data?.avatar != null &&
                            profileProvider.profile!.data!.avatar!.isNotEmpty)
                        ? NetworkImage(profileProvider.profile!.data!.avatar!)
                        : null,
                    backgroundColor: const Color(0xFF1E2D3D),
                    child:
                        (profileProvider.profile?.data?.avatar == null ||
                            profileProvider.profile!.data!.avatar!.isEmpty)
                        ? Icon(Icons.person, size: 18.sp, color: Colors.grey)
                        : null,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: _replyingToUserName != null
                            ? 'Reply to $_replyingToUserName...'
                            : 'Write a comment...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: const Color(0xFF1E2D3D),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: provider.isSubmitting
                        ? null
                        : (_replyingToCommentId != null
                              ? () => _submitReply(provider)
                              : () => _submitComment(provider)),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: provider.isSubmitting
                            ? Colors.blueAccent.withValues(alpha: 0.5)
                            : Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: provider.isSubmitting
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(Icons.send, color: Colors.white, size: 20.sp),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
