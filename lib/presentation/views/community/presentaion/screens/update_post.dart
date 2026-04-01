import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_screen_provider.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:abbas/cors/network/api_response_model.dart';
import '../../../profile/view_model/profil_screen_provider.dart';

class UpdatePost extends StatefulWidget {
  final String postId;
  final String postContent;
  const UpdatePost({
    super.key,
    required this.postId,
    required this.postContent,
  });

  @override
  State<UpdatePost> createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  final TextEditingController _goalsController = TextEditingController();
  final FocusNode _goalsFocus = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();

  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _goalsController.addListener(_onTextChanged);
    _goalsController.text = widget.postContent;
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _goalsController.text.isNotEmpty;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      context.read<CommunityScreenProvider>().setIsPickingImage(true);

      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image != null) {
        context.read<CommunityScreenProvider>().setSelectedMedia(
          File(image.path),
          'PHOTO',
        );
      }
    } catch (e) {
      if (mounted) {
        Utils.showToast(
          msg: 'Error picking image: $e',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } finally {
      if (mounted) {
        context.read<CommunityScreenProvider>().setIsPickingImage(false);
      }
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    try {
      context.read<CommunityScreenProvider>().setIsPickingImage(true);

      final XFile? video = await _imagePicker.pickVideo(source: source);

      if (video != null) {
        context.read<CommunityScreenProvider>().setSelectedMedia(
          File(video.path),
          'VIDEO',
        );
      }
    } catch (e) {
      if (mounted) {
        Utils.showToast(
          msg: 'Error picking video: $e',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } finally {
      if (mounted) {
        context.read<CommunityScreenProvider>().setIsPickingImage(false);
      }
    }
  }

  void _removeMedia() {
    context.read<CommunityScreenProvider>().removeMedia();
  }

  Future<void> _updatePost(CommunityScreenProvider provider) async {
    if (!_hasText && provider.selectedMedia == null) {
      Utils.showToast(
        msg: 'Please add text or media',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Call the provider method
    final response = await provider.updatePost(
      widget.postId,
      _goalsController.text.trim(),
      provider.selectedMedia,
    );

    if (mounted) {
      if (response is ApiResponseModel && response.success) {
        Utils.showToast(
          msg: 'Post created successfully',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.pop(context, true);
      } else {
        String msg = 'Failed to create post';
        if (response is ApiResponseModel) {
          msg = response.message;
        } else if (response is String) {
          msg = response;
        }

        Utils.showToast(
          msg: msg,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  void dispose() {
    _goalsController.removeListener(_onTextChanged);
    _goalsController.dispose();
    _goalsFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileScreenProvider>(context);
    final authorImage = profileProvider.profile?.data?.avatar;
    final authorName = profileProvider.profile?.data?.name ?? '';
    return Consumer<CommunityScreenProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              SecondaryAppBar(title: 'Edit Post'),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),

                      /// ---------------- Author Info -------------------------
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.r),
                              border: Border.all(color: Color(0xFF5F6CA0)),
                            ),
                            child: CircleAvatar(
                              radius: 20.r,
                              backgroundImage: NetworkImage(authorImage ?? ''),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            authorName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          PopupMenuButton<String>(
                            initialValue: provider.privacy,
                            color: const Color(0xFF0A1A29),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            onSelected: (String newValue) {
                              provider.setPrivacy(newValue);
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'PUBLIC',
                                    child: Text(
                                      'PUBLIC',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'FRIENDS',
                                    child: Text(
                                      'FRIENDS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'ONLY ME',
                                    child: Text(
                                      'ONLY ME',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0A1A29),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    provider.privacy == 'PUBLIC'
                                        ? Icons.public
                                        : provider.privacy == 'FRIENDS'
                                        ? Icons.group
                                        : Icons.lock,
                                    color: Colors.white,
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    provider.privacy,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                    size: 16.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      /// ------------- Text input field -----------------------
                      _buildTextField(
                        "What's on your mind?",
                        controller: _goalsController,
                        maxLines: 8,
                        focusNode: _goalsFocus,
                      ),

                      if (provider.selectedMedia != null) ...[
                        SizedBox(height: 16.h),
                        Stack(
                          children: [
                            if (provider.mediaType == 'PHOTO')
                              Container(
                                width: double.infinity,
                                height: 200.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  image: DecorationImage(
                                    image: FileImage(provider.selectedMedia!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            else
                              Container(
                                width: double.infinity,
                                height: 200.h,
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.video_file,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Video Selected',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: _removeMedia,
                                child: Container(
                                  padding: EdgeInsets.all(4.r),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      SizedBox(height: 20.h),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                _buildMediaButton(
                                  icon: 'assets/icons/video.png',
                                  onTap: () => _pickVideo(ImageSource.gallery),
                                ),
                                SizedBox(width: 10.w),
                                _buildMediaButton(
                                  icon: 'assets/icons/photo.png',
                                  onTap: () => _pickImage(ImageSource.gallery),
                                ),
                                // const Spacer(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed:
                                      (_hasText ||
                                              provider.selectedMedia != null) &&
                                          !provider.isLoading
                                      ? () => _updatePost(provider)
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(95.w, 48.h),
                                    backgroundColor: const Color(0xFFE9201D),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Post',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Show error message if any
                      if (provider.errorMessage != null) ...[
                        SizedBox(height: 16.h),
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: Colors.red),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 20,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  provider.errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaButton({
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Color(0xFF0E1B27),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Image.asset(icon, width: 24.w, height: 24.h),
      ),
    );
  }

  Widget _buildTextField(
    String hintText, {
    int? maxLines,
    TextEditingController? controller,
    FocusNode? focusNode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF05111C),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xFF3D4566)),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxLines,
        maxLength: 500,
        buildCounter:
            (context, {required currentLength, required isFocused, maxLength}) {
              return null; // Hide default counter
            },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
          contentPadding: EdgeInsets.all(16.w),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  void _showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Discard Post?'),
          content: const Text(
            'You have unsaved changes. Are you sure you want to discard this post?',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );
  }
}
