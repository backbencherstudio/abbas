import 'package:abbas/cors/network/api_error_handle.dart' as app_log;
import 'package:abbas/presentation/views/message/model/call_model.dart';
import 'package:livekit_client/livekit_client.dart' hide logger;

class CallManager {
  Room? room;
  EventsListener<RoomEvent>? _listener;
  bool _disconnecting = false;
  bool speakerOn = true;

  bool get isConnected =>
      room != null && room!.connectionState == ConnectionState.connected;

  Future<void> connect(CallSession session) async {
    await disconnect();

    final livekit = session.livekit;
    if (livekit == null ||
        livekit.url.isEmpty ||
        livekit.token.isEmpty) {
      throw Exception('Missing LiveKit credentials');
    }

    room = Room();
    _listener = room!.createListener();

    await room!.connect(
      livekit.url,
      livekit.token,
      connectOptions: const ConnectOptions(
        autoSubscribe: true,
      ),
    );

    await room!.localParticipant?.setMicrophoneEnabled(true);
    if (session.kind.isVideo) {
      await room!.localParticipant?.setCameraEnabled(true);
    } else {
      await room!.localParticipant?.setCameraEnabled(false);
    }

    speakerOn = true;
    await room!.setSpeakerOn(true, forceSpeakerOutput: true);

    app_log.logger.i('[CallManager] Connected to room ${livekit.roomName}');
  }

  Future<void> toggleMic(bool enabled) async {
    await room?.localParticipant?.setMicrophoneEnabled(enabled);
  }

  Future<void> toggleCamera(bool enabled) async {
    await room?.localParticipant?.setCameraEnabled(enabled);
  }

  Future<void> toggleSpeaker() async {
    speakerOn = !speakerOn;
    await room?.setSpeakerOn(speakerOn, forceSpeakerOutput: speakerOn);
  }

  Future<void> switchCamera() async {
    final participant = room?.localParticipant;
    if (participant == null) return;

    for (final pub in participant.videoTrackPublications) {
      final track = pub.track;
      if (track is! LocalVideoTrack) continue;
      final options = track.currentOptions;
      if (options is! CameraCaptureOptions) continue;
      final next = options.cameraPosition == CameraPosition.front
          ? CameraPosition.back
          : CameraPosition.front;
      await track.setCameraPosition(next);
      return;
    }
  }

  VideoTrack? get localVideoTrack {
    final participant = room?.localParticipant;
    if (participant == null) return null;
    for (final pub in participant.videoTrackPublications) {
      final track = pub.track;
      if (track is VideoTrack && !pub.muted) return track;
    }
    return null;
  }

  List<RemoteVideoTrack> get remoteVideoTracks {
    final tracks = <RemoteVideoTrack>[];
    final participants = room?.remoteParticipants.values ?? const [];
    for (final participant in participants) {
      for (final pub in participant.videoTrackPublications) {
        final track = pub.track;
        if (track is RemoteVideoTrack && !pub.muted) {
          tracks.add(track);
        }
      }
    }
    return tracks;
  }

  Future<void> disconnect() async {
    if (_disconnecting) return;
    _disconnecting = true;
    try {
      _listener?.dispose();
      _listener = null;
      final activeRoom = room;
      room = null;
      if (activeRoom == null) return;
      try {
        await activeRoom.disconnect();
      } catch (e) {
        app_log.logger.w('[CallManager] disconnect error: $e');
      }
      try {
        await activeRoom.dispose();
      } catch (e) {
        app_log.logger.w('[CallManager] dispose error: $e');
      }
    } finally {
      _disconnecting = false;
    }
  }
}
