import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

class VoicePlaybackHub {
  static AudioPlayer? _activePlayer;
  static String? _activeId;

  static Future<void> requestPlay(String messageId, AudioPlayer player) async {
    if (_activePlayer != null &&
        _activeId != messageId &&
        _activePlayer != player) {
      await _activePlayer!.stop();
    }
    _activePlayer = player;
    _activeId = messageId;
  }

  static void clear(String messageId) {
    if (_activeId == messageId) {
      _activePlayer = null;
      _activeId = null;
    }
  }
}

class VoiceMessagePlayer extends StatefulWidget {
  final String messageId;
  final String audioUrl;
  final bool isMe;

  const VoiceMessagePlayer({
    super.key,
    required this.messageId,
    required this.audioUrl,
    required this.isMe,
  });

  @override
  State<VoiceMessagePlayer> createState() => _VoiceMessagePlayerState();
}

class _VoiceMessagePlayerState extends State<VoiceMessagePlayer> {
  late final AudioPlayer _player;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _stateSub;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _stateSub = _player.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() {
        _isLoading = state.processingState == ProcessingState.loading ||
            state.processingState == ProcessingState.buffering;
      });
      if (state.processingState == ProcessingState.completed) {
        _player.seek(Duration.zero);
        _player.pause();
      }
    });
    _positionSub = _player.positionStream.listen((pos) {
      if (mounted) setState(() => _position = pos);
    });
    _player.durationStream.listen((dur) {
      if (mounted && dur != null) setState(() => _duration = dur);
    });
  }

  @override
  void dispose() {
    VoicePlaybackHub.clear(widget.messageId);
    _positionSub?.cancel();
    _stateSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (widget.audioUrl.isEmpty) return;
    if (_player.playing) {
      await _player.pause();
      return;
    }
    await VoicePlaybackHub.requestPlay(widget.messageId, _player);
    if (_player.audioSource == null) {
      setState(() => _isLoading = true);
      await _player.setUrl(widget.audioUrl);
    }
    await _player.play();
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.isMe ? Colors.white : const Color(0xff8D9CDC);
    final total = _duration.inMilliseconds > 0 ? _duration : const Duration(seconds: 1);
    final progress = total.inMilliseconds > 0
        ? (_position.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return SizedBox(
      width: 200.w,
      child: Row(
        children: [
          GestureDetector(
            onTap: _isLoading ? null : _togglePlay,
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: _isLoading
                  ? Padding(
                      padding: EdgeInsets.all(8.r),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: accent,
                      ),
                    )
                  : Icon(
                      _player.playing ? Icons.pause : Icons.play_arrow,
                      color: accent,
                      size: 22.sp,
                    ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 3.h,
                    backgroundColor: Colors.white24,
                    color: accent,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _format(_player.playing || _position > Duration.zero
                      ? _position
                      : _duration),
                  style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
