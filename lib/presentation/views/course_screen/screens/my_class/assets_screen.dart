import 'dart:io';

import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/course_screen/model/class_assets_model.dart';
import 'package:abbas/presentation/views/course_screen/screens/my_class/widget/pdf_widget.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../widgets/secondary_appber.dart';

class AssetsScreen extends ConsumerStatefulWidget {
  final String classId;

  const AssetsScreen({super.key, required this.classId});

  @override
  ConsumerState<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends ConsumerState<AssetsScreen> {
  final Set<String> _downloadingIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getClassAssetsProvider.notifier)
          .getClassAssets(classId: widget.classId);
    });
  }

  Future<void> _downloadAsset(ClassAssetItem item) async {
    final url = item.filePath;
    final fileName = item.fileName ?? 'download';
    final itemId = item.id;

    if (url == null || url.isEmpty || itemId == null) return;
    if (_downloadingIds.contains(itemId)) return;

    setState(() => _downloadingIds.add(itemId));

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
      if (mounted) {
        setState(() => _downloadingIds.remove(itemId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final assetsState = ref.watch(getClassAssetsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Assets'),
          Expanded(
            child: assetsState.when(
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
                final videos = model?.data?.videos ?? [];
                final files = model?.data?.files ?? [];

                return DefaultTabController(
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
                            Tab(text: 'FILE'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildAssetList(
                              items: videos,
                              emptyIcon: Icons.video_file,
                              emptyMessage: 'No videos available',
                            ),
                            _buildFileList(items: files),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetList({
    required List<ClassAssetItem> items,
    required IconData emptyIcon,
    required String emptyMessage,
  }) {
    if (items.isEmpty) {
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
      children: items.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: AssetsWidget(
            title: item.fileName ?? 'N/A',
            onTap: () {
              if (item.filePath == null || item.filePath!.isEmpty) return;

              Navigator.pushNamed(
                context,
                RouteNames.videoPlayerScreen,
                arguments: {
                  'asset_url': item.filePath,
                  'file_name': item.fileName,
                },
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFileList({required List<ClassAssetItem> items}) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insert_drive_file, color: Colors.white, size: 50.sp),
            SizedBox(height: 10.h),
            Text(
              'No files available',
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
      children: items.map((item) {
        final itemId = item.id ?? '';
        final isDownloading = _downloadingIds.contains(itemId);

        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: FileAssetWidget(
            title: item.fileName ?? 'N/A',
            isDownloading: isDownloading,
            onDownload: () => _downloadAsset(item),
          ),
        );
      }).toList(),
    );
  }
}

class AssetsWidget extends StatelessWidget {
  const AssetsWidget({
    super.key,
    required this.title,
    this.onTap,
  });

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 60.h,
          width: double.infinity,
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
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
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

class FileAssetWidget extends StatelessWidget {
  const FileAssetWidget({
    super.key,
    required this.title,
    required this.onDownload,
    this.isDownloading = false,
  });

  final String title;
  final VoidCallback onDownload;
  final bool isDownloading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      width: double.infinity,
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
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
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
    );
  }
}
