import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../../cors/theme/app_colors.dart';
import '../../../../../widgets/secondary_appber.dart';
import '../../../../profile/widgets/download_receipt_card.dart';

class SubmittedAssignmentScreen extends ConsumerStatefulWidget {
  final String assignmentId;
  const SubmittedAssignmentScreen({super.key, required this.assignmentId});

  @override
  ConsumerState<SubmittedAssignmentScreen> createState() =>
      _SubmittedAssignmentScreenState();
}

class _SubmittedAssignmentScreenState
    extends ConsumerState<SubmittedAssignmentScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getAssignmentDetailsProvider.notifier)
          .getAssignmentDetails(assignmentId: widget.assignmentId);
    });
    super.initState();
  }

  /// -------------------- Formatted Date --------------------------------------
  String formattedDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';

    try {
      final DateTime parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignmentDetails = ref.watch(getAssignmentDetailsProvider);
    final assignmentDetailsState = assignmentDetails.value;
    final attachmentUrls = assignmentDetailsState?.data?.attachmentUrl;
    return Scaffold(
      backgroundColor: Color(0xff030D15),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SecondaryAppBar(
              title: assignmentDetailsState?.data?.title ?? 'N/A',
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  Text(
                    "${assignmentDetailsState?.data?.moduleClass?.classTitle ?? 'N/A'} : ${assignmentDetailsState?.data?.moduleClass?.className ?? 'N/A'}",
                    style: TextStyle(
                      color: Color(0xffFFFFFF),
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "${assignmentDetailsState?.data?.moduleClass?.module?.moduleTitle ?? 'N/A'}: ${assignmentDetailsState?.data?.moduleClass?.module?.moduleName ?? 'N/A'}",
                    style: TextStyle(
                      color: Color(0xff8C9196),
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.red),
                      SizedBox(width: 6.w),
                      Text(
                        "Due : ${formattedDate(assignmentDetailsState?.data?.dueDate)}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Divider(thickness: 0.7, color: Color(0xff8C9196)),

                  Text(
                    assignmentDetailsState?.data?.title ?? 'N/A',
                    style: TextStyle(
                      color: Color(0xffFFFFFF),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 12.h),
                  Text(
                    assignmentDetailsState?.data?.description ?? 'N/A',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.containerColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.subContainerColor,
                        width: 1.5.w,
                      ),
                    ),
                    child: Column(
                      spacing: 8.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Assignment Submitted",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Divider(),
                        Text(
                          assignmentDetailsState?.data?.submission?.title ?? 'N/A',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          assignmentDetailsState?.data?.submission?.description ?? 'N/A',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 8.h),
                       LediKhadashProtiva(
                        title: assignmentDetailsState?.data?.submission?.fileUrl?.split('/').last ?? 'N/A',
                        hasIcon: false,
                       )
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, RouteNames.parentScreen),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/arrow_back.svg',
                            height: 22.w,
                            width: 22.w,
                          ),
                          SizedBox(width: 7),
                          Text(
                            "Back to Home",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              color: Color(0xff8D9CDC),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
