import 'package:abbas/presentation/views/message/provider/create_chat_provider.dart';
import 'package:abbas/presentation/views/profile/view_model/profil_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../../cors/routes/route_names.dart';
import '../../../../widgets/custom_bottom_sheet.dart';
import '../../../../widgets/secondary_appber.dart';
import '../../widgets/post_actions.dart';
import '../../widgets/share_bottom_sheet.dart';

class OthersProfile extends StatelessWidget {
  const OthersProfile({super.key});

  void onPostReport(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CustomBottomSheet(
        title: 'Report User',
        description: 'Are you sure to Report the User?',
        iconPath: 'assets/icons/alert.svg',
        buttonTitle: 'Yes, Report',
        buttonIconPath: 'assets/icons/user_report.svg',
        onTap: () {
          Navigator.pushNamed(context, RouteNames.reportListPage);
        },
      ),
    );
  }

  void onPostShare(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ShareBottomSheet(
        title: 'Share with your friends',
        description: '',
        iconPath: '',
        buttonTitle: 'Back to Home',
        buttonIconPath: '',
        onTap: () {
          Navigator.pushNamed(context, RouteNames.reportListPage);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileScreenProvider>(context);
    final createChatProvider = Provider.of<CreateChatProvider>(context);

    final data = profileProvider.otherProfileModel?.data;
    final name = data?.name ?? "N/A";
    final userName = data?.name ?? "N/A";
    final email = data?.email ?? "N/A";
    final about = data?.about ?? "N/A";
    final userId = data?.id ?? "N/A";
    final avater = data?.avatar ?? "N/A";
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SecondaryAppBar(
              title: 'Other Profile',
              hasButton: true,
              isSearch: true,
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                children: [
                  _buildProfileHeader(context, avater),
                  SizedBox(height: 60.h),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF5F6CA0),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  _buildAboutSection(userName, about),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      _buildChatButton(userId, context, createChatProvider),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.editProfile);
                        },
                        child: Image.asset('assets/icons/dots.png', scale: 3.5),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _buildPostCard(context),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String avater) {
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
              backgroundImage: NetworkImage(avater),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(String userName, String about) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF05111C),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3D4566), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About $userName',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            about,
            style: TextStyle(fontSize: 16.sp, color: Color(0xFFD2D2D5)),
          ),
        ],
      ),
    );
  }

  Widget _buildChatButton(
    String userId,
    BuildContext context,
    CreateChatProvider provider,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: 280.w,
      child: ElevatedButton.icon(
        onPressed: () async {
          if (userId != null && userId.isNotEmpty) {
            await provider.createConversation(userId);
          } else {}
          Navigator.pushNamed(context, RouteNames.oneTwoOneChatScreen);
        },
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
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(BuildContext context) {
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
              PopupMenuButton<String>(
                color: Color(0xFF05111C),
                borderRadius: BorderRadius.circular(20.r),
                onSelected: (String result) {
                  if (result == 'Share') {
                    onPostShare(context);
                  } else if (result == 'Report') {
                    onPostReport(context);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'Report',
                      child: Container(
                        width: double.infinity,
                        height: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: Color(0xFF3D4566),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/user_report.svg',
                              width: 16.w,
                              height: 16.h,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Report',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Share',
                      child: Container(
                        width: double.infinity,
                        height: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: Color(0xFF3D4566),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/share.png',
                              width: 16.w,
                              height: 16.h,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Share',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                child: Icon(
                  Icons.more_horiz_outlined,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Behind the scenes of our latest project! The team has been working incredibly hard.',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
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
          PostActions(likes: 12, comments: 3, shares: 4),
        ],
      ),
    );
  }
}
