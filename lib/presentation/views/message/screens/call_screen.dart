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
      })
      ..on<RoomDisconnectedEvent>((_) {
        if (mounted) {
          ref.read(callProvider.notifier).handleRemoteDisconnect();
        }
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
    final isGroup = session?.isGroupCall ?? false;

    ref.listen<CallState>(callProvider, (previous, next) {
      if (next.isLiveKitConnected && _roomListener == null) {
        _attachRoomListener();
      }
      if (!next.isLiveKitConnected &&
          !next.isConnecting &&
          (previous?.isLiveKitConnected == true ||
              previous?.isConnecting == true) &&
          mounted) {
        Navigator.of(context).maybePop();
      }
    });

    final localTrack = callManager.localVideoTrack;
    final remoteTracks = callManager.remoteVideoTracks;
    final micOn = session?.selfParticipant?.microphone ?? true;
    final camOn = session?.selfParticipant?.camera ?? true;
    final speakerOn = callManager.speakerOn;

    return PopScope(
      canPop: !callState.isLiveKitConnected,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (callState.isLiveKitConnected) {
          await ref.read(callProvider.notifier).hangUp();
        }
      },
      child: Scaffold(
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
                _AudioBackdrop(
                  title: _displayTitle,
                  isVideo: isVideo,
                  isGroup: isGroup,
                  participantCount: session?.participantCount ?? 0,
                ),

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
                  onPressed: () async {
                    if (callState.isLiveKitConnected) {
                      await ref.read(callProvider.notifier).hangUp();
                    } else {
                      Navigator.of(context).maybePop();
                    }
                  },
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ),
              ),

              Positioned(
                top: 56.h,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    if (isGroup)
                      Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff24324A),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.groups, color: Colors.white70, size: 16.sp),
                            SizedBox(width: 6.w),
                            Text(
                              'Group call',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                      _statusLabel(callState, isGroup),
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
                bottom: 24.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _buildControls(
                      callState: callState,
                      isGroup: isGroup,
                      isVideo: isVideo,
                      session: session,
                      micOn: micOn,
                      camOn: camOn,
                      speakerOn: speakerOn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canEndForEveryone(CallSession session, CallState callState) {
    final userId = callState.currentUserId;
    if (userId == null) return false;
    return session.startedBy == userId;
  }

  List<Widget> _buildControls({
    required CallState callState,
    required bool isGroup,
    required bool isVideo,
    required CallSession? session,
    required bool micOn,
    required bool camOn,
    required bool speakerOn,
  }) {
    final connected = callState.isLiveKitConnected;
    final notifier = ref.read(callProvider.notifier);

    Widget slot(_ControlButton button) => Expanded(
          child: Center(child: button),
        );

    final items = <Widget>[
      slot(
        _ControlButton(
          icon: micOn ? Icons.mic : Icons.mic_off,
          label: micOn ? 'Mute' : 'Unmute',
          onTap: connected ? () => notifier.toggleMic() : null,
        ),
      ),
      slot(
        _ControlButton(
          icon: speakerOn ? Icons.volume_up : Icons.hearing,
          label: speakerOn ? 'Speaker' : 'Earpiece',
          onTap: connected ? () => notifier.toggleSpeaker() : null,
        ),
      ),
    ];

    if (isVideo) {
      items.addAll([
        slot(
          _ControlButton(
            icon: camOn ? Icons.videocam : Icons.videocam_off,
            label: camOn ? 'Cam off' : 'Cam on',
            onTap: connected ? () => notifier.toggleCamera() : null,
          ),
        ),
        slot(
          _ControlButton(
            icon: Icons.cameraswitch,
            label: 'Flip',
            onTap: connected ? () => notifier.switchCamera() : null,
          ),
        ),
      ]);
    }

    items.add(
      slot(
        _ControlButton(
          icon: Icons.call_end,
          label: isGroup ? 'Leave' : 'End',
          backgroundColor: const Color(0xffE9201D),
          onTap: connected
              ? () => notifier.hangUp()
              : () => Navigator.of(context).maybePop(),
        ),
      ),
    );

    if (isGroup &&
        session != null &&
        _canEndForEveryone(session, callState)) {
      items.add(
        slot(
          _ControlButton(
            icon: Icons.group_off,
            label: 'End all',
            onTap: connected ? () => notifier.endCallForEveryone() : null,
          ),
        ),
      );
    }

    return items;
  }

  String _statusLabel(CallState callState, bool isGroup) {
    if (callState.isConnecting) return 'Connecting...';
    if (!callState.isLiveKitConnected) return 'Waiting...';
    final count = callState.activeSession?.participantCount ?? 1;
    if (count <= 1) {
      return isGroup
          ? 'Waiting for others to join'
          : 'Calling...';
    }
    if (isGroup) return '$count participants · ${widget.kind.isVideo ? 'Video' : 'Audio'}';
    return widget.kind.isVideo ? 'Video call' : 'Audio call';
  }
}

class _AudioBackdrop extends StatelessWidget {
  final String title;
  final bool isVideo;
  final bool isGroup;
  final int participantCount;

  const _AudioBackdrop({
    required this.title,
    required this.isVideo,
    required this.isGroup,
    required this.participantCount,
  });

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
              isGroup
                  ? Icons.groups
                  : (isVideo ? Icons.videocam : Icons.phone),
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
          if (isGroup && participantCount > 1) ...[
            SizedBox(height: 8.h),
            Text(
              '$participantCount in call',
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            ),
          ],
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
              width: 52.w,
              height: 52.w,
              child: Icon(icon, color: Colors.white, size: 22.sp),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 11.sp),
        ),
      ],
    );
  }
}
