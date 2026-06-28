import 'package:abbas/cors/routes/route_names.dart';
import 'package:abbas/presentation/views/notifications/provider/notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationBellButton extends ConsumerStatefulWidget {
  const NotificationBellButton({super.key});

  @override
  ConsumerState<NotificationBellButton> createState() =>
      _NotificationBellButtonState();
}

class _NotificationBellButtonState extends ConsumerState<NotificationBellButton> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(notificationsProvider.notifier).loadUnreadCount(),
    );
  }

  Future<void> _openNotifications() async {
    await Navigator.pushNamed(context, RouteNames.notificationsScreen);
    if (!mounted) return;
    ref.read(notificationsProvider.notifier).loadUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = ref.watch(notificationsProvider).unreadCount;

    return GestureDetector(
      onTap: _openNotifications,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            'assets/icons/notification.svg',
            width: 24.w,
            height: 24.h,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              top: -2.h,
              right: -2.w,
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFE9201D),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
