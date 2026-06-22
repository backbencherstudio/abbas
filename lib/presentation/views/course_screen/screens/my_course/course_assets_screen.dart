import 'dart:io';

import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/course_screen/model/course_assets_model.dart';
import 'package:abbas/presentation/views/course_screen/screens/my_class/widget/pdf_widget.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';

class CourseAssetsScreen extends ConsumerStatefulWidget {
  final String courseId;

  const CourseAssetsScreen({super.key, required this.courseId});

  @override
  ConsumerState<CourseAssetsScreen> createState() => _CourseAssetsScreenState();
}

class _CourseAssetsScreenState extends ConsumerState<CourseAssetsScreen> {
  final Set<String> _downloadingPaths = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getCourseAssetsProvider.notifier)
          .loadCourseAssets(courseId: widget.courseId);
    });
  }

  Future<void> _downloadAsset(CourseAssetItem item) async {
    final url = item.filePath;
    final fileName = item.fileName ?? 'download';
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

  void _viewAsset(CourseAssetItem item) {
    final url = item.filePath;
    if (url == null || url.isEmpty) return;

    if (item.isVideo) {
      Navigator.pushNamed(
        context,
        RouteNames.videoPlayerScreen,
        arguments: {
          'asset_url': url,
          'file_name': item.fileName,
        },
      );
      return;
    }

    Navigator.pushNamed(
      context,
      RouteNames.pdfViewerScreen,
      arguments: {
        'asset_url': url,
        'file_name': item.fileName,
        'mime_type': item.mimeType,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final assetsState = ref.watch(getCourseAssetsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Assets'),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: const TabBar(
                      indicatorColor: Colors.red,
                      indicatorWeight: 2,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Videos'),
                        Tab(text: 'PDF'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildAssetsTab(
                          assetsState.videos,
                          assetType: 'VIDEO',
                          emptyIcon: Icons.video_file,
                          emptyMessage: 'No videos available',
                          isVideo: true,
                        ),
                        _buildAssetsTab(
                          assetsState.files,
                          assetType: 'FILE',
                          emptyIcon: Icons.picture_as_pdf,
                          emptyMessage: 'No PDFs available',
                          isVideo: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetsTab(
    AsyncValue<CourseAssetsModel?> tabState, {
    required String assetType,
    required IconData emptyIcon,
    required String emptyMessage,
    required bool isVideo,
  }) {
    return tabState.when(
      loading: () => const Center(child: AnimatedLoading()),
      error: (error, _) => Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
        ),
      ),
      data: (model) {
        final modules = (model?.data ?? [])
            .asMap()
            .entries
            .map(
              (entry) => (
                key: entry.key,
                module: entry.value,
                assets: entry.value.assetsByType(assetType),
              ),
            )
            .where((entry) => entry.assets.isNotEmpty)
            .toList();

        if (modules.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(emptyIcon, color: Colors.white, size: 50.sp),
                SizedBox(height: 10.h),
                Text(
                  emptyMessage,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.all(16.r),
          children: modules.asMap().entries.map((indexedEntry) {
            final listIndex = indexedEntry.key;
            final entry = indexedEntry.value;
            final originalIndex = entry.key;
            final module = entry.module;
            final assets = entry.assets;
            final moduleTitle = _moduleHeaderTitle(
              originalIndex: originalIndex,
              module: module,
            );

            return Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              child: ExpansionTile(
                initiallyExpanded: listIndex == 0,
                title: Text(
                  moduleTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                children: assets.map((asset) {
                  final isDownloading = _downloadingPaths.contains(
                    asset.filePath ?? asset.fileName,
                  );

                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: isVideo
                        ? _VideoAssetTile(
                            fileName: asset.fileName ?? 'N/A',
                            onTap: () => _viewAsset(asset),
                          )
                        : _FileAssetTile(
                            fileName: asset.fileName ?? 'N/A',
                            isDownloading: isDownloading,
                            onTap: () => _viewAsset(asset),
                            onDownload: () => _downloadAsset(asset),
                          ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String _moduleHeaderTitle({
    required int originalIndex,
    required CourseAssetsModule module,
  }) {
    final title = module.moduleTitle ?? 'N/A';
    if (originalIndex == 0) return 'Module 1: $title';
    return title;
  }
}

class _VideoAssetTile extends StatelessWidget {
  const _VideoAssetTile({required this.fileName, required this.onTap});

  final String fileName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 60.h,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF101923),
            borderRadius: BorderRadius.circular(12.r),
            border: Border(
              left: BorderSide(color: const Color(0xFF5F6CA0), width: 1.5.w),
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/video_stroke.svg',
                height: 24.h,
                width: 24.w,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  fileName,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.play_arrow_outlined, color: Colors.red, size: 28.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _FileAssetTile extends StatelessWidget {
  const _FileAssetTile({
    required this.fileName,
    required this.isDownloading,
    required this.onTap,
    required this.onDownload,
  });

  final String fileName;
  final bool isDownloading;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 60.h,
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
                'assets/icons/pdf.svg',
                height: 24.h,
                width: 24.w,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  fileName,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: isDownloading ? null : onDownload,
                child: isDownloading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.red,
                        ),
                      )
                    : SvgPicture.asset(
                        'assets/icons/download.svg',
                        height: 24.h,
                        width: 24.w,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
