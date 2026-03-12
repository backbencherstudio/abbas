
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widgets/primary_button.dart';
import '../../../../widgets/secondary_appber.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF030C15),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SecondaryAppBar(title: 'Edit Profile',hasButton: true, isSearch: true,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child:
              Column(children: [
                 SizedBox(height: 15.h),
                _buildProfileHeader(context),
                 SizedBox(height: 40.h),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      _buildInputField(title: 'Name', controller: _nameController, hintText: 'Brooklyn Simmons'),
                      SizedBox(height: 16.h),
                      _buildInputField(title: 'UserName', controller: _usernameController, hintText: '@brooklyn_Simmons'),
                      SizedBox(height: 16.h),
                      _buildInputField(title: 'About', controller: _bioController, hintText: 'Write here...'),
                      SizedBox(height: 15.h),
                      PrimaryButton(onTap: (){}, color: Colors.white, textColor: Colors.black, icon: '', child: Text("Save"),)
                    ],
                  ),
                ),
              ],
              )
            )
          ],
        ),
      ),
    );
  }
  Widget _buildInputField({required String title, required TextEditingController controller,required String hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Color(0xffB2B5B8)),),
        SizedBox(height: 4.h),
        TextFormField(
          controller: controller,
          maxLines: title == 'About' ? 4 : 1,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Enter $title';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.white, width: 1.w),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Color(0xff3D4566), width: 1.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.white54, width: 1.w),
            ),
          ),
        )
      ],
    );
  }
  Widget _buildProfileHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Stack(
            children:[ SizedBox(
              height: 200.h,
              width: double.infinity,
              child: Image.asset(
                'assets/images/profile_cover.png',
                fit: BoxFit.cover,
              ),
            ),
              Positioned(
                  right: 16.r,
                  bottom: 16,
                  child: Image.asset('assets/icons/button.png',scale: 3.sp,))
            ]
        ),
        Transform.translate(
          offset:  Offset(0, 50),
          child: Stack(
              children:[ Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 50.r,
                  backgroundImage: AssetImage('assets/images/girls_profile.png'),
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
              ]
          ),
        ),
      ],
    );
  }
}