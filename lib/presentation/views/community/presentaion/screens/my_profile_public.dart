import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widgets/secondary_appber.dart';

class MyProfilePublic extends StatelessWidget {
  const MyProfilePublic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SecondaryAppBar(title: 'Profile', hasButton: true, isSearch: true,),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildProfileHeader(context),
                  SizedBox(height: 60.h),
                  Text(
                    'Brooklyn Simmons',
                    style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '@brooklyn_Simmons',
                    style: TextStyle(fontSize: 12.sp,fontWeight: FontWeight.w400,color: Color(0xFF5F6CA0)),
                  ),
                  SizedBox(height: 15.h),
                  _buildAboutSection(),
                  SizedBox(height: 16.h),
                  _buildChatButton(),
                  SizedBox(height: 16.h),
                  _buildPostCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 200.h,
          width: double.infinity,
          child: Image.asset(
            'assets/images/profile_cover.png',
            fit: BoxFit.cover,
          ),
        ),
        Transform.translate(
          offset: Offset(0, 50.h),
          child: Container(
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 50.r,
              backgroundImage: AssetImage('assets/images/girls_profile.png'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF05111C),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFF3D4566),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Brooklyn',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Aspiring actor passionate about stage, screen, and voice performance. Currently training at CINACT to grow my performance skills and creative confidence.',
            style: TextStyle(fontSize: 16.sp, color: Color(0xFFD2D2D5)),
          ),
        ],
      ),
    );
  }

  Widget _buildChatButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3D4566),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        icon: Image.asset(
          'assets/icons/chat_icon.png',
          width: 20.w,
          height: 20.h,
          color: Colors.white,
        ),
        label: Text(
          'Chat',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPostCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A29),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: AssetImage('assets/images/girls_profile.png'),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sophie Lambert',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '10 min ago.',
                    style: TextStyle(fontSize: 12.sp, color: Colors.white54),
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.more_horiz, color: Colors.white, size: 24.sp),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Behind the scenes of our latest project! The team has been working incredibly hard.',
            style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w400, color: Colors.white),
          ),
          SizedBox(height: 12.h),
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              image: DecorationImage(
                image: AssetImage('assets/images/profile_cover.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
