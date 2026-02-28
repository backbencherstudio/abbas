import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/secondary_appber.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  String? selectedReason;
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030C15),
      body: Column(
        children: [
          SecondaryAppBar(title: 'Report',hasButton: true,isSearch: true,),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: selectedReason == null
                ? _buildReasonList()
                : _buildDetailPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonList() {
    final reasons = [
      "Hate Speech or Offensive Behavior",
      'Inappropriate Content',
      ' Harassment or Bullying',
      'Spam or Scam',
      ' False Information',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Why are you reporting this user?',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Select a reason for reporting this user. Your report will remain confidential.',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 24.h),
        ...reasons.map((r) => _buildReportOption(r)).toList(),
      ],
    );
  }

  Widget _buildReportOption(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Color(0xff0A1A29),
        borderRadius: BorderRadius.circular(8.r),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(text, style: TextStyle(fontSize: 14.sp,color: Colors.white,fontWeight: FontWeight.w400)),
        trailing:
        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () => setState(() => selectedReason = text),
      ),
    );
  }

  Widget _buildDetailPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoCard('Reason for reporting:', selectedReason ?? ''),
        _messageCard(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submitReport,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xff030C15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.r)),
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
            child: Text(
              'Submit Report',
              style: TextStyle(
                  fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoCard(String title, String content) {
    return Container(width: double.infinity,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Color(0xff0A1A29),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Color(0xff3D4566),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14.sp, color: Color(0xff8C9196),fontWeight: FontWeight.w500)),
          SizedBox(height: 8.h),
          Text(content, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _messageCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Color(0xff3D4566),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _messageController,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: 'Describe the occasion...',
          border: InputBorder.none,
          hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey[400]),
        ),
        style: TextStyle(fontSize: 16.sp),
      ),
    );
  }

  void _submitReport() {
    final reason = selectedReason ?? '';
    final message = _messageController.text;

    if (reason.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report submitted ✅')),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }
}
