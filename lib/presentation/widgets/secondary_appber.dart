// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import '../../cors/theme/app_colors.dart';
//
// class SecondaryAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final bool hasButton;
//   final bool isEdit;
//   final bool isSearch;
//   final VoidCallback? onEditButtonTap;
//
//
//
//   const SecondaryAppBar({
//     super.key,
//     required this.title,
//     this.hasButton = false,
//     this.onEditButtonTap,
//     this.isEdit = false,
//     this.isSearch = false,
//
//
//   });
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
//       decoration: BoxDecoration(
//         color: AppColors.containerColor,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(20.r),
//           bottomRight: Radius.circular(20.r),
//         ),
//       ),
//       child: Column(
//         children: [
//           SizedBox(height: 48.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               GestureDetector(
//                 onTap: () => Navigator.pop(context),
//                 child: Icon(
//                   Icons.arrow_back_ios_new,
//                   color: Colors.white,
//                   size: 20.w,
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Text(
//                 title,
//                 style: Theme.of(
//                   context,
//                 ).textTheme.titleLarge?.copyWith(color: Colors.white),
//               ),
//               Spacer(),
//               if (hasButton)
//                 isEdit
//                     ? GestureDetector(
//                         onTap: onEditButtonTap,
//                         child: Padding(
//                           padding: EdgeInsets.only(right: 8.w),
//                           child: SvgPicture.asset(
//                             "assets/icons/edit.svg",
//                             height: 18.h,
//                             width: 18.w,
//                           ),
//                         ),
//                       )
//                     : isSearch
//                     ? GestureDetector(
//                         onTap: onEditButtonTap,
//                         child: Padding(
//                           padding: EdgeInsets.only(right: 8.w),
//                           child: SvgPicture.asset(
//                             "assets/icons/search.svg",
//                             height: 18.h,
//                             width: 18.w,
//                           ),
//                         ),
//                       )
//                     : SizedBox(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   // TODO: implement preferredSize
//   Size get preferredSize => throw UnimplementedError();
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../cors/theme/app_colors.dart';

class SecondaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasButton;
  final bool isEdit;
  final bool isSearch;
  final VoidCallback? onEditButtonTap;

  const SecondaryAppBar({
    super.key,
    required this.title,
    this.hasButton = false,
    this.onEditButtonTap,
    this.isEdit = false,
    this.isSearch = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(100.h); // Add this proper implementation

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
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              Spacer(),
              if (hasButton)
                isEdit
                    ? GestureDetector(
                  onTap: onEditButtonTap,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: SvgPicture.asset(
                      "assets/icons/edit.svg",
                      height: 18.h,
                      width: 18.w,
                    ),
                  ),
                )
                    : isSearch
                    ? GestureDetector(
                  onTap: onEditButtonTap,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: SvgPicture.asset(
                      "assets/icons/search.svg",
                      height: 18.h,
                      width: 18.w,
                    ),
                  ),
                )
                    : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

// REMOVE THIS LINE - it's causing the error
// @override
// Size get preferredSize => throw UnimplementedError();
}

