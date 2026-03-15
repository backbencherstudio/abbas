import 'dart:io';
import 'package:abbas/presentation/widgets/custom_button.dart';
import 'package:abbas/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileScreenProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Icon(Icons.arrow_back, color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          "Edit Personal Info",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
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

              const SizedBox(height: 20),

              CustomTextField(
                controller: nameController,
                hintText: "Enter Name",
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: phoneController,
                hintText: "Enter Phone",
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: dobController,
                hintText: "Enter Date of Birth",
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: goalController,
                hintText: "Enter Goal",
              ),

              const SizedBox(height: 20),

              // CustomButton(
              //   title: profileProvider.isLoading
              //       ? const Text("Loading...")
              //       : const Text("Update Profile"),
              //   onTap: () async {
              //     bool success = await profileProvider.editProfile(
              //       name: nameController.text,
              //       phone: phoneController.text,
              //       dob: dobController.text,
              //       goal: goalController.text,
              //       imagePath: selectedImage?.path,
              //     );
              //
              //     if (success) {
              //       profileProvider.getProfile();
              //       Navigator.pop(context);
              //     } else {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(
              //           content: Text(
              //             profileProvider.errorMessage ?? "Update failed",
              //           ),
              //         ),
              //       );
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
