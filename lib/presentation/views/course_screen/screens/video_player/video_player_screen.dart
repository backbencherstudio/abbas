import 'package:abbas/cors/theme/app_colors.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import '../../../../widgets/secondary_appber.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String assetUrl;
  final String fileName;

  const VideoPlayerScreen({
    super.key,
    required this.assetUrl,
    required this.fileName,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      /// Show warning if HTTP URL
      if (widget.assetUrl.startsWith('http:') &&
          !widget.assetUrl.startsWith('https:')) {
        debugPrint(
          '⚠️ Loading video from HTTP URL. May not work on some Android devices.',
        );
      }

      /// Initialize VideoPlayerController
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.assetUrl));

      await _videoPlayerController.initialize().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Video loading timed out');
        },
      );

      /// Listen for player errors
      _videoPlayerController.addListener(() {
        if (_videoPlayerController.value.hasError) {
          setState(() {
            _hasError = true;
            _errorMessage =
                _videoPlayerController.value.errorDescription ?? 'Unknown error';
          });
        }
      });

      /// Initialize ChewieController
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: true,
        allowMuting: true,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        placeholder: Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
                SizedBox(height: 8.h),
                Text(
                  'Error loading video',
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _retryLoading() {
    setState(() {
      _isInitialized = false;
      _hasError = false;
      _errorMessage = '';
    });

    _chewieController?.dispose();
    _videoPlayerController.dispose();

    _initVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Videos'),
          SizedBox(height: 10.h),

          /// ------------------------ File name header ------------------------
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.fileName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          /// ------------------------ Video player area -----------------------
          Expanded(child: _buildVideoContent()),

          // HTTP warning
          if (widget.assetUrl.startsWith('http:') &&
              !widget.assetUrl.startsWith('https:'))
            Container(
              color: Colors.orange.shade900,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Using insecure HTTP connection. Video may not play on some devices.',
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoContent() {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 64.sp),
            SizedBox(height: 16.h),
            Text(
              'Failed to load video',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                _errorMessage.contains('Cleartext HTTP traffic')
                    ? 'HTTP traffic is not permitted on this device. Use HTTPS or configure network security.'
                    : _errorMessage,
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: _retryLoading,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (!_isInitialized || _chewieController == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 16.h),
            Text(
              'Loading video...',
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            ),
          ],
        ),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        child: Chewie(controller: _chewieController!),
      ),
    );
  }
}