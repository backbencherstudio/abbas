// live_kit_service.dart
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:logger/logger.dart';

class LiveKitService with ChangeNotifier {
  Room? _room;
  LocalAudioTrack? _audioTrack;
  LocalVideoTrack? _videoTrack;

  LocalTrackPublication? _audioPublication;
  LocalTrackPublication? _videoPublication;

  final Logger logger = Logger();

  bool _isConnected = false;
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

      _room = Room();
      _setupListeners();

      logger.i("🔌 Connecting to LiveKit: $roomName");
      await _room!.connect(url, token);

      _isConnected = true;

      // Audio Track
      _audioTrack = await LocalAudioTrack.create();
      _audioPublication = await _room!.localParticipant!.publishAudioTrack(
        _audioTrack!,
      );

      // Video Track - Very Simple (Real Device Friendly)
      if (!audioOnly) {
        try {
          logger.i("📹 Creating simple camera track...");

          _videoTrack = await LocalVideoTrack.createCameraTrack();

          _videoPublication = await _room!.localParticipant!.publishVideoTrack(
            _videoTrack!,
          );

          logger.i(" Video track published");
          notifyListeners();
        } catch (e) {
          logger.e("Video track failed: $e");
        }
      }

      logger.i("Successfully connected to LiveKit Room");
      notifyListeners();
    } catch (e) {
      logger.e(" LiveKit Connection Failed: $e");
      _isConnected = false;
      _room = null;
      rethrow;
    }
  }

  void _setupListeners() {
    _room?.events.listen((event) {
      if (event is ParticipantConnectedEvent) {
        logger.i("👤 Participant joined: ${event.participant.identity}");
      }
      if (event is ParticipantDisconnectedEvent) {
        logger.i(" Participant left: ${event.participant.identity}");
      }
      if (event is TrackSubscribedEvent) {
        if (event.track.kind == TrackType.VIDEO) {
          _remoteVideoTrack = event.track as VideoTrack;
          notifyListeners();
        }
      }
      if (event is TrackUnsubscribedEvent) {
        if (event.track.kind == TrackType.VIDEO) {
          _remoteVideoTrack = null;
          notifyListeners();
        }
      }
      if (event is RoomDisconnectedEvent) {
        logger.i(" Room disconnected");
        _isConnected = false;
        _room = null;
        notifyListeners();
      }
    });
  }

  // Audio
  Future<void> enableAudio() async {
    if (_audioPublication != null) await _audioPublication!.unmute();
    notifyListeners();
  }

  Future<void> disableAudio() async {
    if (_audioPublication != null) await _audioPublication!.mute();
    notifyListeners();
  }

  // Video
  Future<void> enableVideo() async {
    try {
      if (_videoPublication != null) {
        await _videoPublication!.unmute();
      } else if (_room?.localParticipant != null) {
        _videoTrack = await LocalVideoTrack.createCameraTrack();
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
    if (_videoPublication != null) await _videoPublication!.mute();
    notifyListeners();
  }

  // Switch Camera
  Future<void> switchCamera() async {
    try {
      if (_videoTrack == null) return;

      await _videoTrack!.switchCamera(""); // empty string = default behavior
      logger.i(" Camera switched");
      notifyListeners();
    } catch (e) {
      logger.e("Switch camera failed: $e");
      // Optional fallback
    }
  }

  Future<void> disconnect() async {
    try {
      await _room?.disconnect();
    } catch (e) {
      logger.e("Disconnect error: $e");
    } finally {
      _room = null;
      _audioTrack = null;
      _videoTrack = null;
      _audioPublication = null;
      _videoPublication = null;
      _remoteVideoTrack = null;
      _isConnected = false;
      notifyListeners();
    }
  }
}
