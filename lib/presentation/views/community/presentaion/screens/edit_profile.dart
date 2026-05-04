import 'dart:io';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_screen_provider.dart';
import 'package:abbas/presentation/views/profile/view_model/profile_screen_provider.dart';
import 'package:abbas/presentation/widgets/custom_text_field.dart';
import 'package:abbas/presentation/widgets/validator.dart';
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
  @override
  void initState() {
    super.initState();
    _updateProfile();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  void _updateProfile() {
    final editProfileData = context
        .read<ProfileScreenProvider>()
        .myProfileModel
        ?.data;
    if (editProfileData != null) {
      _nameController.text = editProfileData.name ?? '';
      _usernameController.text = editProfileData.username ?? '';
      _bioController.text = editProfileData.about ?? '';
    }
  }

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

  Future<void> _pickerProfileImage() async {
    try {
      context.read<CommunityScreenProvider>().setIsPickingImage(true);
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        imageQuality: 85,
      );

      if (pickedImage != null) {
        context.read<CommunityScreenProvider>().setProfilePicked(
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
      backgroundColor: const Color(0xFF030C15),
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Edit Profile', hasButton: true),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    SizedBox(height: 15.h),
                    // Main profile header stack
                    SizedBox(
                      height: 180.h,
                      width: double.infinity,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          // Cover Image
                          Stack(
                            children: [
                              SizedBox(
                                height: 130.h,
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
                                right: 16.w,
                                bottom: 16.h,
                                child: GestureDetector(
                                  onTap: _pickerImage,
                                  child: Image.asset(
                                    'assets/icons/button.png',
                                    scale: 3.sp,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Profile Picture
                          Positioned(
                            top: 80.h, // 130h cover - 50h (half of avatar)
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(1.r),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 50.r,
                                    backgroundImage:
                                        context
                                                .watch<
                                                  CommunityScreenProvider
                                                >()
                                                .selectProfile ==
                                            null
                                        ? const AssetImage(
                                            'assets/images/profile.png',
                                          )
                                        : FileImage(
                                                context
                                                    .watch<
                                                      CommunityScreenProvider
                                                    >()
                                                    .selectProfile!,
                                              )
                                              as ImageProvider,
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 0,
                                  child: Container(
                                    width: 30.w,
                                    height: 30.h,
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: GestureDetector(
                                      onTap: _pickerProfileImage,
                                      child: Image.asset(
                                        'assets/icons/button.png',
                                        scale: 3.sp,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: Color(0xffB2B5B8),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          CustomTextField(
                            controller: _nameController,
                            hintText: 'Enter your name',
                            validator: nameValidator,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'UserName',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: Color(0xffB2B5B8),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          CustomTextField(
                            controller: _usernameController,
                            hintText: 'Enter your user name',
                            validator: userNameValidator,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'About',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: Color(0xffB2B5B8),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          CustomTextField(
                            controller: _bioController,
                            hintText: 'Write here.....',
                            maxLines: 5,
                          ),
                          SizedBox(height: 24.h),
                          PrimaryButton(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                final res = await context
                                    .read<CommunityScreenProvider>()
                                    .editMyProfile(
                                      name: _nameController.text,
                                      userName: _usernameController.text,
                                      about: _bioController.text,
                                      avatar: context
                                          .read<CommunityScreenProvider>()
                                          .selectProfile,
                                      coverImage: context
                                          .read<CommunityScreenProvider>()
                                          .selectImage,
                                    );

                                if (res.success) {
                                  context
                                      .read<CommunityScreenProvider>()
                                      .fetchFeeds();
                                  Utils.showToast(
                                    msg: res.message,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                  );
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                } else {
                                  Utils.showToast(
                                    msg: res.message,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                }
                              }
                            },
                            color: Colors.white,
                            textColor: Colors.black,
                            icon: '',
                            child:
                                context
                                    .watch<CommunityScreenProvider>()
                                    .isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  )
                                : Text(
                                    "Save",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: const Color(0xFF030C15),
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
            ),
          ),
        ],
      ),
    );
  }
}
