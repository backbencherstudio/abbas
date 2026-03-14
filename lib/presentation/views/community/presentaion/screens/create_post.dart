import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../../../widgets/secondary_appber.dart';
import '../provider/post/create_post_provider.dart'; // Adjust the import path

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _goalsController = TextEditingController();
  final FocusNode _goalsFocus = FocusNode();
  final ImagePicker _imagePicker = ImagePicker();

  bool _hasText = false;
  File? _selectedImage;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    _goalsController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _goalsController.text.isNotEmpty;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _isPickingImage = true;
      });

      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _createPost(CreatePostProvider provider) async {
    if (!_hasText && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add text or image to create a post'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Call the provider method
    final success = await provider.createPost(
      _goalsController.text.trim(),
      _selectedImage,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // Return true to indicate success
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Error creating post'),
          backgroundColor: Colors.red,
        ),
      );
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
    return Consumer<CreatePostProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              SecondaryAppBar(
                title: 'Create Post',
                onEditButtonTap: () {
                  if (_hasText || _selectedImage != null) {
                    _showDiscardDialog(context);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          children: [
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.r,
                                  backgroundImage: const AssetImage(
                                    'assets/icons/profile_post_screen.png',
                                  ),
                                  backgroundColor: Colors.blueGrey,
                                ),
                                SizedBox(width: 12.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Sophie Lambert',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Public',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                // Privacy selector
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0A1A29),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.public,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Public',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 16.h),

                            // Text input field
                            _buildTextField(
                              "What's on your mind?",
                              controller: _goalsController,
                              maxLines: 8,
                              focusNode: _goalsFocus,
                            ),

                            if (_selectedImage != null) ...[
                              SizedBox(height: 16.h),
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 200.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      image: DecorationImage(
                                        image: FileImage(_selectedImage!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: _removeImage,
                                      child: Container(
                                        padding: EdgeInsets.all(4.r),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child:  Icon(
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
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        _buildMediaButton(
                                          icon: 'assets/icons/video_icon.png',
                                          label: 'Video',
                                          onTap: () async {
                                            try {
                                              final XFile? video =
                                                  await _imagePicker.pickVideo(
                                                    source: ImageSource.gallery,
                                                    maxDuration: const Duration(
                                                      minutes: 5,
                                                    ),
                                                  );

                                              if (video != null && mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Video selected: ${video.name}',
                                                    ),
                                                    duration: const Duration(
                                                      seconds: 2,
                                                    ),
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              if (mounted) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Error picking video: $e',
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                        SizedBox(width: 10.w),
                                        _buildMediaButton(
                                          icon: 'assets/icons/photo_icons.png',
                                          label: 'Photo',
                                          onTap: _showImageSourceDialog,
                                        ),
                                        // const Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed:
                                              (_hasText ||
                                                      _selectedImage != null) &&
                                                  !provider.isLoading
                                              ? () => _createPost(provider)
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFFE9201D,
                                            ),
                                            disabledBackgroundColor:
                                                Colors.grey[300],
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 14.h,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: Text(
                                            'Post',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20.h),

                            // Character count
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${_goalsController.text.length}/500',
                                style: TextStyle(
                                  color: _goalsController.text.length > 500
                                      ? Colors.red
                                      : Colors.grey,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),

                            // Show error message if any
                            if (provider.errorMessage != null) ...[
                              SizedBox(height: 16.h),
                              Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
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

                    // Loading overlay
                    if (provider.isLoading || _isPickingImage)
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFE9201D),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  _isPickingImage
                                      ? 'Loading image...'
                                      : 'Creating post...',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Bottom bar with post button
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(
            icon,
            width: 15.w,
            height: 15.w,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                // width: 24.w,
                // height: 24.w,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 16),
              );
            },
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
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
