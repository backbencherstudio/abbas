import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Full-screen pinch-zoom image gallery for post attachments.
class CommunityImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const CommunityImageViewer({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  static Future<void> open(
    BuildContext context, {
    required List<String> imageUrls,
    int initialIndex = 0,
  }) {
    if (imageUrls.isEmpty) return Future.value();
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CommunityImageViewer(
          imageUrls: imageUrls,
          initialIndex: initialIndex.clamp(0, imageUrls.length - 1),
        ),
      ),
    );
  }

  @override
  State<CommunityImageViewer> createState() => _CommunityImageViewerState();
}

class _CommunityImageViewerState extends State<CommunityImageViewer> {
  late final ExtendedPageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = ExtendedPageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.imageUrls;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: urls.length > 1
            ? Text(
                '${_currentIndex + 1} / ${urls.length}',
                style: TextStyle(fontSize: 16.sp),
              )
            : null,
      ),
      body: ExtendedImageGesturePageView.builder(
        controller: _pageController,
        itemCount: urls.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) {
          return ExtendedImage.network(
            urls[index],
            fit: BoxFit.contain,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: (_) => GestureConfig(
              minScale: 0.9,
              animationMinScale: 0.7,
              maxScale: 4.0,
              animationMaxScale: 4.5,
              speed: 1.0,
              inertialSpeed: 100.0,
              initialScale: 1.0,
              inPageView: true,
              initialAlignment: InitialAlignment.center,
            ),
            loadStateChanged: (state) {
              if (state.extendedImageLoadState == LoadState.loading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              if (state.extendedImageLoadState == LoadState.failed) {
                return Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white54,
                    size: 48.sp,
                  ),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
