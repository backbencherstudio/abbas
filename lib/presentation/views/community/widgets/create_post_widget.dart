import 'package:abbas/presentation/views/profile/view_model/profile_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart' as legacy_provider;
import '../../../../cors/routes/route_names.dart';
import '../../../../cors/theme/app_colors.dart';

class CreatePostWidget extends ConsumerWidget {
  const CreatePostWidget({super.key, this.onTap, this.onOpenCreatePost});

  final VoidCallback? onTap;
  final Future<void> Function()? onOpenCreatePost;

  Future<void> _openCreatePost(BuildContext context) async {
    if (onOpenCreatePost != null) {
      await onOpenCreatePost!();
      return;
    }
    await Navigator.pushNamed(context, RouteNames.createPost);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: const Color(0xFF0A1A29),
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
                    child: legacy_provider.Consumer<ProfileScreenProvider>(
                      builder: (context, profileProvider, child) {
                        final profileImage =
                            profileProvider.profile?.data?.avatar;
                        final hasAvatar =
                            profileImage != null && profileImage.isNotEmpty;
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            RouteNames.editProfile,
                          ),
                          child: CircleAvatar(
                            radius: 24.r,
                            backgroundColor: const Color(0xFF1B2A3A),
                            backgroundImage:
                                hasAvatar ? NetworkImage(profileImage) : null,
                            child: hasAvatar
                                ? null
                                : Icon(
                                    Icons.person,
                                    size: 24.sp,
                                    color: Colors.grey,
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 16.h),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _openCreatePost(context),
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
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "What's on your mind?",
                              style: TextStyle(
                                color: AppColors.greyTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              const Divider(color: Color(0xFF202C43), thickness: 1),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    icon: "assets/icons/photo.png",
                    label: "Photo",
                    onTap: () => _openCreatePost(context),
                  ),
                  _buildActionButton(
                    icon: "assets/icons/video.png",
                    label: "Video",
                    onTap: () => _openCreatePost(context),
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
