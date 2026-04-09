import 'dart:io';

import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_screen_provider.dart';
import 'package:abbas/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/primary_button.dart';
import '../../../../widgets/secondary_appber.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  /// -------------------- Image Picker ----------------------------------------
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickerImage() async {
    try {
      context.read<CommunityScreenProvider>().setIsPickingImage(true);
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        imageQuality: 85,
      );

      if (pickedImage != null) {
        context.read<CommunityScreenProvider>().setImagePicked(
          File(pickedImage.path),
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        Utils.showToast(
          msg: 'Error picking image: $e',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } finally {
      context.read<CommunityScreenProvider>().setIsPickingImage(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF030C15),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SecondaryAppBar(title: 'Edit Profile', hasButton: true),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 15.h),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r)
                            ),
                            height: 200.h,
                            width: double.infinity,
                            child:
                                context
                                        .watch<CommunityScreenProvider>()
                                        .selectImage ==
                                    null
                                ? Image.asset(
                                    'assets/images/profile_cover.png',
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    context
                                        .watch<CommunityScreenProvider>()
                                        .selectImage!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            right: 16.r,
                            bottom: 16,
                            child: GestureDetector(
                              onTap: _pickerImage,
                              child: Image.asset(
                                'assets/icons/button.png',
                                scale: 3.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Transform.translate(
                        offset: Offset(0, 50),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 50.r,
                                backgroundImage: AssetImage(
                                  'assets/images/girls_profile.png',
                                ),
                              ),
                            ),

                            Positioned(
                              right: 2.r,
                              bottom: 2,
                              child: Container(
                                width: 30.w,
                                height: 40.h,
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/icons/button.png',
                                  scale: 3.4.sp,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),
                        Text(
                          'Name',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xffB2B5B8),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        CustomTextField(
                          controller: _nameController,
                          hintText: 'Enter your name',
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'UserName',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xffB2B5B8),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        CustomTextField(
                          controller: _usernameController,
                          hintText: 'Enter your user name',
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'About',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xffB2B5B8),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        CustomTextField(
                          controller: _bioController,
                          hintText: 'Write here.....',
                        ),
                        SizedBox(height: 24.h),
                        PrimaryButton(
                          onTap: () {},
                          color: Colors.white,
                          textColor: Colors.black,
                          icon: '',
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Color(0xFF030C15),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
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
