import 'dart:io';
import 'package:abbas/cors/services/api_client.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/validator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../../../cors/routes/route_names.dart';
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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

  /// -------------------- Process Media Files --------------------------------------

  // Future<void> pickMedia() async {
  //   try {
  //     final XFile? pickedFile = await _picker.pickImage(
  //       source: ImageSource.gallery,
  //     );
  //     if (pickedFile != null) {
  //       ref.read(selectedFileProvider.notifier).state = File(pickedFile.path);
  //     }
  //   } catch (e) {
  //     logger.e('Error picking file: $e');
  //   }
  // }

  Future<void> pickPdf() async {
    try {
      // Open file picker for PDF files only
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        File pdfFile = File(result.files.single.path!);
        ref.read(selectedFileProvider.notifier).state = pdfFile;
      }
    } catch (e) {
      logger.e('Error picking PDF file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignmentWatchValues = ref.watch(getAssignmentDetailsProvider);
    return assignmentWatchValues.when(
      loading: () => CircularProgressIndicator(color: Colors.white),
      error: (err, stackTrace) => Center(child: Text("Error : $err")),
      data: (data) {
        final assignment = data;
        return Scaffold(
          backgroundColor: Color(0xff030D15),

          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SecondaryAppBar(title: assignment?.data?.title ?? 'N/A'),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),

                      Text(
                        "${assignment?.data?.moduleClass?.classTitle ?? 'N/A'} : ${assignment?.data?.moduleClass?.className ?? 'N/A'}",
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "${assignment?.data?.moduleClass?.module?.moduleTitle}: ${assignment?.data?.moduleClass?.module?.moduleName ?? 'N/A'}",
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
                            "Due : ${formattedDate(assignment?.data?.dueDate ?? 'N/A')} days",
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
                        assignment?.data?.title ?? 'N/A',
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 12.h),
                      Text(
                        assignment?.data?.description ?? 'N/A',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffF9C80E)),
                          borderRadius: BorderRadius.circular(16.r),
                          color: Color(0xff0A1A2A),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Submit Assignment",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                            Divider(thickness: 0.7, color: Color(0xff3D4566)),
                            Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Assignment Title",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Color(0xffB2B5B8),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  CustomTextField(
                                    controller: _titleController,
                                    hintText: "Enter assignment title",
                                    validator: assignmentTitleValidator,
                                  ),

                                  SizedBox(height: 16.h),
                                  Text(
                                    "Description",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Color(0xffB2B5B8),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  CustomTextField(
                                    controller: _descriptionController,
                                    hintText: "Enter description",
                                    maxLines: 5,
                                    validator: assignmentDescriptionValidator,
                                  ),
                                  SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () async {
                                      // await pickMedia();
                                      await pickPdf();
                                    },
                                    child: DottedBorder(
                                      options: RoundedRectDottedBorderOptions(
                                        radius: Radius.circular(16.r),
                                        color: const Color(0xFF3D4566),
                                        strokeWidth: 1.5,
                                        dashPattern: [6, 5],
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          // reduced horizontal padding to fit longer names
                                          vertical: 30.h,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/upload.svg",
                                              // ignore: deprecated_member_use
                                              color: Colors.white,
                                            ),
                                            SizedBox(height: 10.h),

                                            // ── This is the dynamic part ────────────────────────────────
                                            Consumer(
                                              builder: (context, ref, child) {
                                                final selectedFile = ref.watch(
                                                  selectedFileProvider,
                                                );

                                                if (selectedFile == null) {
                                                  return Column(
                                                    children: [
                                                      Text(
                                                        "Files upload here",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Column(
                                                    children: [
                                                      SizedBox(height: 8.h),
                                                      Text(
                                                        selectedFile.path
                                                            .split('/')
                                                            .last,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      SizedBox(height: 4.h),
                                                    ],
                                                  );
                                                }
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
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  logger.d(
                                    "Title : ${_titleController.text.trim()}",
                                  );
                                  logger.d(
                                    "Description : ${_descriptionController.text.trim()}",
                                  );
                                  logger.d(
                                    "Media : ${ref.read(selectedFileProvider)?.path ?? ''}",
                                  );

                                  final result = await ref
                                      .read(submitAssignmentProvider.notifier)
                                      .submitAssignment(
                                        title: _titleController.text.trim(),
                                        description: _descriptionController.text
                                            .trim(),
                                        media: ref.read(selectedFileProvider)!,
                                        assignmentId: widget.assignmentId,
                                      );

                                  if (result.success) {
                                    Utils.showToast(
                                      msg: result.message,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                    );
                                    if (context.mounted) {
                                      Navigator.pushNamed(
                                        context,
                                        RouteNames.submittedAssignmentScreen,
                                        arguments: widget.assignmentId,
                                      );
                                    }
                                  } else {
                                    Utils.showToast(
                                      msg: result.message,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                    );
                                  }
                                }
                              },
                              color: Color(0xFFE9201D),
                              textColor: Colors.white,
                              icon: '',
                              child: ref.watch(submitAssignmentLoadingProvider)
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Text(
                                      "Submit",
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
                      SizedBox(height: 14.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
