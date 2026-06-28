import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/notifications/model/notification_model.dart';
import 'package:abbas/presentation/views/notifications/provider/notifications_provider.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(
      () => ref.read(notificationsProvider.notifier).loadInitial(),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(notificationsProvider.notifier).loadMore();
    }
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return '';
    final date = DateTime.tryParse(value);
    if (date == null) return '';
    return DateFormat('dd MMM yyyy, hh:mm a').format(date.toLocal());
  }

  Future<void> _markAllAsRead() async {
    final error = await ref.read(notificationsProvider.notifier).markAllAsRead();
    if (!mounted || error == null) return;
    Utils.showToast(
      msg: error,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> _onNotificationTap(AppNotification notification) async {
    if (!notification.isRead) {
      final error = await ref
          .read(notificationsProvider.notifier)
          .markAsRead(notification.id);
      if (!mounted) return;
      if (error != null) {
        Utils.showToast(
          msg: error,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  Future<void> _deleteNotification(AppNotification notification) async {
    final error = await ref
        .read(notificationsProvider.notifier)
        .deleteNotification(notification.id);
    if (!mounted) return;
    if (error != null) {
      Utils.showToast(
        msg: error,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          if (state.unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark all read',
                style: TextStyle(
                  color: const Color(0xFF8D9CDC),
                  fontSize: 13.sp,
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(notificationsProvider.notifier).refresh(),
        color: AppColors.activeButtonColor,
        backgroundColor: AppColors.cardBackground,
        child: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(NotificationsState state) {
    if (state.isLoading && state.notifications.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 120.h),
          const Center(child: AnimatedLoading()),
        ],
      );
    }

    if (state.error != null && state.notifications.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(24.w),
        children: [
          SizedBox(height: 80.h),
          Icon(Icons.error_outline, color: Colors.red, size: 40.sp),
          SizedBox(height: 12.h),
          Text(
            state.error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
          SizedBox(height: 16.h),
          Center(
            child: ElevatedButton(
              onPressed: () =>
                  ref.read(notificationsProvider.notifier).loadInitial(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.activeButtonColor,
              ),
              child: const Text('Retry'),
            ),
          ),
        ],
      );
    }

    if (state.notifications.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 120.h),
          Icon(Icons.notifications_none, color: Colors.white38, size: 48.sp),
          SizedBox(height: 12.h),
          Text(
            'No notifications yet',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 16.sp),
          ),
        ],
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: state.notifications.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.notifications.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final notification = state.notifications[index];
        return _NotificationTile(
          notification: notification,
          formattedDate: _formatDate(notification.createdAt),
          onTap: () => _onNotificationTap(notification),
          onDelete: () => _deleteNotification(notification),
        );
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final String formattedDate;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationTile({
    required this.notification,
    required this.formattedDate,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.red.shade700,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Material(
        color: notification.isRead
            ? const Color(0xFF0A1A29)
            : const Color(0xFF142331),
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: notification.isRead
                    ? const Color(0xFF3D4566)
                    : const Color(0xFF8D9CDC),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!notification.isRead)
                  Container(
                    width: 8.w,
                    height: 8.w,
                    margin: EdgeInsets.only(top: 6.h, right: 10.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE9201D),
                      shape: BoxShape.circle,
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title ?? 'Notification',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (notification.content?.isNotEmpty == true) ...[
                        SizedBox(height: 6.h),
                        Text(
                          notification.content!,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13.sp,
                            height: 1.4,
                          ),
                        ),
                      ],
                      if (formattedDate.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.close,
                    color: Colors.white38,
                    size: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
