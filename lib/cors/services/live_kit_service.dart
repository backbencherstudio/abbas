import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:logger/logger.dart';

class LiveKitService with ChangeNotifier {
  Room? _room;
  LocalAudioTrack? _audioTrack;
  LocalVideoTrack? _videoTrack;

  LocalTrackPublication? _audioPublication;
  LocalTrackPublication? _videoPublication;

  final Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));

  bool _isConnected = false;
  bool _isFrontCamera = true;

  bool get isConnected => _isConnected && _room != null;
  Room? get room => _room;

  VideoTrack? get localVideoTrack => _videoTrack;
  VideoTrack? get remoteVideoTrack => _remoteVideoTrack;
  VideoTrack? _remoteVideoTrack;

  Future<void> connectToRoom({
    required String url,
    required String token,
    required String roomName,
    bool audioOnly = false,
  }) async {
    try {
      if (_room != null) await disconnect();

      _room = Room(
        roomOptions: const RoomOptions(adaptiveStream: true, dynacast: true),
      );

      _setupListeners();

      logger.i("Connecting to LiveKit room: $roomName at $url");
      await _room!.connect(url, token);
      _isConnected = true;
      logger.i(" Connected to room");

      _audioTrack = await LocalAudioTrack.create();
      _audioPublication = await _room!.localParticipant!.publishAudioTrack(
        _audioTrack!,
      );
      logger.i(" Audio track published");

      if (!audioOnly) {
        try {
          _videoTrack = await LocalVideoTrack.createCameraTrack(
            const CameraCaptureOptions(cameraPosition: CameraPosition.front),
          );
          _videoPublication = await _room!.localParticipant!.publishVideoTrack(
            _videoTrack!,
          );
          _isFrontCamera = true;
          logger.i(" Video track published");
        } catch (e) {
          logger.e("Video track failed (continuing audio-only): $e");
        }
      }

      notifyListeners();
    } catch (e) {
      logger.e(" LiveKit connection failed: $e");
      _isConnected = false;
      _room = null;
      rethrow;
    }
  }

  void _setupListeners() {
    _room?.events.listen((event) {
      if (event is ParticipantConnectedEvent) {
        logger.i(" Participant joined: ${event.participant.identity}");
        notifyListeners();
      }

      if (event is ParticipantDisconnectedEvent) {
        logger.i(" Participant left: ${event.participant.identity}");
        notifyListeners();
      }

      if (event is TrackSubscribedEvent) {
        if (event.track.kind == TrackType.VIDEO) {
          _remoteVideoTrack = event.track as VideoTrack;
          logger.i(" Remote video subscribed");
          notifyListeners();
        }
        if (event.track.kind == TrackType.AUDIO) {
          logger.i(" Remote audio subscribed");
          notifyListeners();
        }
      }

      if (event is TrackUnsubscribedEvent) {
        if (event.track.kind == TrackType.VIDEO) {
          _remoteVideoTrack = null;
          logger.i(" Remote video unsubscribed");
          notifyListeners();
        }
      }

      if (event is RoomDisconnectedEvent) {
        logger.i(" Room disconnected");
        _isConnected = false;
        _room = null;
        _remoteVideoTrack = null;
        notifyListeners();
      }
    });
  }

  Future<void> enableAudio() async {
    try {
      if (_audioPublication != null) {
        await _audioPublication!.unmute();
        notifyListeners();
      }
    } catch (e) {
      logger.e("Enable audio failed: $e");
    }
  }

  Future<void> disableAudio() async {
    try {
      if (_audioPublication != null) {
        await _audioPublication!.mute();
        notifyListeners();
      }
    } catch (e) {
      logger.e("Disable audio failed: $e");
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
      logger.e("Enable video failed: $e");
    }
  }

  Future<void> disableVideo() async {
    try {
      if (_videoPublication != null) {
        await _videoPublication!.mute();
        notifyListeners();
      }
    } catch (e) {
      logger.e("Disable video failed: $e");
    }
  }

  Future<void> switchCamera() async {
    try {
      if (_videoTrack == null) return;
      _isFrontCamera = !_isFrontCamera;
      final newPosition = _isFrontCamera
          ? CameraPosition.front
          : CameraPosition.back;
      await _videoTrack!.restartTrack(
        CameraCaptureOptions(cameraPosition: newPosition),
      );
      logger.i(" Camera switched to ${newPosition.name}");
      notifyListeners();
    } catch (e) {
      logger.e("Switch camera failed: $e");
      _isFrontCamera = !_isFrontCamera;
      notifyListeners();
    }
  }

  Future<void> disconnect() async {
    try {
      await _room?.disconnect();
    } catch (e) {
      logger.e("Disconnect error: $e");
    } finally {
      await _videoTrack?.stop();
      await _audioTrack?.stop();
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
