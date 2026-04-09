import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../widgets/secondary_appber.dart';
import '../../../course_screen/screens/my_class/widget/pdf_widget.dart';


class ContractDocumentScreen extends StatelessWidget {
  const ContractDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SecondaryAppBar(title: 'Contract Document'),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              spacing: 16.h,
              children: [
                 LediKhadashProtiva(title: 'Signed Contract',),
                 LediKhadashProtiva(title: 'Rules and Regulations'),
                 LediKhadashProtiva(title: 'Payment Receipt'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
