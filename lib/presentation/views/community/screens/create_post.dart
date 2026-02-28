import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/secondary_appber.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController _goalsController = TextEditingController();
  final FocusNode _goalsFocus = FocusNode();

  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _goalsController.addListener(() {
      setState(() {
        _hasText = _goalsController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _goalsController.dispose();
    _goalsFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SecondaryAppBar(title: 'Create Post'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                 SizedBox(height: 10.h),
                Row(
                  children: [
                     CircleAvatar(
                      radius: 20.r,
                      backgroundImage:
                      AssetImage('assets/icons/profile_post_screen.png'),
                      backgroundColor: Colors.blueGrey,
                    ),
                     SizedBox(width: 12.w),
                    const Text(
                      'Sophie Lambert',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding:  EdgeInsets.symmetric(
                          horizontal: 16.h, vertical: 8.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A1A29),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: const Row(
                        children: [
                          Text('Public',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                          Icon(Icons.arrow_drop_down, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildFormSection(
                  '',
                  _buildTextField(
                    "What's on your mind?",
                    controller: _goalsController,
                    maxLines: 5,
                    focusNode: _goalsFocus,
                  ),
                ),
                 SizedBox(height: 16.h),
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/video_icon.png',
                      scale: 2.5.sp,
                    ),
                     SizedBox(width: 10.w),
                    Image.asset(
                      'assets/icons/photo_icons.png',
                      scale: 2.5.sp,
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _hasText
                          ? () {

                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        _hasText ? Color(0xFFE9201D) : const Color(0xFF0A1A29),
                        padding:  EdgeInsets.symmetric(
                            horizontal: 36.h, vertical: 16.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0.r),
                        ),
                      ),
                      child: Text(
                        'Post',
                        style: TextStyle(
                          color: _hasText
                              ? Colors.white
                              : const Color(0xFF3D4566),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildFormSection(String label, Widget child) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
       SizedBox(height: 16.h),
      Text(
        label,
        style: const TextStyle(
          color: Color(0xFF8C9196),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
       SizedBox(height: 8.h),
      child,
    ],
  );
}

Widget _buildTextField(
    String hintText, {
      int? maxLines,
      TextInputType? keyboardType,
      TextEditingController? controller,
      FocusNode? focusNode,
    }) {
  return Stack(
    children: [
      TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding:
           EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide:
             BorderSide(color: Color(0xFF3D4566), width: 1.5.w),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide:
             BorderSide(color: Color(0xFF3D4566), width: 1.5.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide:
             BorderSide(color: Color(0xFF3D4566), width: 1.w),
          ),
        ),
      ),
      Positioned(
        right: 16.r,
        bottom: 16,
        child: Image.asset(
          "assets/icons/happy.png",
          scale: 2.5.sp,
        ),
      ),
    ],
  );
}
