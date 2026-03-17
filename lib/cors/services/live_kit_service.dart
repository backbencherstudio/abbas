import 'package:livekit_client/livekit_client.dart';
import 'package:logger/logger.dart';

class LiveKitService {
  // Make room nullable
  Room? _room;
  final Logger logger = Logger();
  bool _isConnected = false;

  // Track publications
  LocalTrackPublication? _audioPublication;
  LocalTrackPublication? _videoPublication;

  bool get isConnected => _isConnected;

  // Safe getter for room - returns null if not connected
  Room? get roomInstance => _room;

  /// Connect to a LiveKit room
  Future<void> connectToRoom({
    required String url,
    required String token,
    required String roomName,
    bool audioOnly = true,
  }) async {
    try {
      // Initialize room
      _room = Room();

      // Set up event listeners
      _setupEventListeners();

      // Connect to room
      logger.i("Connecting to room: $roomName at $url");
      await _room!.connect(url, token);
      _isConnected = true;

      // Publish audio track
      if (_room!.localParticipant != null) {
        final audioTrack = await LocalAudioTrack.create();
        _audioPublication = await _room!.localParticipant!.publishAudioTrack(audioTrack);

        // Publish video if not audio only
        if (!audioOnly) {
          try {
            final videoTrack = await LocalVideoTrack.createCameraTrack();
            _videoPublication = await _room!.localParticipant!.publishVideoTrack(videoTrack);
          } catch (e) {
            logger.e("Failed to publish video: $e");
          }
        }
      }

      logger.i("Successfully connected to room");
    } catch (e) {
      logger.e("Failed to connect: $e");
      _isConnected = false;
      _room = null;
      rethrow;
    }
  }

  void _setupEventListeners() {
    _room?.events.listen((event) {
      if (event is ParticipantConnectedEvent) {
        logger.i("New participant joined: ${event.participant.identity}");
      }

      if (event is ParticipantDisconnectedEvent) {
        logger.i("Participant left: ${event.participant.identity}");
      }

      if (event is TrackSubscribedEvent) {
        logger.i("New track subscribed from: ${event.participant.identity}");
      }

      if (event is TrackUnsubscribedEvent) {
        logger.i("Track unsubscribed from: ${event.participant.identity}");
      }

      if (event is RoomDisconnectedEvent) {
        logger.i("Disconnected from room: ${event.reason}");
        _isConnected = false;
        _room = null;
      }
    });
  }

  /// Enable audio
  Future<void> enableAudio() async {
    try {
      if (_audioPublication != null) {
        await _audioPublication!.unmute();
        logger.i("Audio unmuted");
      }
    } catch (e) {
      logger.e("Failed to enable audio: $e");
    }
  }

  /// Disable audio
  Future<void> disableAudio() async {
    try {
      if (_audioPublication != null) {
        await _audioPublication!.mute();
        logger.i("Audio muted");
      }
    } catch (e) {
      logger.e("Failed to disable audio: $e");
    }
  }

  /// Toggle audio
  Future<void> toggleAudio() async {
    try {
      if (_audioPublication != null) {
        if (_audioPublication!.muted) {
          await _audioPublication!.unmute();
          logger.i("Audio unmuted");
        } else {
          await _audioPublication!.mute();
          logger.i("Audio muted");
        }
      }
    } catch (e) {
      logger.e("Failed to toggle audio: $e");
    }
  }

  /// Enable video
  Future<void> enableVideo() async {
    try {
      if (_room?.localParticipant != null) {
        if (_videoPublication == null) {
          final videoTrack = await LocalVideoTrack.createCameraTrack();
          _videoPublication = await _room!.localParticipant!.publishVideoTrack(videoTrack);
          logger.i("Video track published");
        } else {
          await _videoPublication!.unmute();
          logger.i("Video unmuted");
        }
      }
    } catch (e) {
      logger.e("Failed to enable video: $e");
    }
  }

  /// Disable video
  Future<void> disableVideo() async {
    try {
      if (_videoPublication != null) {
        await _videoPublication!.mute();
        logger.i("Video muted");
      }
    } catch (e) {
      logger.e("Failed to disable video: $e");
    }
  }

  /// Toggle video
  Future<void> toggleVideo() async {
    try {
      if (_room?.localParticipant != null) {
        if (_videoPublication == null) {
          await enableVideo();
        } else {
          if (_videoPublication!.muted) {
            await _videoPublication!.unmute();
            logger.i("Video unmuted");
          } else {
            await _videoPublication!.mute();
            logger.i("Video muted");
          }
        }
      }
    } catch (e) {
      logger.e("Failed to toggle video: $e");
    }
  }

  /// Check if audio is muted
  bool isAudioMuted() {
    return _audioPublication?.muted ?? true;
  }

  /// Check if video is muted
  bool isVideoMuted() {
    return _videoPublication?.muted ?? true;
  }

  /// Check if video is published
  bool hasVideo() {
    return _videoPublication != null;
  }

  /// Disconnect from room
  void leaveCall() {
    try {
      if (_isConnected && _room != null) {
        _room!.disconnect();
        _isConnected = false;
        _audioPublication = null;
        _videoPublication = null;
        _room = null;
        logger.i("Disconnected from room");
      }
    } catch (e) {
      logger.e("Error disconnecting: $e");
    }
  }
}