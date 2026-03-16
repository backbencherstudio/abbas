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

class _AudioCallScreenState extends State<AudioCallScreen>
    with SingleTickerProviderStateMixin {
  bool _hasJoined = false;
  bool _isCallActive = false;
  late AnimationController _pulseAnimation;
  late Animation<double> _pulseAnimationValue;

  // Timer for call duration
  int _callSeconds = 0;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();

    // Setup pulse animation for the caller avatar
    _pulseAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimationValue = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseAnimation, curve: Curves.easeInOut),
    );

    // Use WidgetsBinding to call after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initiateCall();
    });
  }

  @override
  void dispose() {
    _pulseAnimation.dispose();
    _stopTimer();
    if (_hasJoined) {
      Provider.of<CallProvider>(
        context,
        listen: false,
      ).leaveCall(widget.conversationId);
    }
    super.dispose();
  }

  // Start call timer
  void _startTimer() {
    _isTimerRunning = true;
    _callSeconds = 0;
    Future.delayed(const Duration(seconds: 1), _tickTimer);
  }

  void _tickTimer() {
    if (_isTimerRunning && mounted) {
      setState(() {
        _callSeconds++;
      });
      Future.delayed(const Duration(seconds: 1), _tickTimer);
    }
  }

  void _stopTimer() {
    _isTimerRunning = false;
  }

  // Format seconds to MM:SS
  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _initiateCall() async {
    if (!mounted) return;

    final provider = Provider.of<CallProvider>(context, listen: false);

    // Print debug info
    provider.printState();

    final success = await provider.startCall(
      widget.conversationId,
      kind: widget.callKind,
    );

    if (success && mounted) {
      setState(() {
        _hasJoined = true;
        _isCallActive = true;
      });
      _startTimer(); // Start timer when call connects
    }
  }

  Future<void> _endCall() async {
    _pulseAnimation.stop();
    _stopTimer();

    final provider = Provider.of<CallProvider>(context, listen: false);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );

    await provider.leaveCall(widget.conversationId);

    if (mounted) {
      Navigator.pop(context); // Remove loading dialog
      Navigator.pop(context); // Go back to previous screen
    }
  }

  Future<void> _toggleSpeaker() async {
    // Implement speaker toggle
    // You can add this to LiveKitService
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Speaker toggled'),
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CallProvider>();

    return WillPopScope(
      onWillPop: () async {
        // Prevent back button during call
        if (provider.isInCall) {
          _showExitDialog();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xff030D15),
        body: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xff030D15),
                    const Color(0xff1A1F2C).withOpacity(0.9),
                    const Color(0xff030D15),
                  ],
                ),
              ),
            ),

            // Animated background circles
            ...List.generate(3, (index) {
              return Positioned(
                top: MediaQuery.of(context).size.height * (0.2 + index * 0.15),
                right: -50.r + (index * 30.r),
                child: Container(
                  width: 200.r - (index * 30.r),
                  height: 200.r - (index * 30.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.03 - (index * 0.01)),
                  ),
                ),
              );
            }),

            SafeArea(
              child: provider.isLoading
                  ? _buildLoadingState()
                  : provider.errorMessage != null
                  ? _buildErrorState(provider)
                  : _buildCallActiveState(provider),
            ),

            // Close button when loading or error
            if (provider.isLoading || provider.errorMessage != null)
              Positioned(
                top: 20.h,
                left: 20.w,
                child: IconButton(
                  icon: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20.r,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1A1F2C),
        title: Text(
          'End Call?',
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
        content: Text(
          'Are you sure you want to end this call?',
          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _endCall();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('End Call'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated loader
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 1.0 + (value * 0.1),
                child: Container(
                  width: 120.r,
                  height: 120.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        Colors.blue.withOpacity(0.8),
                        Colors.purple.withOpacity(0.5),
                        Colors.blue.withOpacity(0.8),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 100.r,
                      height: 100.r,
                      decoration: const BoxDecoration(
                        color: Color(0xff030D15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.call,
                        color: Colors.white.withOpacity(0.9),
                        size: 40.r,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 40.h),
          Text(
            "Connecting call...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            widget.callerName ?? "Unknown",
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 20.h),
          // Show connection status
          // if (provider.currentCallId != null)
          //   Text(
          //     "Call ID: ${provider.currentCallId}",
          //     style: TextStyle(
          //       color: Colors.white.withOpacity(0.3),
          //       fontSize: 10.sp,
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _buildErrorState(CallProvider provider) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon with glow effect
            Container(
              width: 120.r,
              height: 120.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 30.r,
                    spreadRadius: 5.r,
                  ),
                ],
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 60.r,
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              "Call Failed",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              provider.errorMessage ?? "Unable to connect call",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 40.h),
            // Retry button
            _buildGlassButton(
              icon: Icons.refresh_rounded,
              label: "Try Again",
              onTap: () {
                provider.clearError();
                _initiateCall();
              },
            ),
            SizedBox(height: 16.h),
            // Back button
            _buildGlassButton(
              icon: Icons.arrow_back_rounded,
              label: "Go Back",
              onTap: () => Navigator.pop(context),
              isSecondary: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallActiveState(CallProvider provider) {
    if (!_isCallActive) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Column(
        children: [
          // Top section with call info
          Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Connected",
                        style: TextStyle(
                          color: Colors.green.withOpacity(0.8),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Text(
                    "Call ID: ${provider.currentCallId?.substring(0, 8) ?? 'N/A'}...",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated caller avatar
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimationValue.value,
                        child: Container(
                          width: 160.r,
                          height: 160.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.blue.withOpacity(0.3),
                                Colors.purple.withOpacity(0.1),
                                Colors.transparent,
                              ],
                              stops: const [0.4, 0.7, 1.0],
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 130.r,
                              height: 130.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 3.r,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 30.r,
                                    spreadRadius: 5.r,
                                  ),
                                ],
                                image: widget.callerAvatar != null
                                    ? DecorationImage(
                                  image: NetworkImage(
                                    widget.callerAvatar!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                                color: widget.callerAvatar == null
                                    ? Colors.blue.withOpacity(0.2)
                                    : null,
                              ),
                              child: widget.callerAvatar == null
                                  ? Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 60.r,
                              )
                                  : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    widget.callerName ?? "Unknown Caller",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.callKind == "AUDIO" ? "Audio Call" : "Video Call",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Call timer
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(
                      _formatDuration(_callSeconds),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'monospace',
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom control buttons
          Padding(
            padding: EdgeInsets.only(bottom: 50.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mute button
                _buildCallControlButton(
                  icon: provider.isMuted
                      ? Icons.mic_off_rounded
                      : Icons.mic_rounded,
                  label: provider.isMuted ? "Unmute" : "Mute",
                  color: provider.isMuted ? Colors.red : Colors.white,
                  onPressed: provider.toggleMute,
                ),
                SizedBox(width: 30.w),

                // End call button
                _buildCallControlButton(
                  icon: Icons.call_end_rounded,
                  label: "End",
                  color: Colors.red,
                  onPressed: _showExitDialog,
                  isEndCall: true,
                  size: 70.r,
                ),
                SizedBox(width: 30.w),

                // Speaker button
                _buildCallControlButton(
                  icon: Icons.volume_up_rounded,
                  label: "Speaker",
                  color: Colors.white,
                  onPressed: _toggleSpeaker,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool isEndCall = false,
    double size = 60,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: isEndCall ? size + 10.r : size.r,
            height: isEndCall ? size + 10.r : size.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.15),
              border: Border.all(color: color.withOpacity(0.5), width: 2.r),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 15.r,
                  spreadRadius: 2.r,
                ),
              ],
              gradient: RadialGradient(
                colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
              ),
            ),
            child: Icon(icon, color: color, size: isEndCall ? 30.r : 25.r),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isSecondary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSecondary
                ? [
              Colors.white.withOpacity(0.05),
              Colors.white.withOpacity(0.02),
            ]
                : [
              Colors.blue.withOpacity(0.2),
              Colors.purple.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSecondary
                ? Colors.white.withOpacity(0.1)
                : Colors.blue.withOpacity(0.3),
            width: 1.r,
          ),
          boxShadow: [
            BoxShadow(
              color: isSecondary
                  ? Colors.transparent
                  : Colors.blue.withOpacity(0.2),
              blurRadius: 10.r,
              spreadRadius: 2.r,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSecondary ? Colors.white.withOpacity(0.7) : Colors.white,
              size: 20.r,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: isSecondary
                    ? Colors.white.withOpacity(0.7)
                    : Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}