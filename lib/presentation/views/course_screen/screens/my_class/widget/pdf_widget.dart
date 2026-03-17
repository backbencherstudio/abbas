import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


// Global notification instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> showDownloadCompletedNotification(String filePath) async {
  const AndroidNotificationDetails androidDetails =
  AndroidNotificationDetails(
    'download_channel',
    'Downloads',
    channelDescription: 'Notifications for file downloads',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );

  const NotificationDetails platformDetails =
  NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    id: 0,
    title: 'PDF download completed',
    body: 'Tap to open PDF',
    notificationDetails: platformDetails,
    payload: filePath,
  );
}

class PdfWidget extends StatelessWidget {
  const PdfWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              child: ExpansionTile(
                title: Text(
                  "Module 1: Personal Development",
                  style: TextStyle(
                    color: const Color(0xffB2B5B8),
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                children: List.generate(4, (index) {
                  return LediKhadashProtiva(
                    title: 'Attachment-00${index + 1}.pdf',
                  );
                }),
              ),
            ),
            SizedBox(height: 20.h),
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              child: ExpansionTile(
                title: Text(
                  "Module 2: Script Analysis",
                  style: TextStyle(
                    color: const Color(0xffB2B5B8),
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                children: List.generate(4, (index) {
                  return LediKhadashProtiva(
                    title: 'Attachment-00${index + 1}.pdf',
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Single PDF item
class LediKhadashProtiva extends StatelessWidget {
  const LediKhadashProtiva({
    super.key,
    required this.title,
    this.hasIcon = true,
    this.isVideo = false,
  });

  final String title;
  final bool hasIcon;
  final bool isVideo;

  Future<String> _downloadPdf(BuildContext context) async {
    try {
      final url =
          "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/$title";

      final file = File(filePath);
      if (file.existsSync()) await file.delete();

      final dio = Dio();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Downloading PDF...")),
      );

      await dio.download(url, filePath);

      // Show SnackBar with "Open" action
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Downloaded $title"),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () {
              // Open PDF when user taps "Open"
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => PdfViewerScreen(filePath: filePath, title: title),
              //   ),
              // );
            },
          ),
        ),
      );

      // Optional: also show notification
      await showDownloadCompletedNotification(filePath);

      return filePath;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error downloading PDF: $e")),
      );
      rethrow;
    }
  }


  void _openPdf(BuildContext context) async {
    // Only download and trigger notification
    await _downloadPdf(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2136),
        borderRadius: BorderRadius.circular(12.r),
        border: Border(
          left: BorderSide(color: const Color(0xFF5F6CA0), width: 1.5.w),
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            isVideo ? 'assets/icons/video_stroke.svg' : 'assets/icons/pdf.svg',
            height: 24.h,
            width: 24.w,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (hasIcon)
            isVideo
                ? Icon(Icons.play_arrow_outlined,
                color: Colors.red, size: 28.h)
                : GestureDetector(
              onTap: () => _openPdf(context),
              child: SvgPicture.asset(
                'assets/icons/download.svg',
                height: 24.h,
                width: 24.w,
              ),
            ),
        ],
      ),
    );
  }
}


