import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/presentation/views/profile/model/signed_documents_model.dart';
import 'package:abbas/presentation/views/profile/view_model/signed_documents_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
      context.read<SignedDocumentsProvider>().fetchSignedDocuments();
    });
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return 'N/A';
    final date = DateTime.tryParse(value);
    if (date == null) return 'N/A';
    return DateFormat('dd MMM yyyy').format(date.toLocal());
  }

  void _openDocument(SignedDocument document) {
    if (!document.isReady) return;

    Navigator.pushNamed(
      context,
      RouteNames.pdfViewerScreen,
      arguments: {
        'asset_url': document.documentUrl,
        'file_name': document.documentName ?? 'document.pdf',
        'mime_type': 'application/pdf',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SignedDocumentsProvider>();
    final courses = provider.courses;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Contract Document'),
          Expanded(
            child: provider.isLoading
                ? const Center(child: AnimatedLoading())
                : provider.error != null
                ? _ErrorState(
                    message: provider.error!,
                    onRetry: () =>
                        context.read<SignedDocumentsProvider>().fetchSignedDocuments(),
                  )
                : courses.isEmpty
                ? _EmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 20.h,
                    ),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return _CourseDocumentsCard(
                        course: course,
                        formatDate: _formatDate,
                        onOpenDocument: _openDocument,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CourseDocumentsCard extends StatelessWidget {
  final SignedCourseDocuments course;
  final String Function(String?) formatDate;
  final void Function(SignedDocument document) onOpenDocument;

  const _CourseDocumentsCard({
    required this.course,
    required this.formatDate,
    required this.onOpenDocument,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: const Color(0xFF0A1A29),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: const BorderSide(color: Color(0xFF3D4566)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            title: Text(
              course.courseName ?? 'Unnamed Course',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Enrolled: ${formatDate(course.enrolledDate)}',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12.sp,
              ),
            ),
            children: course.documents.isEmpty
                ? [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Text(
                        'No signed documents available for this course.',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ]
                : course.documents
                      .map(
                        (document) => _DocumentTile(
                          document: document,
                          formatDate: formatDate,
                          onTap: () => onOpenDocument(document),
                        ),
                      )
                      .toList(),
          ),
        ),
      ),
    );
  }
}

class _DocumentTile extends StatelessWidget {
  final SignedDocument document;
  final String Function(String?) formatDate;
  final VoidCallback onTap;

  const _DocumentTile({
    required this.document,
    required this.formatDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isReady = document.isReady;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: const Color(0xff061220),
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: isReady ? onTap : null,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border(
                left: BorderSide(
                  color: isReady
                      ? const Color(0xFF8D9CDC)
                      : const Color(0xFF3D4566),
                  width: 3.w,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.documentName ?? 'Document',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Signed: ${formatDate(document.signedDate)}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        document.status ?? 'PENDING',
                        style: TextStyle(
                          color: isReady ? Colors.greenAccent : Colors.orangeAccent,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isReady)
                  Icon(
                    Icons.picture_as_pdf_outlined,
                    color: Colors.white70,
                    size: 22.sp,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined, color: Colors.white38, size: 48.sp),
            SizedBox(height: 12.h),
            Text(
              'No contract documents found',
              style: TextStyle(color: Colors.white70, fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 40.sp),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.activeButtonColor,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
