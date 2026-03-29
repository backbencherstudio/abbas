import 'dart:io';
import 'package:abbas/presentation/widgets/custom_button.dart';
import 'package:abbas/presentation/widgets/custom_text_field.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/validator.dart';
import '../../view_model/profil_screen_provider.dart';

class EditPersonalInfoScreen extends StatefulWidget {
  const EditPersonalInfoScreen({super.key});

  @override
  State<EditPersonalInfoScreen> createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController goalController = TextEditingController();
  final _experienceController = TextEditingController();
  final GlobalKey _experienceFieldKey = GlobalKey();

  File? selectedImage;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final profileProvider = Provider.of<ProfileScreenProvider>(
        context,
        listen: false,
      );

      final profile = profileProvider.profile;

      if (profile != null) {
        nameController.text = profile.data?.name ?? "";
        phoneController.text = profile.data?.phoneNumber ?? "";
        dobController.text = profile.data?.dateOfBirth ?? "";
        _experienceController.text = profile.data?.experienceLevel ?? "";
        goalController.text = profile.data?.actingGoals?.actingGoals ?? "";
        selectedImage = (profile.data?.avatar ?? "") as File?;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    dobController.dispose();
    goalController.dispose();
    super.dispose();
  }

  /// ------------------------- Selected Date Method ---------------------------
  Future<void> _selectedDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dobController.text =
            "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      });
    }
  }

  /// ------------------------- Show Experience Level Popup --------------------
  void _showExperienceLevelPopup() {
    final RenderBox? renderBox =
        _experienceFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    showMenu<String>(
      context: context,
      position:
          RelativeRect.fromLTRB(
            renderBox.size.width - 200.w,
            renderBox.size.height + 5.h,
            0,
            0,
          ).shift(
            Offset(
              renderBox.localToGlobal(Offset.zero).dx,
              renderBox.localToGlobal(Offset.zero).dy,
            ),
          ),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      items: [
        PopupMenuItem<String>(
          value: 'BEGINNER',
          child: Container(
            width: 200.w,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text('BEGINNER', style: TextStyle(fontSize: 14.sp)),
          ),
        ),
        PopupMenuItem<String>(
          value: 'MID-LEVEL',
          child: Container(
            width: 200.w,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text('MID-LEVEL', style: TextStyle(fontSize: 14.sp)),
          ),
        ),
        PopupMenuItem<String>(
          value: 'ADVANCED',
          child: Container(
            width: 200.w,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text('ADVANCED', style: TextStyle(fontSize: 14.sp)),
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        setState(() {
          _experienceController.text = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileScreenProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      body: Column(
        children: [
          SecondaryAppBar(title: "Edit Personal Info"),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: pickImage,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(color: Color(0xFF5F6CA0)),
              ),
              child: CircleAvatar(
                radius: 32.r,
                backgroundImage: selectedImage != null
                    ? FileImage(selectedImage!) as ImageProvider
                    : profileProvider.profile?.data?.avatar != null
                    ? NetworkImage(profileProvider.profile!.data!.avatar!)
                    : null,
                child:
                    selectedImage == null &&
                        profileProvider.profile?.data?.avatar == null
                    ? const Icon(Icons.camera_alt)
                    : null,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Full Name",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFFB2B5B8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    CustomTextField(
                      controller: nameController,
                      hintText: "Enter your full name",
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Phone",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFFB2B5B8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    CustomTextField(
                      controller: phoneController,
                      hintText: "Enter a Phone number",
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Date of Birth",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFFB2B5B8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    CustomTextField(
                      hintText: 'select date of birth',
                      controller: dobController,
                      readOnly: true,
                      validator: dateOfBirthValidator,
                      suffixIcon: GestureDetector(
                        onTap: _selectedDate,
                        child: Icon(Icons.calendar_month, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Experience Level",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFFB2B5B8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Container(
                      key: _experienceFieldKey,
                      child: CustomTextField(
                        hintText: 'select experience level',
                        controller: _experienceController,
                        readOnly: true,
                        validator: experienceLevelValidator,
                        suffixIcon: GestureDetector(
                          onTap: _showExperienceLevelPopup,
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 32.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Acting Goals / Interests",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xFFB2B5B8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    CustomTextField(
                      controller: goalController,
                      hintText: "Tell us why you're here...",
                      maxLines: 5,
                    ),

                    SizedBox(height: 16.h),

                    CustomButton(
                      title: profileProvider.isLoading ? "Loading..." : "Save",
                      onTap: () async {
                        bool success = await profileProvider.editProfile(
                          name: nameController.text,
                          phone: phoneController.text,
                          dob: dobController.text,
                          experienceLevel: _experienceController.text,
                          goal: goalController.text,
                          imagePath: selectedImage?.path,
                        );

                        if (success) {
                          profileProvider.getProfile();
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                profileProvider.errorMessage ?? "Update failed",
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 24.h),
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
