import 'dart:async';

import 'package:abbas/presentation/views/message/provider/call_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AudioCallScreen extends StatefulWidget {
  final String conversationId;
  final String callKind;
  final bool autoStart;
  final String? callerName;
  final String? callerAvatar;

  const AudioCallScreen({
    super.key,
    required this.conversationId,
    this.callKind = 'AUDIO',
    this.autoStart = true,
    this.callerName,
    this.callerAvatar,
  });

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  Timer? _timer;
  int _seconds = 0;
  bool _callActive = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<CallProvider>();

      if (widget.autoStart) {
        final success = await provider.startCall(
          widget.conversationId,
          kind: widget.callKind,
        );
        if (success && mounted) {
          _callActive = true;
          _startTimer();
        }
      } else if (provider.isInCall) {
        _callActive = true;
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !_callActive) return;
      setState(() => _seconds++);
    });
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _endCall() async {
    _callActive = false;
    await context.read<CallProvider>().endCall(widget.conversationId);
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (_callActive) {
      context.read<CallProvider>().leaveCall(widget.conversationId);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CallProvider>();

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: SafeArea(
        child: provider.errorMessage != null && !provider.isInCall
            ? _buildError(provider)
            : _buildBody(provider),
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
            Icon(Icons.error_outline, color: Colors.red, size: 56.r),
            SizedBox(height: 16.h),
            Text(
              provider.errorMessage ?? 'Unable to connect call',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            ),
            SizedBox(height: 20.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(CallProvider provider) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 58.r,
                  backgroundColor: Colors.white12,
                  backgroundImage: (widget.callerAvatar != null &&
                      widget.callerAvatar!.isNotEmpty)
                      ? NetworkImage(widget.callerAvatar!)
                      : null,
                  child: (widget.callerAvatar == null || widget.callerAvatar!.isEmpty)
                      ? Icon(Icons.person, color: Colors.white, size: 44.r)
                      : null,
                ),
                SizedBox(height: 20.h),
                Text(
                  widget.callerName ?? 'Audio Call',
                  style: TextStyle(color: Colors.white, fontSize: 22.sp),
                ),
                SizedBox(height: 10.h),
                Text(
                  provider.isInCall ? _formatDuration(_seconds) : 'Connecting...',
                  style: TextStyle(color: Colors.white70, fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 40.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                icon: provider.isMuted ? Icons.mic_off : Icons.mic,
                color: provider.isMuted ? Colors.redAccent : Colors.white,
                onPressed: provider.toggleMute,
              ),
              SizedBox(width: 28.w),
              _buildButton(
                icon: Icons.call_end,
                color: Colors.red,
                isEnd: true,
                onPressed: _endCall,
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
    bool isEnd = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: isEnd ? 70.r : 60.r,
        height: isEnd ? 70.r : 60.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.18),
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(icon, color: color, size: isEnd ? 30.r : 24.r),
      ),
    );
  }
}
