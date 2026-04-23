import 'dart:ui';

import 'package:abbas/presentation/views/message/provider/call_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class IncomingCallScreen extends StatelessWidget {
  final String conversationId;
  final String callerName;
  final String callerAvatar;
  final String callKind;

  const IncomingCallScreen({
    super.key,
    required this.conversationId,
    required this.callerName,
    required this.callerAvatar,
    required this.callKind,
  });

  @override
  Widget build(BuildContext context) {
    final isAudio = callKind.toUpperCase() == 'AUDIO';

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (callerAvatar.isNotEmpty)
              Image.network(
                callerAvatar,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallbackBg(),
              )
            else
              _fallbackBg(),
            Container(color: Colors.black.withValues(alpha: 0.45)),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  children: [
                    const Spacer(),
                    CircleAvatar(
                      radius: 58.r,
                      backgroundColor: Colors.white12,
                      backgroundImage: callerAvatar.isNotEmpty
                          ? NetworkImage(callerAvatar)
                          : null,
                      child: callerAvatar.isEmpty
                          ? Icon(Icons.person, color: Colors.white, size: 42.r)
                          : null,
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      callerName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      isAudio ? 'Incoming audio call...' : 'Incoming video call...',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15.sp,
                      ),
                    ),
                    const Spacer(),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(36.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                            vertical: 16.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(36.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _actionButton(
                                label: 'Decline',
                                color: Colors.redAccent,
                                icon: Icons.call_end,
                                onTap: () async {
                                  await context.read<CallProvider>().rejectIncomingCall();
                                  if (context.mounted) Navigator.pop(context);
                                },
                              ),
                              _actionButton(
                                label: 'Accept',
                                color: Colors.green,
                                icon: Icons.call,
                                onTap: () async {
                                  await context.read<CallProvider>().acceptIncomingCall();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackBg() {
    return Container(color: const Color(0xff030D15));
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Icon(icon, color: Colors.white, size: 30.sp),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
      ],
    );
  }
}
