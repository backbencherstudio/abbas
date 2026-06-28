import 'package:abbas/cors/constants/api_endpoints.dart';
import 'package:abbas/cors/services/dio_client.dart';
import 'package:abbas/data/models/response_model.dart';
import 'package:abbas/presentation/views/notifications/model/notification_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class NotificationsState {
  final List<AppNotification> notifications;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? error;
  final String? nextCursor;
  final int unreadCount;
  final bool hasMore;

  const NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.error,
    this.nextCursor,
    this.unreadCount = 0,
    this.hasMore = true,
  });

  NotificationsState copyWith({
    List<AppNotification>? notifications,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? error,
    bool clearError = false,
    String? nextCursor,
    bool clearNextCursor = false,
    int? unreadCount,
    bool? hasMore,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: clearError ? null : (error ?? this.error),
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      unreadCount: unreadCount ?? this.unreadCount,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>(
      (ref) => NotificationsNotifier(dioClient: DioClient()),
    );

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final DioClient dioClient;

  NotificationsNotifier({required this.dioClient})
    : super(const NotificationsState());

  static const int _pageSize = 10;
  bool _isFetching = false;

  Future<void> loadUnreadCount() async {
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.notifications(limit: 1),
      );

      if (res is Map && res['success'] == true) {
        final model = NotificationsResponse.fromJson(
          Map<String, dynamic>.from(res),
        );
        state = state.copyWith(
          unreadCount: model.metaData?.unreadCount ?? 0,
          clearError: true,
        );
      }
    } catch (_) {}
  }

  Future<void> loadInitial() async {
    if (_isFetching) return;
    state = state.copyWith(isLoading: true, clearError: true);
    await _fetch(cursor: null, append: false);
  }

  Future<void> refresh() async {
    if (_isFetching) return;
    state = state.copyWith(isRefreshing: true, clearError: true);
    await _fetch(cursor: null, append: false);
  }

  Future<void> loadMore() async {
    if (_isFetching || !state.hasMore || state.nextCursor == null) return;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    await _fetch(cursor: state.nextCursor, append: true);
  }

  Future<void> _fetch({required String? cursor, required bool append}) async {
    _isFetching = true;
    try {
      final res = await dioClient.getHttp(
        ApiEndpoints.notifications(limit: _pageSize, cursor: cursor),
      );

      if (res is ResponseModel) {
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          isRefreshing: false,
          error: res.message,
        );
        return;
      }

      if (res is Map && res['success'] == true) {
        final model = NotificationsResponse.fromJson(
          Map<String, dynamic>.from(res),
        );

        final merged = append
            ? [...state.notifications, ...model.data]
            : model.data;

        state = state.copyWith(
          notifications: merged,
          isLoading: false,
          isLoadingMore: false,
          isRefreshing: false,
          clearError: true,
          nextCursor: model.metaData?.nextCursor,
          clearNextCursor: model.metaData?.nextCursor == null,
          unreadCount: model.metaData?.unreadCount ?? state.unreadCount,
          hasMore: model.metaData?.nextCursor != null,
        );
        return;
      }

      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        error: res is Map
            ? (res['message']?.toString() ?? 'Failed to load notifications')
            : 'Failed to load notifications',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        isRefreshing: false,
        error: '$e',
      );
    } finally {
      _isFetching = false;
    }
  }

  Future<String?> markAsRead(String notificationId) async {
    try {
      final res = await dioClient.patchHttp(
        ApiEndpoints.readNotification(notificationId),
      );

      if (res is ResponseModel) return res.message;

      if (res is Map && res['success'] == true) {
        final updated = state.notifications.map((item) {
          if (item.id == notificationId) {
            return item.copyWith(isRead: true);
          }
          return item;
        }).toList();

        final unread = updated.where((item) => !item.isRead).length;
        state = state.copyWith(
          notifications: updated,
          unreadCount: unread,
        );
        return null;
      }

      return res is Map
          ? (res['message']?.toString() ?? 'Failed to mark as read')
          : 'Failed to mark as read';
    } catch (e) {
      return '$e';
    }
  }

  Future<String?> markAllAsRead() async {
    try {
      final res = await dioClient.patchHttp(ApiEndpoints.readAllNotifications);

      if (res is ResponseModel) return res.message;

      if (res is Map && res['success'] == true) {
        final updated = state.notifications
            .map((item) => item.copyWith(isRead: true))
            .toList();
        state = state.copyWith(notifications: updated, unreadCount: 0);
        return null;
      }

      return res is Map
          ? (res['message']?.toString() ?? 'Failed to mark all as read')
          : 'Failed to mark all as read';
    } catch (e) {
      return '$e';
    }
  }

  Future<String?> deleteNotification(String notificationId) async {
    try {
      final res = await dioClient.deleteHttp(
        ApiEndpoints.deleteNotification(notificationId),
      );

      if (res is ResponseModel) return res.message;

      if (res is Map && res['success'] == true) {
        final updated = state.notifications
            .where((item) => item.id != notificationId)
            .toList();
        final unread = updated.where((item) => !item.isRead).length;
        state = state.copyWith(
          notifications: updated,
          unreadCount: unread,
        );
        return null;
      }

      return res is Map
          ? (res['message']?.toString() ?? 'Failed to delete notification')
          : 'Failed to delete notification';
    } catch (e) {
      return '$e';
    }
  }
}
