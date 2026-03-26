import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import '../provider/call_provider.dart';

class VideoCallScreen extends StatefulWidget {
  final String conversationId;
  final String callKind;
  final String? callerName;
  final String? callerAvatar;

  const VideoCallScreen({
    super.key,
    required this.conversationId,
    this.callKind = "VIDEO",
    this.callerName,
    this.callerAvatar,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isCallActive = false;
  int _callSeconds = 0;
  bool _isVideoEnabled = true;
  bool _isCameraFront = true;

  VideoTrack? _localVideoTrack;
  VideoTrack? _remoteVideoTrack;

  String _debugInfo = "Initializing...";

  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();
    print("🎬 VideoCallScreen initState");

    // Initialize call after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initiateCall();
    });

    // Start retry mechanism for video track
    _startVideoTrackRetry();
  }

  void _startVideoTrackRetry() {
    // Try to setup local video at different intervals
    const retryDelays = [2, 4, 6, 8, 10, 12, 15];

    for (var delay in retryDelays) {
      Future.delayed(Duration(seconds: delay), () {
        if (mounted && _isCallActive) {
          print("🔄 Retry $delay: Setting up local video...");
          _setupLocalVideo();
        }
      });
    }
  }

  @override
  void dispose() {
    print("🗑️ VideoCallScreen dispose");
    _retryTimer?.cancel();
    _stopTimer();

    if (_isCallActive) {
      Provider.of<CallProvider>(
        context,
        listen: false,
      ).leaveCall(widget.conversationId);
    }
    super.dispose();
  }

  Future<void> _initiateCall() async {
    if (!mounted) return;

    print("📞 Initiating video call...");
    setState(() {
      _debugInfo = "Starting call...";
    });

    final provider = Provider.of<CallProvider>(context, listen: false);

    // Wait for room to be ready
    await Future.delayed(const Duration(milliseconds: 500));

    // Listen to LiveKit events
    provider.liveKitService.roomInstance?.events.listen((event) {
      print("📡 LiveKit Event: ${event.runtimeType}");

      if (event is TrackSubscribedEvent) {
        print("📥 Track subscribed: ${event.track.kind}");
        _onTrackSubscribed(event.track, event.participant);
      } else if (event is TrackUnsubscribedEvent) {
        print("📤 Track unsubscribed: ${event.track.kind}");
        _onTrackUnsubscribed(event.track, event.participant);
      } else if (event is LocalTrackPublishedEvent) {
        print("📹 Local track published");
        Future.delayed(const Duration(milliseconds: 500), () {
          _setupLocalVideo();
        });
      } else if (event is ParticipantConnectedEvent) {
        print("👤 Participant joined: ${event.participant.identity}");
        setState(() {
          _debugInfo = "Participant joined: ${event.participant.identity}";
        });
      } else if (event is ParticipantDisconnectedEvent) {
        print("👋 Participant left: ${event.participant.identity}");
        setState(() {
          _debugInfo = "Participant left";
          _remoteVideoTrack = null;
        });
      } else if (event is RoomConnectedEvent) {
        print("✅ Room connected!");
        setState(() {
          _debugInfo = "Room connected";
        });
        // Try to setup video after connection
        Future.delayed(const Duration(seconds: 1), () {
          _setupLocalVideo();
        });
      } else if (event is RoomDisconnectedEvent) {
        print("🔌 Room disconnected: ${event.reason}");
        setState(() {
          _debugInfo = "Disconnected: ${event.reason}";
          _isCallActive = false;
        });
      }
    });

    final success = await provider.startCall(
      widget.conversationId,
      kind: widget.callKind,
    );

    if (success && mounted) {
      print("✅ Call started successfully!");
      setState(() {
        _isCallActive = true;
        _debugInfo = "Call active - waiting for video...";
      });
      _startTimer();

      // Try to setup local video multiple times
      for (int i = 1; i <= 5; i++) {
        Future.delayed(Duration(seconds: i), () {
          if (mounted) _setupLocalVideo();
        });
      }
    } else {
      print("❌ Failed to start call");
      setState(() {
        _debugInfo = "Call failed";
      });
    }
  }

  void _setupLocalVideo() {
    print("🔍 Setting up local video...");

    final provider = Provider.of<CallProvider>(context, listen: false);
    final room = provider.liveKitService.roomInstance;

    if (room == null) {
      print("❌ Room is null");
      return;
    }

    final localParticipant = room.localParticipant;

    if (localParticipant == null) {
      print("❌ Local participant is null");
      return;
    }

    print("👤 Local participant found: ${localParticipant.identity}");
    print(
      "📊 Track publications count: ${localParticipant.trackPublications.length}",
    );

    // List all tracks
    if (localParticipant.trackPublications.isEmpty) {
      print("⏳ No tracks yet, waiting for tracks to be published...");
      return;
    }

    localParticipant.trackPublications.forEach((key, publication) {
      print(
        "   Track: $key - Kind: ${publication.kind} - Has track: ${publication.track != null} - Muted: ${publication.muted}",
      );
    });

    // Check if we have video track
    bool hasVideoTrack = false;
    VideoTrack? foundTrack;

    for (var publication in localParticipant.trackPublications.values) {
      if (publication.kind == TrackType.VIDEO) {
        hasVideoTrack = true;
        if (publication.track is VideoTrack) {
          foundTrack = publication.track as VideoTrack;
          print("✅ Found local video track! Muted: ${publication.muted}");
          break;
        } else {
          print(
            "⚠️ Track is not VideoTrack yet: ${publication.track.runtimeType}",
          );
        }
      }
    }

    setState(() {
      if (foundTrack != null) {
        _localVideoTrack = foundTrack;
        _debugInfo = "Local video ready";
        print("🎥 Local video track set successfully!");
      } else {
        if (!hasVideoTrack) {
          _debugInfo = "Waiting for video track... (only audio)";
          print("⏳ Only audio track found, video not ready yet");
        } else {
          _debugInfo = "Video track initializing...";
        }
      }
    });
  }

  void _onTrackSubscribed(Track track, Participant participant) {
    print("📥 Track subscribed: ${track.kind} from ${participant.identity}");

    if (track.kind == TrackType.VIDEO) {
      print("✅ Remote video track received!");
      setState(() {
        _remoteVideoTrack = track as VideoTrack;
        _debugInfo = "Remote video received from ${participant.identity}";
      });
    }
  }

  void _onTrackUnsubscribed(Track track, Participant participant) {
    print("📤 Track unsubscribed: ${track.kind} from ${participant.identity}");

    if (track.kind == TrackType.VIDEO) {
      print("❌ Remote video track removed");
      setState(() {
        _remoteVideoTrack = null;
        _debugInfo = "Remote video removed";
      });
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isCallActive) {
        setState(() => _callSeconds++);
        _startTimer();
      }
    });
  }

  void _stopTimer() {
    _isCallActive = false;
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _endCall() async {
    print("👋 Ending call...");
    _stopTimer();
    final provider = Provider.of<CallProvider>(context, listen: false);
    await provider.leaveCall(widget.conversationId);
    if (mounted) Navigator.pop(context);
  }

  void _toggleVideo() {
    final provider = Provider.of<CallProvider>(context, listen: false);

    setState(() {
      _isVideoEnabled = !_isVideoEnabled;
    });

    if (_isVideoEnabled) {
      print("📹 Enabling video");
      provider.liveKitService.enableVideo();
      Future.delayed(const Duration(milliseconds: 500), () {
        _setupLocalVideo();
      });
    } else {
      print("📹 Disabling video");
      provider.liveKitService.disableVideo();
      setState(() {
        _localVideoTrack = null;
      });
    }
  }

  void _toggleCamera() {
    setState(() {
      _isCameraFront = !_isCameraFront;
    });
    print("🔄 Switching camera to ${_isCameraFront ? 'front' : 'back'}");
    // Camera switch logic will be added later
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CallProvider>();

    print("🎨 Building VideoCallScreen UI");
    print("   Local track: $_localVideoTrack");
    print("   Remote track: $_remoteVideoTrack");
    print("   isCallActive: $_isCallActive");
    print("   isLoading: ${provider.isLoading}");
    print("   errorMessage: ${provider.errorMessage}");

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: SafeArea(
        child: provider.isLoading
            ? _buildLoading()
            : provider.errorMessage != null
            ? _buildError(provider)
            : _buildCallActive(provider),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 20.h),
          Text(
            "Connecting video call...",
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              _debugInfo,
              style: TextStyle(color: Colors.white54, fontSize: 12.sp),
            ),
          ),
        ],
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
            Icon(Icons.error_outline, color: Colors.red, size: 60.r),
            SizedBox(height: 20.h),
            Text(
              "Video Call Failed",
              style: TextStyle(color: Colors.white, fontSize: 20.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              provider.errorMessage ?? "Unable to connect video call",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                _debugInfo,
                style: TextStyle(color: Colors.white54, fontSize: 12.sp),
              ),
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () {
                provider.clearError();
                _initiateCall();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
              ),
              child: Text("Try Again"),
            ),

            SizedBox(height: 10.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Go Back",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallActive(CallProvider provider) {
    if (!_isCallActive) return const SizedBox.shrink();

    return Stack(
      children: [
        // Remote video (full screen)
        if (_remoteVideoTrack != null)
          Positioned.fill(child: VideoTrackRenderer(_remoteVideoTrack!))
        else
          Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 20.h),
                  Text(
                    "Waiting for other participant...",
                    style: TextStyle(color: Colors.white70, fontSize: 16.sp),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      _debugInfo,
                      style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Local video (picture-in-picture)
        if (_localVideoTrack != null && _isVideoEnabled)
          Positioned(
            top: 20.h,
            right: 20.w,
            child: Container(
              width: 120.w,
              height: 160.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white24, width: 2.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: VideoTrackRenderer(_localVideoTrack!),
              ),
            ),
          ),

        // Debug info (top left)
        Positioned(
          top: 20.h,
          left: 20.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              _debugInfo,
              style: TextStyle(color: Colors.white70, fontSize: 10.sp),
            ),
          ),
        ),

        // Top info bar
        Positioned(
          top: 60.h,
          left: 20.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15.r,
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  backgroundImage: widget.callerAvatar != null
                      ? NetworkImage(widget.callerAvatar!)
                      : null,
                  child: widget.callerAvatar == null
                      ? Icon(Icons.person, color: Colors.white, size: 15.r)
                      : null,
                ),
                SizedBox(width: 8.w),
                Text(
                  widget.callerName ?? "Unknown Caller",
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  _formatDuration(_callSeconds),
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
              ],
            ),
          ),
        ),

        // Bottom control buttons
        Positioned(
          bottom: 40.h,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mute button
              _buildButton(
                icon: provider.isMuted ? Icons.mic_off : Icons.mic,
                color: provider.isMuted ? Colors.red : Colors.white,
                onPressed: provider.toggleMute,
              ),
              SizedBox(width: 20.w),

              // Video toggle button
              _buildButton(
                icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                color: _isVideoEnabled ? Colors.white : Colors.red,
                onPressed: _toggleVideo,
              ),
              SizedBox(width: 20.w),

              // Switch camera button
              _buildButton(
                icon: Icons.flip_camera_ios,
                color: Colors.white,
                onPressed: _toggleCamera,
              ),
              SizedBox(width: 20.w),

              // End call button
              _buildButton(
                icon: Icons.call_end,
                color: Colors.red,
                onPressed: _endCall,
                isEndCall: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool isEndCall = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: isEndCall ? 70.r : 60.r,
        height: isEndCall ? 70.r : 60.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.2),
          border: Border.all(color: color, width: 2.r),
        ),
        child: Icon(icon, color: color, size: isEndCall ? 30.r : 25.r),
      ),
    );
  }
}
