import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../cors/theme/app_colors.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.title,
    required this.iconPath,
    this.route = "",
    this.isLast = false,
    this.hasPrefixIcon = true,
    this.bottomSheet,
  });
  final bool hasPrefixIcon;
  final String title;
  final String iconPath;
  final String route;
  final bool isLast;
  final Widget? bottomSheet;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        isLast
            ? showModalBottomSheet(
                context: context,
                builder: (context) => bottomSheet!
              )
            : Navigator.pushNamed(context, route);
      },
      child: Container(
        alignment: Alignment.center,
        height: 58.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.containerColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.subContainerColor, width: 1.5.w),
        ),
        child: ListTile(
          leading: hasPrefixIcon
              ? Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.subContainerColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: SvgPicture.asset(iconPath),
                )
              : null,
          title: Text(
            title,
            style: textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
          trailing: SvgPicture.asset(
            "assets/icons/arrow_forword.svg",
            height: 28.h,
          ),
        ),
      ),
    );
  }
}
