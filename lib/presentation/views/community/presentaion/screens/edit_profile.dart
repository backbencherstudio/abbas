import 'dart:io';

import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/community/model/community_profile_model.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_profile_provider.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/edit_profile_provider.dart';
import 'package:abbas/presentation/views/profile/view_model/profile_screen_provider.dart';
import 'package:abbas/presentation/widgets/custom_text_field.dart';
import 'package:abbas/presentation/widgets/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart' as legacy_provider;

import '../../../../widgets/primary_button.dart';
import '../../../../widgets/secondary_appber.dart';

class EditProfile extends ConsumerStatefulWidget {
  final CommunityProfile? initialProfile;
  final String? userId;

  const EditProfile({super.key, this.initialProfile, this.userId});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  String? _existingAvatarUrl;
  String? _existingCoverUrl;
  File? _pickedAvatar;
  File? _pickedCover;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    _prefillFields();
  }

  void _prefillFields() {
    final profile = widget.initialProfile;
    if (profile != null) {
      _nameController.text = profile.name ?? '';
      _usernameController.text = profile.username ?? '';
      _bioController.text = profile.about ?? '';
      _existingAvatarUrl = profile.avatar;
      _existingCoverUrl = profile.coverImage;
      return;
    }

    final legacyProfile = legacy_provider.Provider.of<ProfileScreenProvider>(
      context,
      listen: false,
    );

    final myData = legacyProfile.myProfileModel?.data;
    if (myData != null) {
      _nameController.text = myData.name ?? '';
      _usernameController.text = myData.username ?? '';
      _bioController.text = myData.about ?? '';
      _existingAvatarUrl = myData.avatar;
      _existingCoverUrl = myData.coverImage;
      return;
    }

    final authData = legacyProfile.profile?.data;
    if (authData != null) {
      _nameController.text = authData.name ?? '';
      _bioController.text = authData.about ?? '';
      _existingAvatarUrl = authData.avatar;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickCoverImage() async {
    if (_isPickingImage) return;
    setState(() => _isPickingImage = true);
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() => _pickedCover = File(picked.path));
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
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  Future<void> _pickAvatarImage() async {
    if (_isPickingImage) return;
    setState(() => _isPickingImage = true);
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() => _pickedAvatar = File(picked.path));
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
      if (mounted) setState(() => _isPickingImage = false);
    }
  }

  ImageProvider? get _coverImageProvider {
    if (_pickedCover != null) return FileImage(_pickedCover!);
    if (_existingCoverUrl != null && _existingCoverUrl!.isNotEmpty) {
      return NetworkImage(_existingCoverUrl!);
    }
    return null;
  }

  ImageProvider? get _avatarImageProvider {
    if (_pickedAvatar != null) return FileImage(_pickedAvatar!);
    if (_existingAvatarUrl != null && _existingAvatarUrl!.isNotEmpty) {
      return NetworkImage(_existingAvatarUrl!);
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final error = await ref.read(editProfileProvider.notifier).updateProfile(
          name: _nameController.text,
          username: _usernameController.text,
          about: _bioController.text,
          avatar: _pickedAvatar,
          coverImage: _pickedCover,
        );

    if (!mounted) return;

    if (error != null) {
      Utils.showToast(
        msg: error,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final userId = widget.userId ?? widget.initialProfile?.id;
    if (userId != null && userId.isNotEmpty) {
      await ref.read(communityProfileProvider(userId).notifier).refresh();
    }

    if (mounted) {
      legacy_provider.Provider.of<ProfileScreenProvider>(
        context,
        listen: false,
      ).getProfile();
    }

    Utils.showToast(
      msg: 'User updated successfully',
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(editProfileProvider).isSaving;
    final coverProvider = _coverImageProvider;
    final avatarProvider = _avatarImageProvider;

    return Scaffold(
      backgroundColor: const Color(0xFF030C15),
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Edit Profile'),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    SizedBox(height: 15.h),
                    SizedBox(
                      height: 180.h,
                      width: double.infinity,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: 130.h,
                                width: double.infinity,
                                child: coverProvider != null
                                    ? Image(
                                        image: coverProvider,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/profile_cover.png',
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Positioned(
                                right: 16.w,
                                bottom: 16.h,
                                child: GestureDetector(
                                  onTap: _pickCoverImage,
                                  child: Image.asset(
                                    'assets/icons/button.png',
                                    scale: 3.sp,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 80.h,
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
                                    backgroundColor: const Color(0xFF1B2A3A),
                                    backgroundImage: avatarProvider,
                                    child: avatarProvider == null
                                        ? Icon(
                                            Icons.person,
                                            size: 40.sp,
                                            color: Colors.grey,
                                          )
                                        : null,
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: _pickAvatarImage,
                                    child: Image.asset(
                                      'assets/icons/button.png',
                                      scale: 3.sp,
                                      fit: BoxFit.cover,
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
                              color: const Color(0xffB2B5B8),
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
                              color: const Color(0xffB2B5B8),
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
                              color: const Color(0xffB2B5B8),
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
                            onTap: isSaving ? null : _save,
                            color: Colors.white,
                            textColor: Colors.black,
                            icon: '',
                            child: isSaving
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  )
                                : Text(
                                    'Save',
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
