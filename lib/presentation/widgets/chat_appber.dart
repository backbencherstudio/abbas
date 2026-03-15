import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cors/theme/app_colors.dart';

class ChatAppBer extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasButton;
  final bool isEdit;
  final bool isSearch;
  final String? image;
  final VoidCallback? onEditButtonTap;

  const ChatAppBer({
    super.key,
    required this.title,
    this.hasButton = false,
    this.onEditButtonTap,
    this.isEdit = false,
    this.image,
    this.isSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.containerColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 48.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              ClipOval(child: Image.asset(image!)),
              SizedBox(width: 8.w),

              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              Spacer(),

              Icon(Icons.call, color: Color(0xffE9201D)),
              SizedBox(width: 16),
              Icon(Icons.videocam_rounded, color: Color(0xffE9201D)),
              SizedBox(width: 16),

              Icon(Icons.report_outlined, color: Color(0xff8D9CDC)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
