import 'package:abbas/presentation/views/profile/view_model/profile_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../cors/theme/app_colors.dart';
import '../../../../widgets/secondary_appber.dart';

class ContractDocumentScreen extends StatefulWidget {
  const ContractDocumentScreen({super.key});

  @override
  State<ContractDocumentScreen> createState() => _ContractDocumentScreenState();
}

class _ContractDocumentScreenState extends State<ContractDocumentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileScreenProvider>().getAccountProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileScreenProvider>();
    final accountGetProfileModel = profileProvider.accountGetProfileModel;
    final contractDocuments = accountGetProfileModel?.contractDocuments ?? [];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SecondaryAppBar(title: 'Contract Document'),
          SizedBox(height: 24.h),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              children: contractDocuments.map((documents) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    iconTheme: const IconThemeData(color: Colors.white),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      "${documents.course}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 7.h),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF8D9CDC),
                                width: 3.w,
                              ),
                            ),
                            color: const Color(0xff061220),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      "Digital Contract",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 6.h),
                                  Text(
                                    'Full Name : ${documents.digitalContract?.digitalSignature?.fullName ?? 'N/A'}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    'Signature : ${documents.digitalContract?.digitalSignature?.signature ?? 'N/A'}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 7.h),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(0xFF8D9CDC),
                                width: 3.w,
                              ),
                            ),
                            color: const Color(0xff061220),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      "Rules Regulations",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 6.h),
                                  Text(
                                    'Full Name : ${documents.rulesRegulations?.digitalSignature?.fullName ?? 'N/A'}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    'Signature : ${documents.rulesRegulations?.digitalSignature?.signature ?? 'N/A'}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
