import 'dart:io';

import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_feed_provider.dart';
import 'package:abbas/presentation/views/profile/view_model/profile_screen_provider.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

enum PostMediaType { image, video }

class PostMediaItem {
  final String id;
  final File file;
  final PostMediaType type;

  const PostMediaItem({
    required this.id,
    required this.file,
    required this.type,
  });

  String get fileName => p.basename(file.path);
}

class CreatePost extends ConsumerStatefulWidget {
  const CreatePost({super.key});

  @override
  ConsumerState<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends ConsumerState<CreatePost> {
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _contentFocus = FocusNode();
  final ImagePicker _picker = ImagePicker();

  final List<PostMediaItem> _attachments = [];
  String _visibility = 'PUBLIC';
  bool _isPicking = false;
  bool _isUploading = false;
  double _uploadProgress = 0;

  static const int _maxAttachments = 10;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleInitialIntent());
  }

  void _handleInitialIntent() {
    if (!mounted) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == 'photo') {
      _showImageSourceSheet();
    } else if (args == 'video') {
      _showVideoSourceSheet();
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  bool get _hasContent => _contentController.text.trim().isNotEmpty;

  bool get _hasAttachments => _attachments.isNotEmpty;

  bool get _canPost =>
      !_isUploading && !_isPicking && (_hasContent || _hasAttachments);

  int get _remainingSlots => _maxAttachments - _attachments.length;

  Future<bool> _confirmDiscard() async {
    if (!_hasContent && !_hasAttachments) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0A1A29),
        title: const Text('Discard post?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Your draft will be lost.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _showImageSourceSheet() async {
    if (_isUploading || _remainingSlots <= 0) {
      if (_remainingSlots <= 0) _showLimitToast();
      return;
    }

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF0A1A29),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
              child: Text(
                'Add photos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text(
                'Choose from gallery',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera, color: Colors.white),
              title: const Text(
                'Take a photo',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;
    await _pickImages(source);
  }

  Future<void> _showVideoSourceSheet() async {
    if (_isUploading || _remainingSlots <= 0) {
      if (_remainingSlots <= 0) _showLimitToast();
      return;
    }

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF0A1A29),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
              child: Text(
                'Add video',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.video_library, color: Colors.white),
              title: const Text(
                'Choose from gallery',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.videocam, color: Colors.white),
              title: const Text(
                'Record video',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;
    await _pickVideo(source);
  }

  void _showLimitToast() {
    Utils.showToast(
      msg: 'You can attach up to $_maxAttachments files',
      backgroundColor: AppColors.cardBackground,
      textColor: Colors.white,
    );
  }

  Future<void> _pickImages(ImageSource source) async {
    setState(() => _isPicking = true);
    try {
      if (source == ImageSource.gallery) {
        final picked = await _picker.pickMultiImage(imageQuality: 85);
        if (picked.isEmpty) return;

        final toAdd = picked.take(_remainingSlots).map((x) {
          return PostMediaItem(
            id: '${DateTime.now().microsecondsSinceEpoch}_${x.path.hashCode}',
            file: File(x.path),
            type: PostMediaType.image,
          );
        }).toList();

        setState(() => _attachments.addAll(toAdd));
        if (picked.length > _remainingSlots) _showLimitToast();
      } else {
        final picked = await _picker.pickImage(
          source: source,
          imageQuality: 85,
        );
        if (picked != null) {
          setState(() {
            _attachments.add(
              PostMediaItem(
                id: '${DateTime.now().microsecondsSinceEpoch}_${picked.path.hashCode}',
                file: File(picked.path),
                type: PostMediaType.image,
              ),
            );
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      Utils.showToast(
        msg: 'Could not pick image: $e',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    setState(() => _isPicking = true);
    try {
      final picked = await _picker.pickVideo(source: source);
      if (picked != null) {
        setState(() {
          _attachments.add(
            PostMediaItem(
              id: '${DateTime.now().microsecondsSinceEpoch}_${picked.path.hashCode}',
              file: File(picked.path),
              type: PostMediaType.video,
            ),
          );
        });
      }
    } catch (e) {
      if (!mounted) return;
      Utils.showToast(
        msg: 'Could not pick video: $e',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  void _removeAttachment(int index) {
    setState(() => _attachments.removeAt(index));
  }

  Future<void> _submitPost() async {
    if (!_canPost || _isUploading) return;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });

    final error = await ref.read(communityFeedProvider.notifier).createPost(
          content: _contentController.text,
          visibility: _visibility,
          attachments: _attachments.map((a) => a.file).toList(),
          onUploadProgress: (progress) {
            if (!mounted) return;
            setState(() => _uploadProgress = progress.clamp(0.0, 1.0));
          },
        );

    if (!mounted) return;
    setState(() {
      _isUploading = false;
      _uploadProgress = 0;
    });

    if (error != null) {
      Utils.showToast(
        msg: error,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    Utils.showToast(
      msg: 'Post created successfully',
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileScreenProvider>();
    final authorImage = profile.profile?.data?.avatar;
    final authorName = profile.profile?.data?.name ?? '';

    return PopScope(
      canPop: !_isUploading,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || _isUploading) return;
        if (await _confirmDiscard()) {
          if (context.mounted) Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            Column(
              children: [
                SecondaryAppBar(
                  title: 'Create Post',
                  onBack: _isUploading
                      ? () {}
                      : () async {
                          if (await _confirmDiscard()) {
                            if (context.mounted) Navigator.pop(context);
                          }
                        },
                  trailing: _PostButton(
                    enabled: _canPost,
                    isUploading: _isUploading,
                    onPressed: _submitPost,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AuthorRow(
                          authorImage: authorImage,
                          authorName: authorName,
                          visibility: _visibility,
                          onVisibilityChanged: (v) =>
                              setState(() => _visibility = v),
                        ),
                        SizedBox(height: 16.h),
                        _ContentField(
                          controller: _contentController,
                          focusNode: _contentFocus,
                          enabled: !_isUploading,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Add text, photos, or videos — at least one is required.',
                          style: TextStyle(
                            color: const Color(0xFF8B93A8),
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        _AttachmentsSection(
                          attachments: _attachments,
                          isPicking: _isPicking,
                          enabled: !_isUploading,
                          onRemove: _removeAttachment,
                          onAddPhoto: _showImageSourceSheet,
                          onAddVideo: _showVideoSourceSheet,
                        ),
                      ],
                    ),
                  ),
                ),
                _BottomToolbar(
                  enabled: !_isUploading && !_isPicking,
                  isPicking: _isPicking,
                  onPhoto: _showImageSourceSheet,
                  onVideo: _showVideoSourceSheet,
                ),
              ],
            ),
            if (_isUploading) _UploadOverlay(progress: _uploadProgress),
          ],
        ),
      ),
    );
  }
}

class _PostButton extends StatelessWidget {
  final bool enabled;
  final bool isUploading;
  final VoidCallback onPressed;

  const _PostButton({
    required this.enabled,
    required this.isUploading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: TextButton(
        onPressed: enabled && !isUploading ? onPressed : null,
        style: TextButton.styleFrom(
          backgroundColor: enabled
              ? const Color(0xFFE9201D)
              : const Color(0xFF3D4566),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Text(
          'Post',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _ContentField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;

  const _ContentField({
    required this.controller,
    required this.focusNode,
    required this.enabled,
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
        focusNode: focusNode,
        enabled: enabled,
        maxLines: 6,
        minLines: 4,
        maxLength: 500,
        buildCounter: (context,
                {required currentLength, required isFocused, maxLength}) =>
            Padding(
          padding: EdgeInsets.only(right: 12.w, bottom: 8.h),
          child: Text(
            '$currentLength / $maxLength',
            style: TextStyle(color: Colors.white38, fontSize: 11.sp),
          ),
        ),
        style: TextStyle(color: Colors.white, fontSize: 15.sp, height: 1.4),
        decoration: InputDecoration(
          hintText: "What's on your mind?",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15.sp),
          contentPadding: EdgeInsets.all(16.w),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _AttachmentsSection extends StatelessWidget {
  final List<PostMediaItem> attachments;
  final bool isPicking;
  final bool enabled;
  final ValueChanged<int> onRemove;
  final VoidCallback onAddPhoto;
  final VoidCallback onAddVideo;

  const _AttachmentsSection({
    required this.attachments,
    required this.isPicking,
    required this.enabled,
    required this.onRemove,
    required this.onAddPhoto,
    required this.onAddVideo,
  });

  int get _imageCount =>
      attachments.where((a) => a.type == PostMediaType.image).length;

  int get _videoCount =>
      attachments.where((a) => a.type == PostMediaType.video).length;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Attachments',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (attachments.isNotEmpty) ...[
              SizedBox(width: 8.w),
              Text(
                '(${attachments.length})',
                style: TextStyle(color: Colors.white54, fontSize: 14.sp),
              ),
            ],
            const Spacer(),
            if (isPicking)
              SizedBox(
                width: 18.w,
                height: 18.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.activeButtonColor,
                ),
              ),
          ],
        ),
        if (attachments.isNotEmpty) ...[
          SizedBox(height: 6.h),
          Text(
            [
              if (_imageCount > 0)
                '$_imageCount photo${_imageCount == 1 ? '' : 's'}',
              if (_videoCount > 0)
                '$_videoCount video${_videoCount == 1 ? '' : 's'}',
            ].join(' · '),
            style: TextStyle(color: Colors.white54, fontSize: 12.sp),
          ),
        ],
        SizedBox(height: 12.h),
        if (attachments.isEmpty)
          _EmptyAttachmentsHint(
            enabled: enabled,
            onAddPhoto: onAddPhoto,
            onAddVideo: onAddVideo,
          )
        else
          _AttachmentsGrid(
            attachments: attachments,
            enabled: enabled,
            onRemove: onRemove,
            onAddPhoto: onAddPhoto,
            onAddVideo: onAddVideo,
          ),
      ],
    );
  }
}

class _EmptyAttachmentsHint extends StatelessWidget {
  final bool enabled;
  final VoidCallback onAddPhoto;
  final VoidCallback onAddVideo;

  const _EmptyAttachmentsHint({
    required this.enabled,
    required this.onAddPhoto,
    required this.onAddVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A29),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3D4566)),
      ),
      child: Column(
        children: [
          Icon(Icons.perm_media_outlined, color: Colors.white38, size: 40.sp),
          SizedBox(height: 10.h),
          Text(
            'No media attached',
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AddMediaChip(
                icon: 'assets/icons/photo.png',
                label: 'Photo',
                enabled: enabled,
                onTap: onAddPhoto,
              ),
              SizedBox(width: 12.w),
              _AddMediaChip(
                icon: 'assets/icons/video.png',
                label: 'Video',
                enabled: enabled,
                onTap: onAddVideo,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddMediaChip extends StatelessWidget {
  final String icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _AddMediaChip({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xFF0E1B27),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: const Color(0xFF3D4566)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(icon, width: 20.w, height: 20.h),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(color: Colors.white, fontSize: 13.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentsGrid extends StatelessWidget {
  final List<PostMediaItem> attachments;
  final bool enabled;
  final ValueChanged<int> onRemove;
  final VoidCallback onAddPhoto;
  final VoidCallback onAddVideo;

  const _AttachmentsGrid({
    required this.attachments,
    required this.enabled,
    required this.onRemove,
    required this.onAddPhoto,
    required this.onAddVideo,
  });

  @override
  Widget build(BuildContext context) {
    const maxItems = 10;
    final canAddMore = enabled && attachments.length < maxItems;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attachments.length + (canAddMore ? 1 : 0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        if (canAddMore && index == attachments.length) {
          return _AddMoreTile(onAddPhoto: onAddPhoto, onAddVideo: onAddVideo);
        }
        return _AttachmentTile(
          item: attachments[index],
          enabled: enabled,
          onRemove: () => onRemove(index),
        );
      },
    );
  }
}

class _AddMoreTile extends StatelessWidget {
  final VoidCallback onAddPhoto;
  final VoidCallback onAddVideo;

  const _AddMoreTile({
    required this.onAddPhoto,
    required this.onAddVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0A1A29),
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: () => _showAddSheet(context),
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFF3D4566), width: 1.2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white54, size: 28.sp),
              SizedBox(height: 4.h),
              Text('Add', style: TextStyle(color: Colors.white54, fontSize: 12.sp)),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0A1A29),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Image.asset('assets/icons/photo.png', width: 24.w),
              title: const Text('Add photo', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                onAddPhoto();
              },
            ),
            ListTile(
              leading: Image.asset('assets/icons/video.png', width: 24.w),
              title: const Text('Add video', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                onAddVideo();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  final PostMediaItem item;
  final bool enabled;
  final VoidCallback onRemove;

  const _AttachmentTile({
    required this.item,
    required this.enabled,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isVideo = item.type == PostMediaType.video;

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: isVideo
              ? ColoredBox(
                  color: const Color(0xFF0E1B27),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_fill,
                        color: Colors.white70,
                        size: 36.sp,
                      ),
                      SizedBox(height: 6.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Text(
                          item.fileName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Image.file(item.file, fit: BoxFit.cover),
        ),
        if (isVideo)
          Positioned(
            left: 6,
            bottom: 6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                'VIDEO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if (enabled)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: Colors.white, size: 16.sp),
              ),
            ),
          ),
      ],
    );
  }
}

class _BottomToolbar extends StatelessWidget {
  final bool enabled;
  final bool isPicking;
  final VoidCallback onPhoto;
  final VoidCallback onVideo;

  const _BottomToolbar({
    required this.enabled,
    required this.isPicking,
    required this.onPhoto,
    required this.onVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      decoration: const BoxDecoration(
        color: Color(0xFF0A1A29),
        border: Border(top: BorderSide(color: Color(0xFF202C43))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _ToolbarButton(
              icon: 'assets/icons/photo.png',
              label: 'Photo',
              enabled: enabled,
              onTap: onPhoto,
            ),
            SizedBox(width: 12.w),
            _ToolbarButton(
              icon: 'assets/icons/video.png',
              label: 'Video',
              enabled: enabled,
              onTap: onVideo,
            ),
            const Spacer(),
            if (isPicking)
              SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.activeButtonColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final String icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: const Color(0xFF0E1B27),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Image.asset(icon, width: 22.w, height: 22.h),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.greyTextColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadOverlay extends StatelessWidget {
  final double progress;

  const _UploadOverlay({required this.progress});

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).clamp(0, 100).toInt();

    return AbsorbPointer(
      child: Container(
        color: Colors.black.withValues(alpha: 0.72),
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
          decoration: BoxDecoration(
            color: const Color(0xFF0A1A29),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFF3D4566)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48.w,
                height: 48.w,
                child: CircularProgressIndicator(
                  value: progress > 0 ? progress : null,
                  strokeWidth: 4,
                  color: AppColors.activeButtonColor,
                  backgroundColor: const Color(0xFF3D4566),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                progress > 0 ? 'Uploading… $percent%' : 'Preparing upload…',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Large videos may take a while.\nPlease keep the app open.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 13.sp),
              ),
              if (progress > 0) ...[
                SizedBox(height: 20.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6.h,
                    color: AppColors.activeButtonColor,
                    backgroundColor: const Color(0xFF3D4566),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  final String? authorImage;
  final String authorName;
  final String visibility;
  final ValueChanged<String> onVisibilityChanged;

  const _AuthorRow({
    required this.authorImage,
    required this.authorName,
    required this.visibility,
    required this.onVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasAvatar = authorImage != null && authorImage!.isNotEmpty;

    return Row(
      children: [
        CircleAvatar(
          radius: 22.r,
          backgroundColor: const Color(0xFF1B2A3A),
          backgroundImage: hasAvatar ? NetworkImage(authorImage!) : null,
          child: hasAvatar
              ? null
              : Icon(Icons.person, size: 22.sp, color: Colors.grey),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Text(
                'Sharing as ${visibility.toLowerCase()}',
                style: TextStyle(color: Colors.white54, fontSize: 12.sp),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          initialValue: visibility,
          color: const Color(0xFF0A1A29),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          onSelected: onVisibilityChanged,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'PUBLIC',
              child: Row(
                children: [
                  Icon(Icons.public, size: 18.sp, color: Colors.white),
                  SizedBox(width: 8.w),
                  const Text('PUBLIC', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'PRIVATE',
              child: Row(
                children: [
                  Icon(Icons.lock, size: 18.sp, color: Colors.white),
                  SizedBox(width: 8.w),
                  const Text('PRIVATE', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1A29),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFF3D4566)),
            ),
            child: Row(
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
                Icon(Icons.arrow_drop_down, color: Colors.white, size: 18.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
