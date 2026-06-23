import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import 'package:abbas/cors/network/api_response_handle.dart';

class CommunityVideoWidget extends StatefulWidget {
  final String videoUrl;

  const CommunityVideoWidget({super.key, required this.videoUrl});

  @override
  State<CommunityVideoWidget> createState() => _CommunityVideoWidgetState();
}

class _CommunityVideoWidgetState extends State<CommunityVideoWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  String? _error;

  // The app is locked to portrait (see main.dart). Keep Chewie's fullscreen in
  // portrait too, otherwise iOS rejects the landscape request and throws
  // "None of the requested orientations are supported by the view controller".
  static const List<DeviceOrientation> _portraitOnly = [
    DeviceOrientation.portraitUp,
  ];

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    logger.d("video url: ${widget.videoUrl}");

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    _videoPlayerController = controller;

    try {
      await controller.initialize();

      // Guard against the widget being disposed mid-initialization.
      if (!mounted) {
        await controller.dispose();
        return;
      }

      _chewieController = ChewieController(
        videoPlayerController: controller,
        autoPlay: false,
        looping: false,
        showControls: true,
        allowPlaybackSpeedChanging: false,
        allowFullScreen: true,
        deviceOrientationsOnEnterFullScreen: _portraitOnly,
        deviceOrientationsAfterFullScreen: _portraitOnly,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white,
        ),
        placeholder: Container(color: Colors.black26),
      );

      setState(() => _isInitialized = true);
    } catch (e) {
      logger.e("video init error: $e");
      if (mounted) {
        setState(() => _error = 'Unable to play this video');
      }
    }
  }

  @override
  void dispose() {
    // Dispose Chewie first (it detaches its listeners), then the underlying
    // video controller that we own.
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.r),
      ),
      clipBehavior: Clip.hardEdge,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 28.sp, color: Colors.red),
            SizedBox(height: 8.h),
            Text(
              _error!,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final chewie = _chewieController;
    if (_isInitialized && chewie != null) {
      return Chewie(controller: chewie);
    }

    return const Center(
      child: CircularProgressIndicator(color: Colors.red),
    );
  }
}
