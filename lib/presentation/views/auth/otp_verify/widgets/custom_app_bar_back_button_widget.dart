import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widgets/custom_appbar_back_button.dart';

class CustomAppBarBackButtonWidget extends StatelessWidget {
  const CustomAppBarBackButtonWidget({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: [
          CustomAppbarBackButton(onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}