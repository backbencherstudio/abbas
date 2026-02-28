import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../cors/theme/app_colors.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({super.key, required this.title, this.onTap, this.color, this.textColor, this.iconWidget, this.hasIcon = false});
  final String title;
  final VoidCallback? onTap;
  final Color? color;
  final Color? textColor;
  final Widget? iconWidget;
  final bool? hasIcon;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16.sp),
          border: Border.all(color: AppColors.borderColor, width: 1.5.w)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasIcon ?? false)
              iconWidget!,
            SizedBox(width: 8.w,),
            Text(
              title,
              style: TextStyle(
                color: textColor ?? Color(0xffffffff),
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
