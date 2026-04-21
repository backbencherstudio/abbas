import 'dart:async';

import 'package:abbas/presentation/views/message/provider/call_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

class VideoCallScreen extends StatefulWidget {
  final String conversationId;
  final String callKind;
  final bool autoStart;

  const VideoCallScreen({
    super.key,
    required this.conversationId,
    this.callKind = 'VIDEO',
    this.autoStart = true,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  Timer? _timer;
  final ValueNotifier<int> _timerNotifier = ValueNotifier<int>(0);
  bool _callStarted = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<CallProvider>();

      if (widget.autoStart) {
        final success = await provider.startCall(
          widget.conversationId,
          kind: widget.callKind,
        );
        if (success && mounted) {
          _callStarted = true;
          _startTimer();
        } else if (mounted && !success) {
          Navigator.pop(context);
        }
      } else if (provider.isInCall) {
        _callStarted = true;
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !_callStarted) return;
      _timerNotifier.value++;
    });
  }

  String _formatTime(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _endCall() async {
    _callStarted = false;
    await context.read<CallProvider>().endCall(widget.conversationId);
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerNotifier.dispose();
    if (_callStarted) {
      context.read<CallProvider>().leaveCall(widget.conversationId);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer<CallProvider>(
          builder: (context, provider, _) {
            final liveKit = provider.liveKitService;
            final remoteTrack = liveKit.remoteVideoTrack;
            final localTrack = liveKit.localVideoTrack;
            final hasError = provider.errorMessage != null;

            return Stack(
              children: [
                if (remoteTrack != null)
                  Positioned.fill(
                    child: VideoTrackRenderer(
                      remoteTrack,
                      fit: VideoViewFit.cover,
                    ),
                  )
                else
                  _waitingBackground(
                    provider.isLoading,
                    hasError,
                    provider.errorMessage,
                  ),
                if (localTrack != null)
                  Positioned(
                    top: 40.h,
                    right: 16.w,
                    child: _localVideo(localTrack),
                  ),
                Positioned(
                  top: 16.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ValueListenableBuilder<int>(
                      valueListenable: _timerNotifier,
                      builder: (_, seconds, __) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(
                            seconds == 0 ? 'Connecting...' : _formatTime(seconds),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 48.h,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _controlButton(
                        icon: provider.isMuted ? Icons.mic_off : Icons.mic,
                        color: provider.isMuted ? Colors.redAccent : Colors.white,
                        onTap: provider.toggleMute,
                      ),
                      _controlButton(
                        icon: provider.isVideoEnabled
                            ? Icons.videocam
                            : Icons.videocam_off,
                        color: provider.isVideoEnabled
                            ? Colors.white
                            : Colors.redAccent,
                        onTap: provider.toggleVideo,
                      ),
                      _controlButton(
                        icon: Icons.flip_camera_ios,
                        color: Colors.white,
                        onTap: provider.switchCamera,
                      ),
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

  Widget _waitingBackground(bool isConnecting, bool hasError, String? error) {
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
                error ?? 'Something went wrong',
                style: TextStyle(color: Colors.redAccent, fontSize: 15.sp),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              const CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 24.h),
              Text(
                isConnecting ? 'Setting up call...' : 'Waiting for participant...',
                style: TextStyle(color: Colors.white60, fontSize: 16.sp),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _localVideo(VideoTrack track) {
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
          color: color.withValues(alpha: 0.15),
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(icon, color: color, size: (size * 0.46).r),
      ),
    );
  }
}
