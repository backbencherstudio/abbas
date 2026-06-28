import 'package:abbas/presentation/views/message/model/call_model.dart';
import 'package:abbas/presentation/views/message/provider/call_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';

class CallScreen extends ConsumerStatefulWidget {
  final CallKind kind;
  final String? conversationId;
  final String? title;
  final bool autoStart;

  const CallScreen({
    super.key,
    required this.kind,
    this.conversationId,
    this.title,
    this.autoStart = false,
  });

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  EventsListener<RoomEvent>? _roomListener;
  bool _didAutoStart = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeAutoStart();
      _attachRoomListener();
    });
  }

  @override
  void dispose() {
    _roomListener?.dispose();
    super.dispose();
  }

  Future<void> _maybeAutoStart() async {
    if (_didAutoStart || !widget.autoStart) return;
    final conversationId = widget.conversationId;
    if (conversationId == null || conversationId.isEmpty) return;

    final callState = ref.read(callProvider);
    if (callState.isLiveKitConnected || callState.isConnecting) return;

    _didAutoStart = true;
    await ref.read(callProvider.notifier).startCall(
          conversationId: conversationId,
          kind: widget.kind,
          title: widget.title,
        );
    _attachRoomListener();
  }

  void _attachRoomListener() {
    _roomListener?.dispose();
    final room = ref.read(callProvider.notifier).callManager.room;
    if (room == null) return;

    _roomListener = room.createListener()
      ..on<TrackSubscribedEvent>((_) {
        if (mounted) setState(() {});
      })
      ..on<TrackUnsubscribedEvent>((_) {
        if (mounted) setState(() {});
      })
      ..on<ParticipantConnectedEvent>((_) {
        if (mounted) setState(() {});
      })
      ..on<ParticipantDisconnectedEvent>((_) {
        if (mounted) setState(() {});
      })
      ..on<LocalTrackPublishedEvent>((_) {
        if (mounted) setState(() {});
      });
  }

  String get _displayTitle {
    final callState = ref.watch(callProvider);
    return widget.title ??
        callState.displayTitle ??
        callState.activeSession?.conversationTitle ??
        'Call';
  }

  @override
  Widget build(BuildContext context) {
    final callState = ref.watch(callProvider);
    final callManager = ref.read(callProvider.notifier).callManager;
    final session = callState.activeSession;
    final isVideo = widget.kind.isVideo;

    ref.listen<CallState>(callProvider, (previous, next) {
      if (next.isLiveKitConnected && _roomListener == null) {
        _attachRoomListener();
      }
      if (!next.isLiveKitConnected &&
          !next.isConnecting &&
          previous?.isLiveKitConnected == true &&
          mounted) {
        Navigator.of(context).maybePop();
      }
    });

    final localTrack = callManager.localVideoTrack;
    final remoteTracks = callManager.remoteVideoTracks;
    final micOn = session?.selfParticipant?.microphone ?? true;
    final camOn = session?.selfParticipant?.camera ?? true;

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (isVideo && remoteTracks.isNotEmpty)
              Positioned.fill(
                child: VideoTrackRenderer(remoteTracks.first),
              )
            else if (isVideo && localTrack != null && remoteTracks.isEmpty)
              Positioned.fill(
                child: VideoTrackRenderer(localTrack),
              )
            else
              _AudioBackdrop(title: _displayTitle, isVideo: isVideo),

            if (isVideo && localTrack != null && remoteTracks.isNotEmpty)
              Positioned(
                top: 16.h,
                right: 16.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: SizedBox(
                    width: 110.w,
                    height: 150.h,
                    child: VideoTrackRenderer(localTrack),
                  ),
                ),
              ),

            Positioned(
              top: 8.h,
              left: 8.w,
              child: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ),
            ),

            Positioned(
              top: 56.h,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    _displayTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    _statusLabel(callState),
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                ],
              ),
            ),

            if (callState.isConnecting)
              const Center(
                child: CircularProgressIndicator(color: Color(0xffE9201D)),
              ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 36.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ControlButton(
                    icon: micOn ? Icons.mic : Icons.mic_off,
                    label: micOn ? 'Mute' : 'Unmute',
                    onTap: callState.isLiveKitConnected
                        ? () => ref.read(callProvider.notifier).toggleMic()
                        : null,
                  ),
                  if (isVideo)
                    _ControlButton(
                      icon: camOn ? Icons.videocam : Icons.videocam_off,
                      label: camOn ? 'Camera off' : 'Camera on',
                      onTap: callState.isLiveKitConnected
                          ? () => ref.read(callProvider.notifier).toggleCamera()
                          : null,
                    ),
                  _ControlButton(
                    icon: Icons.call_end,
                    label: 'End',
                    backgroundColor: const Color(0xffE9201D),
                    onTap: callState.isLiveKitConnected
                        ? () => ref.read(callProvider.notifier).leaveCall()
                        : () => Navigator.of(context).maybePop(),
                  ),
                  if (session != null && (session.participantCount > 1))
                    _ControlButton(
                      icon: Icons.group_off,
                      label: 'End all',
                      onTap: callState.isLiveKitConnected
                          ? () =>
                              ref.read(callProvider.notifier).endCallForEveryone()
                          : null,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(CallState callState) {
    if (callState.isConnecting) return 'Connecting...';
    if (!callState.isLiveKitConnected) return 'Waiting...';
    final count = callState.activeSession?.participantCount ?? 1;
    if (count <= 1) return 'Waiting for others to join';
    return widget.kind.isVideo ? 'Video call' : 'Audio call';
  }
}

class _AudioBackdrop extends StatelessWidget {
  final String title;
  final bool isVideo;

  const _AudioBackdrop({required this.title, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff152033), Color(0xff030D15)],
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 56.r,
            backgroundColor: const Color(0xff24324A),
            child: Icon(
              isVideo ? Icons.videocam : Icons.phone,
              color: const Color(0xffE9201D),
              size: 42.sp,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color backgroundColor;

  const _ControlButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.backgroundColor = const Color(0xff24324A),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: backgroundColor,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: 56.w,
              height: 56.w,
              child: Icon(icon, color: Colors.white, size: 24.sp),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
        ),
      ],
    );
  }
}
