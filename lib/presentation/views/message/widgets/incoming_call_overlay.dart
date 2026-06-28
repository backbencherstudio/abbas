import 'package:abbas/presentation/views/message/model/call_model.dart';
import 'package:abbas/presentation/views/message/provider/call_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CallOverlayHost extends ConsumerWidget {
  final Widget child;

  const CallOverlayHost({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callState = ref.watch(callProvider);
    final incoming = callState.incomingCall;

    return Stack(
      children: [
        child,
        if (incoming != null && !callState.isInCall && !callState.isConnecting)
          Positioned(
            left: 12.w,
            right: 12.w,
            top: MediaQuery.paddingOf(context).top + 8.h,
            child: _IncomingCallBanner(
              incoming: incoming,
              title: incoming.callerName ??
                  incoming.conversationTitle ??
                  'Incoming call',
            ),
          ),
      ],
    );
  }
}

class _IncomingCallBanner extends ConsumerWidget {
  final IncomingCallData incoming;
  final String title;

  const _IncomingCallBanner({
    required this.incoming,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kindLabel = incoming.kind.isVideo ? 'Video' : 'Audio';

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16.r),
      color: const Color(0xff152033),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: const Color(0xff24324A),
              backgroundImage: incoming.callerAvatar != null &&
                      incoming.callerAvatar!.isNotEmpty
                  ? NetworkImage(incoming.callerAvatar!)
                  : null,
              child: incoming.callerAvatar == null ||
                      incoming.callerAvatar!.isEmpty
                  ? Icon(
                      incoming.kind.isVideo ? Icons.videocam : Icons.phone,
                      color: const Color(0xffE9201D),
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    incoming.conversationType.isGroup
                        ? 'Incoming group $kindLabel call'
                        : 'Incoming $kindLabel call',
                    style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () =>
                  ref.read(callProvider.notifier).declineIncoming(),
              icon: Icon(Icons.call_end, color: Colors.red, size: 28.sp),
            ),
            SizedBox(width: 4.w),
            IconButton(
              onPressed: () => ref.read(callProvider.notifier).acceptIncoming(
                    title: title,
                  ),
              icon: Icon(Icons.call, color: Colors.green, size: 28.sp),
            ),
          ],
        ),
      ),
    );
  }
}
