import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerWidget(){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 27, vertical: 8),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade700,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    ),
  );
}