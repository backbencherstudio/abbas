// video_call_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';
import '../provider/call_provider.dart';

class VideoCallScreen extends StatefulWidget {
  final String conversationId;
  final String callKind; // "AUDIO" or "VIDEO"

  const VideoCallScreen({
    super.key,
    required this.conversationId,
    this.callKind = "VIDEO",
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  Timer? _callTimer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCall();
    });
  }

  Future<void> _startCall() async {
    if (!mounted) return;

    final provider = Provider.of<CallProvider>(context, listen: false);

    setState(() {}); // Force rebuild if needed

    final success = await provider.startCall(
      widget.conversationId,
      kind: widget.callKind,
    );

    if (success && mounted) {
      _startCallTimer();
    } else if (mounted && provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? "Call failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _startCallTimer() {
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _seconds++);
      }
    });
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    if (mounted) {
      final provider = Provider.of<CallProvider>(context, listen: false);
      provider.leaveCall(widget.conversationId);
    }
    super.dispose();
  }

  String _formatTime() {
    final min = _seconds ~/ 60;
    final sec = _seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CallProvider>();
    final liveKit = provider.liveKitService;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: provider.isLoading
            ? const Center(
          child: CircularProgressIndicator(color: Colors.white),
        )
            : provider.errorMessage != null
            ? _buildError(provider)
            : Stack(
          children: [
            // Remote Video - Full Screen
            if (liveKit.remoteVideoTrack != null)
              Positioned.fill(
                child: VideoTrackRenderer(
                  liveKit.remoteVideoTrack!,
                //  fit: VideoFit.cover,
                ),
              )
            else
              Container(
                color: Colors.black87,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 24.h),
                      const Text(
                        "Waiting for other participant...",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      if (provider.currentCallKind == "VIDEO")
                        const Text(
                          "They might be connecting video...",
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                    ],
                  ),
                ),
              ),

            // Local Video (Picture-in-Picture)
            if (liveKit.localVideoTrack != null && widget.callKind == "VIDEO")
              Positioned(
                top: 40.h,
                right: 20.w,
                child: Container(
                  width: 130.w,
                  height: 180.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.white38, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: VideoTrackRenderer(
                      liveKit.localVideoTrack!,
                    //  fit: VideoFit.cover,
                    ),
                  ),
                ),
              ),

            // Top Status Bar
            Positioned(
              top: 20.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      _formatTime(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Control Buttons
            Positioned(
              bottom: 50.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Mute Button
                  _controlButton(
                    icon: provider.isMuted ? Icons.mic_off : Icons.mic,
                    color: provider.isMuted ? Colors.redAccent : Colors.white,
                    onTap: provider.toggleMute,
                  ),

                  // Video Toggle (only for VIDEO call)
                  if (widget.callKind == "VIDEO")
                    _controlButton(
                      icon: provider.isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                      color: provider.isVideoEnabled ? Colors.white : Colors.redAccent,
                      onTap: provider.toggleVideo,
                    ),

                  // Switch Camera
                  if (widget.callKind == "VIDEO")
                    _controlButton(
                      icon: Icons.flip_camera_ios,
                      color: Colors.white,
                      onTap: () async {
                        await provider.switchCamera();
                      },
                    ),

                  // End Call Button
                  _controlButton(
                    icon: Icons.call_end,
                    color: Colors.red,
                    size: 72,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(CallProvider provider) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 80),
            SizedBox(height: 20.h),
            Text(
              "Call Failed",
              style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            Text(
              provider.errorMessage ?? "Something went wrong",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 15.sp),
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 14.h),
              ),
              child: const Text("Go Back", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    double size = 60,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.r,
        height: size.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.15),
          border: Border.all(color: color, width: 2.5),
        ),
        child: Icon(
          icon,
          color: color,
          size: (size * 0.48).r,
        ),
      ),
    );
  }
}