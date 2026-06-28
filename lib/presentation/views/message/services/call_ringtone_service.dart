import 'dart:io';

import 'package:abbas/cors/network/api_error_handle.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:permission_handler/permission_handler.dart';

/// Plays the device default ringtone while an incoming call banner is shown.
class CallRingtoneService {
  CallRingtoneService._();
  static final CallRingtoneService instance = CallRingtoneService._();

  final FlutterRingtonePlayer _player = FlutterRingtonePlayer();
  bool _playing = false;
  bool _starting = false;

  Future<void> _ensurePermissions() async {
    if (Platform.isAndroid) {
      await Permission.notification.request();
    }
  }

  Future<void> start() async {
    if (_playing || _starting) return;
    _starting = true;
    try {
      await _ensurePermissions();
      await _player.stop();
      await _player.playRingtone(
        looping: true,
        volume: 1.0,
        asAlarm: false,
      );
      _playing = true;
      logger.i('[CallRingtone] Playing system default ringtone');
    } catch (e, st) {
      _playing = false;
      logger.e('[CallRingtone] Failed to play: $e\n$st');
    } finally {
      _starting = false;
    }
  }

  Future<void> stop() async {
    if (!_playing && !_starting) return;
    _playing = false;
    _starting = false;
    try {
      await _player.stop();
      logger.i('[CallRingtone] Stopped');
    } catch (e) {
      logger.w('[CallRingtone] Stop error: $e');
    }
  }

  Future<void> dispose() async {
    await stop();
  }
}
