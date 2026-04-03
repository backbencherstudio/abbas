import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';
import '../provider/call_provider.dart';

class VideoCallScreen extends StatefulWidget {
  final String conversationId;
  final String callKind;

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
  bool _hasStarted = false;
  bool _callStarted = false;

  final ValueNotifier<int> _timerNotifier = ValueNotifier(0);

  bool get isVideo => widget.callKind.toUpperCase() == "VIDEO";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasStarted) {
        _hasStarted = true;
        _startCall();
      }
    });
  }

  Future<void> _startCall() async {
    if (!mounted) return;
    final provider = Provider.of<CallProvider>(context, listen: false);

    // যদি ইউজার অলরেডি কলে জয়েন করে থাকে (অর্থাৎ সে কল রিসিভ করেছে), তবে নতুন করে কল শুরু করবে না
    if (provider.isInCall) {
      setState(() {
        _callStarted = true;
      });
      _startCallTimer();
      return;
    }

    // শুধুমাত্র কলার (যে কল দিচ্ছে) এই অংশটি রান করবে
    final success = await provider.startCall(
      widget.conversationId,
      kind: widget.callKind,
    );

    if (success && mounted) {
      setState(() {
        _callStarted = true;
      });
      _startCallTimer();
    } else if (!success && mounted) {
      Navigator.pop(context);
    }
  }

  void _startCallTimer() {
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) _timerNotifier.value = ++_seconds;
    });
  }

  // FIX: only leaveCall if call was actually started
  @override
  void dispose() {
    _callTimer?.cancel();
    _timerNotifier.dispose();
    if (_callStarted) {
      final provider = Provider.of<CallProvider>(context, listen: false);
      if (provider.isInCall) {
        provider.leaveCall(widget.conversationId);
      }
    }
    super.dispose();
  }

  String _formatTime(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _endCall() async {
    _callStarted = false;
    final provider = Provider.of<CallProvider>(context, listen: false);
    await provider.endCall(widget.conversationId);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer<CallProvider>(
          builder: (context, provider, _) {
            final liveKit = provider.liveKitService;
            final isConnecting = provider.isLoading;
            final hasError = provider.errorMessage != null;

            return Stack(
              children: [
                // ── Background / Remote Video ──────────────────────────
                if (isVideo && liveKit.remoteVideoTrack != null)
                  Positioned.fill(
                    child: VideoTrackRenderer(
                      liveKit.remoteVideoTrack!,
                      fit: VideoViewFit.cover,
                    ),
                  )
                else
                  _buildWaitingBackground(
                    isConnecting,
                    hasError,
                    provider.errorMessage,
                  ),

                // ── Local Video (PiP) ──────────────────────────────────
                if (isVideo && liveKit.localVideoTrack != null)
                  Positioned(
                    top: 40.h,
                    right: 16.w,
                    child: _localVideoWidget(liveKit.localVideoTrack!),
                  ),

                // ── Audio call avatar ──────────────────────────────────
                if (!isVideo)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 52.r,
                          backgroundColor: Colors.grey[800],
                          child: Icon(
                            Icons.person,
                            size: 60.r,
                            color: Colors.white54,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "Audio Call",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        ValueListenableBuilder<int>(
                          valueListenable: _timerNotifier,
                          builder: (_, sec, __) => Text(
                            sec == 0 ? "Connecting..." : _formatTime(sec),
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // ── Timer (video call only) ────────────────────────────
                if (isVideo)
                  Positioned(
                    top: 16.h,
                    left: 0,
                    right: 0,
                    child: ValueListenableBuilder<int>(
                      valueListenable: _timerNotifier,
                      builder: (_, seconds, __) => Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(
                            seconds == 0
                                ? "Connecting..."
                                : _formatTime(seconds),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // ── Bottom Controls ────────────────────────────────────
                Positioned(
                  bottom: 48.h,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Mute
                      _controlButton(
                        icon: provider.isMuted ? Icons.mic_off : Icons.mic,
                        color: provider.isMuted
                            ? Colors.redAccent
                            : Colors.white,
                        onTap: provider.toggleMute,
                      ),
                      // Video toggle (video call only)
                      if (isVideo)
                        _controlButton(
                          icon: provider.isVideoEnabled
                              ? Icons.videocam
                              : Icons.videocam_off,
                          color: provider.isVideoEnabled
                              ? Colors.white
                              : Colors.redAccent,
                          onTap: provider.toggleVideo,
                        ),
                      // Switch camera (video call only)
                      if (isVideo)
                        _controlButton(
                          icon: Icons.flip_camera_ios,
                          color: Colors.white,
                          onTap: () => provider.switchCamera(),
                        ),
                      // End call
                      _controlButton(
                        icon: Icons.call_end,
                        color: Colors.red,
                        size: 70,
                        onTap: _endCall,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWaitingBackground(
    bool isConnecting,
    bool hasError,
    String? errorMsg,
  ) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasError) ...[
              Icon(Icons.error_outline, color: Colors.redAccent, size: 48.r),
              SizedBox(height: 16.h),
              Text(
                errorMsg ?? "Something went wrong",
                style: TextStyle(color: Colors.redAccent, fontSize: 15.sp),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              SizedBox(height: 24.h),
              Text(
                isConnecting
                    ? "Setting up call..."
                    : "Waiting for participant...",
                style: TextStyle(color: Colors.white60, fontSize: 16.sp),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _localVideoWidget(VideoTrack track) {
    return Container(
      width: 120.w,
      height: 170.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white30, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: VideoTrackRenderer(track, fit: VideoViewFit.cover),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    double size = 58,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.r,
        height: size.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.15),
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(icon, color: color, size: (size * 0.46).r),
      ),
    );
  }
}
