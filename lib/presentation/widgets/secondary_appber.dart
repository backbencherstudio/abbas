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
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../cors/theme/app_colors.dart';

class SecondaryAppBar extends StatelessWidget {
  final String title;
  final bool hasButton;
  final bool isEdit;
  final bool isSearch;
  final VoidCallback? onEditButtonTap;
  final Widget? trailing;
  final VoidCallback? onBack;

  const SecondaryAppBar({
    super.key,
    required this.title,
    this.hasButton = false,
    this.onEditButtonTap,
    this.isEdit = false,
    this.isSearch = false,
    this.trailing,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Container(
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
                  onTap: onBack ?? () => Navigator.pop(context),
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
                if (trailing != null)
                  trailing!
                else if (hasButton)
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
      ),
    );
  }

  // REMOVE THIS LINE - it's causing the error
  // @override
  // Size get preferredSize => throw UnimplementedError();
}

/// Keeps [SecondaryAppBar] fixed while [body] scrolls underneath.
class SecondaryScreenBody extends StatelessWidget {
  final String title;
  final Widget body;
  final Color? backgroundColor;
  final bool hasButton;
  final bool isEdit;
  final bool isSearch;
  final VoidCallback? onEditButtonTap;
  final Widget? trailing;
  final VoidCallback? onBack;

  const SecondaryScreenBody({
    super.key,
    required this.title,
    required this.body,
    this.backgroundColor,
    this.hasButton = false,
    this.isEdit = false,
    this.isSearch = false,
    this.onEditButtonTap,
    this.trailing,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      body: Column(
        children: [
          SecondaryAppBar(
            title: title,
            hasButton: hasButton,
            isEdit: isEdit,
            isSearch: isSearch,
            onEditButtonTap: onEditButtonTap,
            trailing: trailing,
            onBack: onBack,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
