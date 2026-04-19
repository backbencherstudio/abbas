import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../cors/routes/route_names.dart';
import '../../../../../cors/theme/app_colors.dart';
import '../../../../widgets/animated_loading.dart';
import '../../../../widgets/secondary_appber.dart';

class HomeCourseAssetsScreen extends ConsumerStatefulWidget {
  final String courseId;

  const HomeCourseAssetsScreen({super.key, required this.courseId});

  @override
  ConsumerState<HomeCourseAssetsScreen> createState() =>
      _HomeCourseAssetsScreenState();
}

class _HomeCourseAssetsScreenState
    extends ConsumerState<HomeCourseAssetsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(getCourseAssetsProvider.notifier)
          .getCourseAssets(courseId: widget.courseId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final assets = ref.watch(getCourseAssetsProvider);
    final data = assets.value?.data;
    final videos = data?.videos ?? [];
    final pdfs = data?.pdfs ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SecondaryAppBar(title: "Assets"),
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
                        Tab(text: "Videos"),
                        Tab(text: "PDF"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // -------------------- Videos ------------------------
                        assets.isLoading
                            ? const AnimatedLoading()
                            : videos.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.video_file,
                                      color: Colors.white,
                                      size: 50.sp,
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      "No videos available",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView(
                                padding: EdgeInsets.all(16.r),
                                children: videos.map((video) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent,
                                      iconTheme: const IconThemeData(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: ExpansionTile(
                                      title: Text(
                                       " ${video.moduleTitle ?? 'N/A'} : ${video.moduleName ?? 'N/A'}" ,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      children: (video.assets ?? []).map((
                                        asset,
                                      ) {
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 8.h),
                                          child: AssetsWidget(
                                            title: asset.fileName ?? 'N/A',
                                            isVideo: true,
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                RouteNames.videoPlayerScreen,
                                                arguments: {
                                                  'asset_url': asset.assetUrl,
                                                  'file_name': asset.fileName,
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }).toList(),
                              ),

                        /// -------------------- PDFs --------------------------
                        assets.isLoading
                            ? const AnimatedLoading()
                            : pdfs.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.white,
                                      size: 50.sp,
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      "No PDFs available",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView(
                                padding: EdgeInsets.all(16.r),
                                children: pdfs.map((pdfModule) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent,
                                      iconTheme: const IconThemeData(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: ExpansionTile(
                                      title: Text(
                                        pdfModule.moduleTitle ?? 'N/A',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      children: (pdfModule.assets ?? []).map((
                                        asset,
                                      ) {
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 8.h),
                                          child: AssetsWidget(
                                            title: asset.fileName ?? 'N/A',
                                            isVideo: false,
                                            hasIcon: false,
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                RouteNames.pdfViewerScreen,
                                                arguments: {
                                                  'asset_url': asset.assetUrl,
                                                  'file_name': asset.fileName,
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }).toList(),
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
}

/// Reusable widget for Videos and PDFs
class AssetsWidget extends StatelessWidget {
  const AssetsWidget({
    super.key,
    required this.title,
    this.hasIcon = true,
    this.isVideo = false,
    this.onTap,
  });

  final String title;
  final bool hasIcon;
  final bool isVideo;
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
                isVideo
                    ? 'assets/icons/video_stroke.svg'
                    : 'assets/icons/pdf.svg',
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
              if (hasIcon)
                Icon(Icons.play_arrow_outlined, color: Colors.red, size: 28.h),
            ],
          ),
        ),
      ),
    );
  }
}
