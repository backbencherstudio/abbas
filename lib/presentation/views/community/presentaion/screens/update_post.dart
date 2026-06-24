import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/community/model/community_feed_model.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_feed_provider.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_profile_provider.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/edit_post_provider.dart';
import 'package:abbas/presentation/views/profile/view_model/profile_screen_provider.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart' as legacy_provider;

class UpdatePost extends ConsumerStatefulWidget {
  final FeedPost post;
  final String? userId;

  const UpdatePost({super.key, required this.post, this.userId});

  @override
  ConsumerState<UpdatePost> createState() => _UpdatePostState();
}

class _UpdatePostState extends ConsumerState<UpdatePost> {
  late final TextEditingController _contentController;
  late String _visibility;

  final List<TextEditingController> _optionControllers = [];
  static const int _minOptions = 2;
  static const int _maxOptions = 8;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.post.content ?? '');
    _contentController.addListener(_onFormChanged);
    _visibility = _visibilityFromPost(widget.post.visibility);

    if (widget.post.isPoll) {
      for (final option in widget.post.pollOptions) {
        final controller = TextEditingController(text: option.title ?? '');
        controller.addListener(_onFormChanged);
        _optionControllers.add(controller);
      }
      while (_optionControllers.length < _minOptions) {
        final controller = TextEditingController();
        controller.addListener(_onFormChanged);
        _optionControllers.add(controller);
      }
    }
  }

  void _onFormChanged() => setState(() {});

  String _visibilityFromPost(PostVisibility visibility) {
    switch (visibility) {
      case PostVisibility.public:
        return 'PUBLIC';
      case PostVisibility.private:
        return 'PRIVATE';
      case PostVisibility.unknown:
        return 'PUBLIC';
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _canSave {
    if (_contentController.text.trim().isEmpty) return false;
    if (!widget.post.isPoll) return true;
    final filled = _optionControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .length;
    return filled >= _minOptions;
  }

  void _addOption() {
    if (_optionControllers.length >= _maxOptions) {
      Utils.showToast(
        msg: 'You can add up to $_maxOptions options',
        backgroundColor: AppColors.cardBackground,
        textColor: Colors.white,
      );
      return;
    }
    setState(() {
      final controller = TextEditingController();
      controller.addListener(_onFormChanged);
      _optionControllers.add(controller);
    });
  }

  void _removeOption(int index) {
    if (_optionControllers.length <= _minOptions) return;
    setState(() {
      _optionControllers[index].dispose();
      _optionControllers.removeAt(index);
    });
  }

  Future<void> _save() async {
    if (!_canSave) {
      Utils.showToast(
        msg: widget.post.isPoll
            ? 'Enter a question and at least two options'
            : 'Please enter post content',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final notifier = ref.read(editPostProvider.notifier);
    final result = widget.post.isPoll
        ? await notifier.updatePoll(
            postId: widget.post.id,
            content: _contentController.text,
            visibility: _visibility,
            pollOptions:
                _optionControllers.map((c) => c.text).toList(growable: false),
            previous: widget.post,
          )
        : await notifier.updatePost(
            postId: widget.post.id,
            content: _contentController.text,
            visibility: _visibility,
            previous: widget.post,
          );

    if (!mounted) return;

    if (result.error != null) {
      Utils.showToast(
        msg: result.error!,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final updated = result.post;
    if (updated != null) {
      ref.read(communityFeedProvider.notifier).replacePost(updated);
      final userId = widget.userId;
      if (userId != null && userId.isNotEmpty) {
        ref.read(communityProfileProvider(userId).notifier).replacePost(updated);
      }
    }

    Utils.showToast(
      msg: 'Post updated successfully',
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(editPostProvider).isSaving;
    final profile = legacy_provider.Provider.of<ProfileScreenProvider>(context);
    final authorImage = profile.profile?.data?.avatar;
    final authorName = profile.profile?.data?.name ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SecondaryAppBar(title: widget.post.isPoll ? 'Edit Poll' : 'Edit Post'),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AuthorRow(
                    authorImage: authorImage,
                    authorName: authorName,
                    visibility: _visibility,
                    enabled: !isSaving,
                    onVisibilityChanged: (v) => setState(() => _visibility = v),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    widget.post.isPoll ? 'Poll Question' : 'Content',
                    style: TextStyle(
                      color: const Color(0xffB2B5B8),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _TextArea(
                    controller: _contentController,
                    hintText: widget.post.isPoll
                        ? 'Ask a question...'
                        : "What's on your mind?",
                    enabled: !isSaving,
                    maxLines: widget.post.isPoll ? 4 : 8,
                  ),
                  if (widget.post.isPoll) ...[
                    SizedBox(height: 20.h),
                    Text(
                      'Poll Options',
                      style: TextStyle(
                        color: const Color(0xffB2B5B8),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    ...List.generate(_optionControllers.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: _TextArea(
                                controller: _optionControllers[index],
                                hintText: 'Option ${index + 1}',
                                enabled: !isSaving,
                                maxLines: 1,
                              ),
                            ),
                            if (_optionControllers.length > _minOptions) ...[
                              SizedBox(width: 8.w),
                              IconButton(
                                onPressed:
                                    isSaving ? null : () => _removeOption(index),
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white54,
                                  size: 20.sp,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                    if (_optionControllers.length < _maxOptions)
                      TextButton.icon(
                        onPressed: isSaving ? null : _addOption,
                        icon: Icon(Icons.add, color: Colors.white, size: 18.sp),
                        label: Text(
                          'Add option',
                          style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        ),
                      ),
                  ],
                  SizedBox(height: 28.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: !isSaving && _canSave ? _save : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE9201D),
                        disabledBackgroundColor: const Color(0xFFE9201D).withValues(alpha: 0.4),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: isSaving
                          ? SizedBox(
                              height: 22.h,
                              width: 22.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  final String? authorImage;
  final String authorName;
  final String visibility;
  final bool enabled;
  final ValueChanged<String> onVisibilityChanged;

  const _AuthorRow({
    required this.authorImage,
    required this.authorName,
    required this.visibility,
    required this.enabled,
    required this.onVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasAvatar = authorImage != null && authorImage!.isNotEmpty;

    return Row(
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: const Color(0xFF1B2A3A),
          backgroundImage: hasAvatar ? NetworkImage(authorImage!) : null,
          child: hasAvatar
              ? null
              : Icon(Icons.person, color: Colors.grey, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            authorName,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        PopupMenuButton<String>(
          enabled: enabled,
          initialValue: visibility,
          color: const Color(0xFF0A1A29),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          onSelected: onVisibilityChanged,
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'PUBLIC', child: Text('PUBLIC', style: TextStyle(color: Colors.white))),
            PopupMenuItem(value: 'PRIVATE', child: Text('PRIVATE', style: TextStyle(color: Colors.white))),
          ],
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1A29),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  visibility == 'PUBLIC' ? Icons.public : Icons.lock,
                  color: Colors.white,
                  size: 16.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  visibility,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.white, size: 16.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TextArea extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final int maxLines;

  const _TextArea({
    required this.controller,
    required this.hintText,
    required this.enabled,
    this.maxLines = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF05111C),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3D4566)),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        maxLength: 500,
        buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
          contentPadding: EdgeInsets.all(16.w),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
