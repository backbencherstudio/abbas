import 'package:abbas/cors/network/api_response_handle.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommunityVideoWidget extends StatefulWidget {
  final String videoUrl;

  const CommunityVideoWidget({super.key, required this.videoUrl});

  @override
  State<CommunityVideoWidget> createState() => _CommunityVideoWidgetState();
}

class _CommunityVideoWidgetState extends State<CommunityVideoWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    logger.d("video url: ${widget.videoUrl}");
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      showControls: true,
      allowPlaybackSpeedChanging: false,
      autoInitialize: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.red,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.white,
      ),
      placeholder: Container(
        color: Colors.black26,
      ),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Column(
            children: [
              Icon(
                Icons.error,
                size: 24.sp,
                color: Colors.red,
              ),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
    
    // Listen to video player controller to ensure we force a redraw if needed
    _videoPlayerController.addListener(() {
      if (mounted) {
        setState(() {}); // Guarantees UI gets refreshed
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(() {});
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController != null && _chewieController!.videoPlayerController.value.isInitialized) {
      return Container(
        height: 250.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.black,
        ),
        clipBehavior: Clip.hardEdge,
        child: Chewie(
          controller: _chewieController!,
        ),
      );
    } else {
      return Container(
        height: 250.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        ),
      );
    }
  }
}
