import 'dart:async';

import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:logger/logger.dart';

class LiveKitService with ChangeNotifier {
  Room? _room;
  EventsListener<RoomEvent>? _roomListener;

  LocalAudioTrack? _audioTrack;
  LocalVideoTrack? _videoTrack;

  LocalTrackPublication? _audioPublication;
  LocalTrackPublication? _videoPublication;

  final Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));

  bool _isConnected = false;
  bool _isFrontCamera = true;

  VideoTrack? _remoteVideoTrack;

  bool get isConnected => _isConnected && _room != null;
  Room? get room => _room;
  VideoTrack? get localVideoTrack => _videoTrack;
  VideoTrack? get remoteVideoTrack => _remoteVideoTrack;

  Future<void> connectToRoom({
    required String url,
    required String token,
    required String roomName,
    bool audioOnly = false,
  }) async {
    try {
      await disconnect();

      _room = Room(
        roomOptions: const RoomOptions(
          adaptiveStream: true,
          dynacast: true,
        ),
      );

      _attachRoomListeners();

      logger.i('Connecting to LiveKit room: $roomName');
      await _room!.connect(url, token);

      _isConnected = true;
      logger.i('Connected to LiveKit room');

      _audioTrack = await LocalAudioTrack.create();
      _audioPublication = await _room!.localParticipant!.publishAudioTrack(
        _audioTrack!,
      );

      if (!audioOnly) {
        try {
          _videoTrack = await LocalVideoTrack.createCameraTrack(
            const CameraCaptureOptions(
              cameraPosition: CameraPosition.front,
            ),
          );
          _videoPublication = await _room!.localParticipant!.publishVideoTrack(
            _videoTrack!,
          );
          _isFrontCamera = true;
        } catch (e) {
          logger.e('Video publish failed, continuing audio-only: $e');
        }
      }

      _refreshRemoteVideoTrack();
      notifyListeners();
    } catch (e) {
      logger.e('LiveKit connect failed: $e');
      await disconnect();
      rethrow;
    }
  }

  void _attachRoomListeners() {
    final room = _room;
    if (room == null) return;

    _roomListener?.dispose();
    _roomListener = room.createListener();

    _roomListener!
      ..on<ParticipantConnectedEvent>((event) {
        logger.i('Participant connected: ${event.participant.identity}');
        _refreshRemoteVideoTrack();
        notifyListeners();
      })
      ..on<ParticipantDisconnectedEvent>((event) {
        logger.i('Participant disconnected: ${event.participant.identity}');
        _refreshRemoteVideoTrack();
        notifyListeners();
      })
      ..on<TrackSubscribedEvent>((event) {
        logger.i('Track subscribed: ${event.track.kind}');
        if (event.track.kind == TrackType.VIDEO) {
          _refreshRemoteVideoTrack();
        }
        notifyListeners();
      })
      ..on<TrackUnsubscribedEvent>((event) {
        logger.i('Track unsubscribed: ${event.track.kind}');
        if (event.track.kind == TrackType.VIDEO) {
          _refreshRemoteVideoTrack();
        }
        notifyListeners();
      })
      ..on<TrackMutedEvent>((_) {
        _refreshRemoteVideoTrack();
        notifyListeners();
      })
      ..on<TrackUnmutedEvent>((_) {
        _refreshRemoteVideoTrack();
        notifyListeners();
      })
      ..on<TrackStreamStateUpdatedEvent>((_) {
        _refreshRemoteVideoTrack();
        notifyListeners();
      })
      ..on<RoomDisconnectedEvent>((event) {
        logger.i('Room disconnected: ${event.reason}');
        _isConnected = false;
        _remoteVideoTrack = null;
        notifyListeners();
      });
  }

  void _refreshRemoteVideoTrack() {
    final room = _room;
    if (room == null) {
      _remoteVideoTrack = null;
      return;
    }

    VideoTrack? remote;

    for (final participant in room.remoteParticipants.values) {
      for (final publication in participant.videoTrackPublications) {
        if (!publication.subscribed) continue;
        if (publication.muted) continue;
        if (publication.streamState != StreamState.active) continue;

        final track = publication.track;
        if (track is VideoTrack) {
          remote = track;
          break;
        }
      }
      if (remote != null) break;
    }

    _remoteVideoTrack = remote;
  }

  Future<void> enableAudio() async {
    try {
      await _audioPublication?.unmute();
      notifyListeners();
    } catch (e) {
      logger.e('Enable audio failed: $e');
    }
  }

  Future<void> disableAudio() async {
    try {
      await _audioPublication?.mute();
      notifyListeners();
    } catch (e) {
      logger.e('Disable audio failed: $e');
    }
  }

  Future<void> enableVideo() async {
    try {
      if (_videoPublication != null) {
        await _videoPublication!.unmute();
      } else if (_room?.localParticipant != null) {
        _videoTrack = await LocalVideoTrack.createCameraTrack(
          CameraCaptureOptions(
            cameraPosition: _isFrontCamera
                ? CameraPosition.front
                : CameraPosition.back,
          ),
        );
        _videoPublication = await _room!.localParticipant!.publishVideoTrack(
          _videoTrack!,
        );
      }
      notifyListeners();
    } catch (e) {
      logger.e('Enable video failed: $e');
    }
  }

  Future<void> disableVideo() async {
    try {
      await _videoPublication?.mute();
      notifyListeners();
    } catch (e) {
      logger.e('Disable video failed: $e');
    }
  }

  Future<void> switchCamera() async {
    try {
      if (_videoTrack == null) return;

      _isFrontCamera = !_isFrontCamera;
      await _videoTrack!.restartTrack(
        CameraCaptureOptions(
          cameraPosition: _isFrontCamera
              ? CameraPosition.front
              : CameraPosition.back,
        ),
      );
      notifyListeners();
    } catch (e) {
      logger.e('Switch camera failed: $e');
      _isFrontCamera = !_isFrontCamera;
      notifyListeners();
    }
  }

  Future<void> disconnect() async {
    try {
      await _roomListener?.dispose();
      _roomListener = null;
      await _room?.disconnect();
    } catch (e) {
      logger.e('Disconnect error: $e');
    } finally {
      try {
        await _videoTrack?.stop();
      } catch (_) {}
      try {
        await _audioTrack?.stop();
      } catch (_) {}

      _room = null;
      _audioTrack = null;
      _videoTrack = null;
      _audioPublication = null;
      _videoPublication = null;
      _remoteVideoTrack = null;
      _isConnected = false;
      _isFrontCamera = true;
      notifyListeners();
    }
  }
}
