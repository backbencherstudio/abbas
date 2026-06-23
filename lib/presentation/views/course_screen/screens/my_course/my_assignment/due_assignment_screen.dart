import 'dart:io';

import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/services/api_client.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/course_screen/model/get_assignment_details_model.dart';
import 'package:abbas/presentation/views/course_screen/screens/my_class/widget/pdf_widget.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:abbas/presentation/widgets/validator.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../../../widgets/primary_button.dart';
import '../../../../../widgets/secondary_appber.dart';

class DueAssignmentScreen extends ConsumerStatefulWidget {
  final String assignmentId;

  const DueAssignmentScreen({super.key, required this.assignmentId});

  @override
  ConsumerState<DueAssignmentScreen> createState() =>
      _DueAssignmentScreenState();
}

class _DueAssignmentScreenState extends ConsumerState<DueAssignmentScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Set<String> _downloadingPaths = {};

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  void _loadDetails() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getAssignmentDetailsProvider.notifier)
          .getAssignmentDetails(assignmentId: widget.assignmentId);
    });
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return date;
    return DateFormat('dd MMM yyyy, hh:mm a').format(parsed.toLocal());
  }

  String _dueDaysLabel(int? dueDays) {
    if (dueDays == null) return 'N/A';
    if (dueDays == 0) return 'Due today';
    if (dueDays == 1) return '1 day left';
    if (dueDays < 0) return '${dueDays.abs()} days overdue';
    return '$dueDays days left';
  }

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.isNotEmpty) {
        ref.read(selectedFileProvider.notifier).state =
            File(result.files.single.path!);
      }
    } catch (e) {
      logger.e('Error picking file: $e');
    }
  }

  void _viewAttachment(AssignmentAttachment attachment) {
    final url = attachment.filePath;
    if (url == null || url.isEmpty) return;

    Navigator.pushNamed(
      context,
      RouteNames.pdfViewerScreen,
      arguments: {
        'asset_url': url,
        'file_name': attachment.fileName,
        'mime_type': attachment.mimeType,
      },
    );
  }

  Future<void> _downloadAttachment(AssignmentAttachment attachment) async {
    final url = attachment.filePath;
    final fileName = attachment.fileName ?? 'download';
    final key = url ?? fileName;

    if (url == null || url.isEmpty || _downloadingPaths.contains(key)) return;

    setState(() => _downloadingPaths.add(key));

    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$fileName';
      final file = File(filePath);
      if (file.existsSync()) await file.delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading $fileName...')),
        );
      }

      await Dio().download(url, filePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded $fileName')),
        );
      }

      await showDownloadCompletedNotification(filePath);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _downloadingPaths.remove(key));
    }
  }

  Future<void> _submitAssignment() async {
    if (!_formKey.currentState!.validate()) return;

    final selectedFile = ref.read(selectedFileProvider);
    if (selectedFile == null) {
      Utils.showToast(
        msg: 'Please upload a file',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    ref.read(submitAssignmentLoadingProvider.notifier).state = true;

    final result = await ref.read(submitAssignmentProvider.notifier).submitAssignment(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          media: selectedFile,
          assignmentId: widget.assignmentId,
        );

    ref.read(submitAssignmentLoadingProvider.notifier).state = false;

    if (!mounted) return;

    if (result.success) {
      Utils.showToast(
        msg: result.message,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      ref.read(selectedFileProvider.notifier).state = null;
      _titleController.clear();
      _descriptionController.clear();
      await ref
          .read(getAssignmentDetailsProvider.notifier)
          .getAssignmentDetails(assignmentId: widget.assignmentId);
    } else {
      Utils.showToast(
        msg: result.message,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignmentState = ref.watch(getAssignmentDetailsProvider);

    return assignmentState.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xff030D15),
        body: Column(
          children: [
            SecondaryAppBar(title: 'Assignment'),
            Expanded(child: Center(child: AnimatedLoading())),
          ],
        ),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: const Color(0xff030D15),
        body: Column(
          children: [
            const SecondaryAppBar(title: 'Assignment'),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Text(
                    err.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      data: (model) {
        final assignment = model?.data;
        if (assignment == null) {
          return const Scaffold(
            backgroundColor: Color(0xff030D15),
            body: Column(
              children: [
                SecondaryAppBar(title: 'Assignment'),
                Expanded(
                  child: Center(
                    child: Text(
                      'No assignment data available',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final teacherAttachments = assignment.attachments ?? [];
        final submission = assignment.submission;
        final canSubmit = submission == null;

        return Scaffold(
          backgroundColor: const Color(0xff030D15),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SecondaryAppBar(title: assignment.title ?? 'Assignment'),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15.h),
                      Text(
                        '${assignment.classInfo?.classTitle ?? 'N/A'} : ${assignment.classInfo?.className ?? 'N/A'}',
                        style: TextStyle(
                          color: const Color(0xffFFFFFF),
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '${assignment.module?.moduleTitle ?? 'N/A'} : ${assignment.module?.moduleName ?? 'N/A'}',
                        style: TextStyle(
                          color: const Color(0xff8C9196),
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              color: Colors.red, size: 18.sp),
                          SizedBox(width: 6.w),
                          Text(
                            'Due: ${_formatDate(assignment.submissionDate)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined,
                              color: Colors.orange, size: 18.sp),
                          SizedBox(width: 6.w),
                          Text(
                            _dueDaysLabel(assignment.dueDays),
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Icon(Icons.grade_outlined,
                              color: Colors.red, size: 18.sp),
                          SizedBox(width: 6.w),
                          Text(
                            '${assignment.totalMarks ?? 0} marks',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      const Divider(thickness: 0.7, color: Color(0xff8C9196)),
                      Text(
                        assignment.title ?? 'N/A',
                        style: TextStyle(
                          color: const Color(0xffFFFFFF),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        assignment.description ?? 'N/A',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                      if (teacherAttachments.isNotEmpty) ...[
                        SizedBox(height: 20.h),
                        Text(
                          'Teacher Attachments',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ...teacherAttachments.map(
                          (attachment) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: _AttachmentTile(
                              attachment: attachment,
                              isDownloading: _downloadingPaths.contains(
                                attachment.filePath ?? attachment.fileName,
                              ),
                              onView: () => _viewAttachment(attachment),
                              onDownload: () =>
                                  _downloadAttachment(attachment),
                            ),
                          ),
                        ),
                      ],
                      if (submission != null) ...[
                        SizedBox(height: 20.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xff0A1A2A),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.green.shade700),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Submission',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Divider(color: Color(0xff3D4566)),
                              if (submission.description != null &&
                                  submission.description!.isNotEmpty) ...[
                                Text(
                                  submission.description!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                              ],
                              Text(
                                'Submitted: ${_formatDate(submission.submittedAt ?? assignment.submittedAt)}',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.sp,
                                ),
                              ),
                              if (submission.status != null) ...[
                                SizedBox(height: 6.h),
                                Text(
                                  'Status: ${submission.status}',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                              if (submission.grade != null) ...[
                                SizedBox(height: 6.h),
                                Text(
                                  'Grade: ${submission.grade}',
                                  style: TextStyle(
                                    color: const Color(0xffF9C80E),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                              if ((submission.attachments ?? []).isNotEmpty) ...[
                                SizedBox(height: 12.h),
                                Text(
                                  'Submitted Files',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                ...submission.attachments!.map(
                                  (attachment) => Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: _AttachmentTile(
                                      attachment: attachment,
                                      isDownloading: _downloadingPaths.contains(
                                        attachment.filePath ??
                                            attachment.fileName,
                                      ),
                                      onView: () =>
                                          _viewAttachment(attachment),
                                      onDownload: () =>
                                          _downloadAttachment(attachment),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                      if (canSubmit) ...[
                        SizedBox(height: 20.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffF9C80E)),
                            borderRadius: BorderRadius.circular(16.r),
                            color: const Color(0xff0A1A2A),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Submit Assignment',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                              ),
                              const Divider(
                                thickness: 0.7,
                                color: Color(0xff3D4566),
                              ),
                              Form(
                                key: _formKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Submission Title',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: const Color(0xffB2B5B8),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    CustomTextField(
                                      controller: _titleController,
                                      hintText: 'Enter submission title',
                                      validator: assignmentTitleValidator,
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'Description',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: const Color(0xffB2B5B8),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    CustomTextField(
                                      controller: _descriptionController,
                                      hintText: 'Enter description',
                                      maxLines: 5,
                                      validator: assignmentDescriptionValidator,
                                    ),
                                    SizedBox(height: 20.h),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: pickFile,
                                      child: DottedBorder(
                                        options: RoundedRectDottedBorderOptions(
                                          radius: Radius.circular(16.r),
                                          color: const Color(0xFF3D4566),
                                          strokeWidth: 1.5,
                                          dashPattern: const [6, 5],
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 30.h,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/upload.svg',
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              SizedBox(height: 10.h),
                                              Consumer(
                                                builder: (context, ref, _) {
                                                  final selectedFile = ref.watch(
                                                    selectedFileProvider,
                                                  );

                                                  if (selectedFile == null) {
                                                    return Text(
                                                      'Upload PDF or image here',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16.sp,
                                                      ),
                                                    );
                                                  }

                                                  return Text(
                                                    selectedFile.path
                                                        .split('/')
                                                        .last,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 14.h),
                              PrimaryButton(
                                onTap: _submitAssignment,
                                color: const Color(0xFFE9201D),
                                textColor: Colors.white,
                                icon: '',
                                child: ref.watch(submitAssignmentLoadingProvider)
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Submit',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      SizedBox(height: 14.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        );
      },
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({
    required this.attachment,
    required this.isDownloading,
    required this.onView,
    required this.onDownload,
  });

  final AssignmentAttachment attachment;
  final bool isDownloading;
  final VoidCallback onView;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2136),
        borderRadius: BorderRadius.circular(12.r),
        border: Border(
          left: BorderSide(color: const Color(0xFF5F6CA0), width: 1.5.w),
        ),
      ),
      child: Row(
        children: [
          if (attachment.isPdf)
            SvgPicture.asset('assets/icons/pdf.svg', height: 24.h, width: 24.w)
          else
            Icon(Icons.insert_drive_file_outlined,
                color: const Color(0xFF5F6CA0), size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              attachment.fileName ?? 'N/A',
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: onView,
            child: Icon(Icons.visibility_outlined, color: Colors.red, size: 22.sp),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: isDownloading ? null : onDownload,
            child: isDownloading
                ? SizedBox(
                    width: 22.w,
                    height: 22.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.red,
                    ),
                  )
                : SvgPicture.asset(
                    'assets/icons/download.svg',
                    height: 22.h,
                    width: 22.w,
                  ),
          ),
        ],
      ),
    );
  }
}
