import 'package:abbas/presentation/views/profile/view_model/profil_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../cors/routes/route_names.dart';
import '../../../../cors/theme/app_colors.dart';

class CreatePostWidget extends StatelessWidget {
  const CreatePostWidget({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Color(0xFF0A1A29),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onTap,
                    child: Consumer<ProfileScreenProvider>(
                      builder: (context, profileProvider, child) {
                        final profileImage =
                            profileProvider.profile?.data?.avatar;
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            RouteNames.editProfile,
                          ),
                          child: CircleAvatar(
                            radius: 24.r,
                            backgroundImage: NetworkImage(profileImage ?? ''),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16.h),

                  Expanded(
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Center(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "What's on your mind?",
                              hintStyle: TextStyle(
                                color: AppColors.greyTextColor,
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Divider(color: Color(0xFF202C43), thickness: 1),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    icon: "assets/icons/photo.png",
                    label: "Photo",
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.createPost);
                    },
                  ),
                  _buildActionButton(
                    icon: "assets/icons/video.png",
                    label: "Video",
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.createPost);
                    },
                  ),
                  _buildActionButton(
                    icon: "assets/icons/pool.png",
                    label: "Poll",
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.createPool);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(icon, scale: 1.7),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(color: AppColors.greyTextColor, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
