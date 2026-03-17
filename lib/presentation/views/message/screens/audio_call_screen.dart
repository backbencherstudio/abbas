import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provider/call_provider.dart';

class AudioCallScreen extends StatefulWidget {
  final String conversationId;
  final String callKind;
  final String? callerName;
  final String? callerAvatar;

  const AudioCallScreen({
    super.key,
    required this.conversationId,
    this.callKind = "AUDIO",
    this.callerName,
    this.callerAvatar,
  });

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  bool _isCallActive = false;
  int _callSeconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initiateCall();
    });
  }

  @override
  void dispose() {
    if (_isCallActive) {
      Provider.of<CallProvider>(
        context,
        listen: false,
      ).leaveCall(widget.conversationId);
    }
    super.dispose();
  }

  Future<void> _initiateCall() async {
    if (!mounted) return;

    final provider = Provider.of<CallProvider>(context, listen: false);
    final success = await provider.startCall(
      widget.conversationId,
      kind: widget.callKind,
    );

    if (success && mounted) {
      setState(() => _isCallActive = true);
      _startTimer();
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isCallActive) {
        setState(() => _callSeconds++);
        _startTimer();
      }
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _endCall() async {
    final provider = Provider.of<CallProvider>(context, listen: false);
    await provider.leaveCall(widget.conversationId);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CallProvider>();

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: SafeArea(
        child: provider.isLoading
            ? _buildLoading()
            : provider.errorMessage != null
            ? _buildError(provider)
            : _buildCallActive(provider),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 20.h),
          Text(
            "Connecting call...",
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
        ],
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
            Icon(Icons.error_outline, color: Colors.red, size: 60.r),
            SizedBox(height: 20.h),
            Text(
              "Call Failed",
              style: TextStyle(color: Colors.white, fontSize: 20.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              provider.errorMessage ?? "Unable to connect call",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () {
                provider.clearError();
                _initiateCall();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
              ),
              child: const Text("Try Again"),
            ),
            SizedBox(height: 10.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Go Back",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallActive(CallProvider provider) {
    if (!_isCallActive) return const SizedBox.shrink();

    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60.r,
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  backgroundImage: widget.callerAvatar != null
                      ? NetworkImage(widget.callerAvatar!)
                      : null,
                  child: widget.callerAvatar == null
                      ? Icon(Icons.person, color: Colors.white, size: 40.r)
                      : null,
                ),
                SizedBox(height: 20.h),
                Text(
                  widget.callerName ?? "Unknown Caller",
                  style: TextStyle(color: Colors.white, fontSize: 22.sp),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _formatDuration(_callSeconds),
                    style: TextStyle(color: Colors.white, fontSize: 24.sp),
                  ),
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
                color: provider.isMuted ? Colors.red : Colors.white,
                onPressed: provider.toggleMute,
              ),
              SizedBox(width: 30.w),
              _buildButton(
                icon: Icons.call_end,
                color: Colors.red,
                onPressed: _endCall,
                isEndCall: true,
              ),
              SizedBox(width: 30.w),
              _buildButton(
                icon: Icons.volume_up,
                color: Colors.white,
                onPressed: () {},
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
    bool isEndCall = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: isEndCall ? 70.r : 60.r,
        height: isEndCall ? 70.r : 60.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.2),
          border: Border.all(color: color, width: 2.r),
        ),
        child: Icon(icon, color: color, size: isEndCall ? 30.r : 25.r),
      ),
    );
  }
}
