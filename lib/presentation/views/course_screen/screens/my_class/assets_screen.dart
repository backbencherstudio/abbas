import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/course_screen/view_model/get_all_courses_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../widgets/secondary_appber.dart';

class AssetsScreen extends ConsumerStatefulWidget {
  final String courseId;

  const AssetsScreen({super.key, required this.courseId});

  @override
  ConsumerState<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends ConsumerState<AssetsScreen> {
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
    final data = assets.value;
    final videosValue = data?.data?.videos ?? [];
    final pdfsValue = data?.data?.pdfs ?? [];

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
                            ? AnimatedLoading()
                            : data?.data == null
                            ? Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "No data available",
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
                                children: videosValue.map((video) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent,
                                      iconTheme: const IconThemeData(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: ExpansionTile(
                                      title: Text(
                                        '${video.moduleTitle ?? 'N/A'}: ${video.moduleName ?? 'N/A'}',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xffB2B5B8),
                                        ),
                                      ),
                                      children: (video.assets ?? [])
                                          .map(
                                            (asset) => Padding(
                                              padding: EdgeInsets.only(
                                                bottom: 8.h,
                                              ),
                                              child: AssetsWidget(
                                                title: asset.fileName ?? 'N/A',
                                                isVideo: true,
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    RouteNames
                                                        .videoPlayerScreen,
                                                    arguments: {
                                                      'asset_url':
                                                          asset.assetUrl,
                                                      'file_name':
                                                          asset.fileName,
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  );
                                }).toList(),
                              ),

                        /// -------------------- PDFs --------------------------
                        assets.isLoading
                            ? AnimatedLoading()
                            : data?.data == null
                            ? Center(
                                child: Text(
                                  "No data available",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : ListView(
                                padding: EdgeInsets.all(16.w),
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: pdfsValue.map((pdfModule) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent,
                                          iconTheme: const IconThemeData(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: ExpansionTile(
                                          title: Text(
                                            pdfModule.moduleTitle ?? 'Module',
                                            style: TextStyle(
                                              color: const Color(0xffB2B5B8),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          children: (pdfModule.assets ?? [])
                                              .map(
                                                (pdfAsset) => Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom: 8.h,
                                                  ),
                                                  child: AssetsWidget(
                                                    title:
                                                        pdfAsset.fileName ??
                                                        'N/A',
                                                    isVideo: false,
                                                    onTap: () {
                                                      logger.d("Pdf url : ${pdfAsset.assetUrl}");
                                                      logger.d("Pdf file name : ${pdfAsset.fileName}");
                                                      Navigator.pushNamed(
                                                        context,
                                                        RouteNames.pdfViewerScreen,
                                                        arguments: {
                                                          'asset_url': pdfAsset.assetUrl,
                                                          'file_name': pdfAsset.fileName,
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
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
                isVideo
                    ? Icon(
                        Icons.play_arrow_outlined,
                        color: Colors.red,
                        size: 28.h,
                      )
                    : SvgPicture.asset(
                        'assets/icons/download.svg',
                        height: 24.h,
                        width: 24.w,
                      ),
            ],
          ),
        ),
      ),
    );
  }
}
