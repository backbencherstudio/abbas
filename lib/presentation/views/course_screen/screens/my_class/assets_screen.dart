import 'package:abbas/presentation/views/course_screen/screens/my_class/widget/pdf_widget.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

import '../../../../widgets/secondary_appber.dart';

class AssetsScreen extends StatelessWidget {
  const AssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: Column(
        children: [
          const SecondaryAppBar(title: "Assets"),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: const TabBar(
                      tabAlignment: TabAlignment.fill,
                      indicatorSize: TabBarIndicatorSize.tab,
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
                  const Expanded(
                    child: TabBarView(children: [VideoWidget(), PdfWidget()]),
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

class LediKhadashProtiva extends StatelessWidget {
  const LediKhadashProtiva({
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
            color: const Color(0xFF0D2136),
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
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasIcon)
                isVideo
                    ? GestureDetector(
                  onTap: onTap,
                  child: Icon(
                    Icons.play_arrow_outlined,
                    color: Colors.red,
                    size: 28.h,
                  ),
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

class VideoWidget extends StatelessWidget {
  const VideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Module 1: Personal Development',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xffB2B5B8),
              ),
            ),
            SizedBox(height: 12.h),
            LediKhadashProtiva(
              title: "Class-01.mp4",
              isVideo: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerScreen(
                      url:
                      "https://dn720702.ca.archive.org/0/items/fantastic-planet__1973/Fantastic.Planet.1973.DUBBED.REMASTERED.1080p.BluRay.H264.AAC.ia.mp4",
                      title: "Class-01.mp4",
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
            LediKhadashProtiva(
              title: "Class-02.mp4",
              isVideo: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerScreen(
                      url:
                      "https://dn720702.ca.archive.org/0/items/fantastic-planet__1973/Fantastic.Planet.1973.DUBBED.REMASTERED.1080p.BluRay.H264.AAC.ia.mp4",
                      title: "Class-02.mp4",
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
            LediKhadashProtiva(
              title: "Class-03.mp4",
              isVideo: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerScreen(
                      url:
                      "https://dn720702.ca.archive.org/0/items/fantastic-planet__1973/Fantastic.Planet.1973.DUBBED.REMASTERED.1080p.BluRay.H264.AAC.ia.mp4",
                      title: "Class-03.mp4",
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
            LediKhadashProtiva(
              title: "Class-04.mp4",
              isVideo: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerScreen(
                      url:
                      "https://dn720702.ca.archive.org/0/items/fantastic-planet__1973/Fantastic.Planet.1973.DUBBED.REMASTERED.1080p.BluRay.H264.AAC.ia.mp4",
                      title: "Class-04.mp4",
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Module 2: Script Analysis",
                  style: TextStyle(
                    color: Color(0xffB2B5B8),
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
            SizedBox(height: 10.h),
            Column(
              spacing: 8.h,
              children: List.generate(4, (index) {
                return LediKhadashProtiva(
                  title: 'Class-0${index + 1}.mp4',
                  isVideo: true,
                );
              }),
            ),
          ],
        ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  final String title;

  const VideoPlayerScreen({super.key, required this.url, required this.title});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      showControls: false,
    );
  }

  @override
  void dispose() {
    _chewieController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SecondaryAppBar(title: 'Videos'),
          SizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showControls = !_showControls;
                      });
                    },
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: _videoPlayerController.value.isInitialized
                          ? AspectRatio(
                        aspectRatio:
                        _videoPlayerController.value.aspectRatio,
                        child: Chewie(controller: _chewieController),
                      )
                          : const CircularProgressIndicator(),
                    ),
                  ),
                  if (_showControls)
                    Positioned(
                      bottom: 400,
                      left: 0,
                      right: 0,
                      child:
                      VideoControls(controller: _videoPlayerController),
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

class VideoControls extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoControls({super.key, required this.controller});

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(() => setState(() {}));
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final position = _controller.value.position;
    final duration = _controller.value.duration;

    return Container(
      color: Colors.black54,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Slider(
                  activeColor: Colors.red,
                  inactiveColor: Colors.grey,
                  min: 0,
                  max: duration.inMilliseconds.toDouble(),
                  value: position.inMilliseconds
                      .clamp(0, duration.inMilliseconds)
                      .toDouble(),
                  onChanged: (value) {
                    _controller.seekTo(Duration(milliseconds: value.toInt()));
                  },
                ),
              ),
              Text(
                formatDuration(position),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              const Text(
                ' / ',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                formatDuration(duration),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.replay_10,
                    color: Colors.white, size: 20),
                onPressed: () {
                  final current = _controller.value.position;
                  _controller.seekTo(current - const Duration(seconds: 10));
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward_10,
                    color: Colors.white, size: 20),
                onPressed: () {
                  final current = _controller.value.position;
                  _controller.seekTo(current + const Duration(seconds: 10));
                },
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.volume_up,
                    color: Colors.white, size: 20),
                onPressed: () {
                  final currentVolume = _controller.value.volume;
                  _controller.setVolume(currentVolume > 0 ? 0 : 1);
                },
              ),
              IconButton(
                icon: const Icon(Icons.mode_comment_outlined,
                    color: Colors.white, size: 20),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out_map,
                    color: Colors.white, size: 20),
                onPressed: () {},
              ),
              IconButton(
                icon:
                const Icon(Icons.more_vert, color: Colors.white, size: 20),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('More button pressed')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}