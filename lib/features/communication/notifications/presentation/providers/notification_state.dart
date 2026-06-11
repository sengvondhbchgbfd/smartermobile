
import 'package:flutter/foundation.dart';
import 'package:frontendmobile/features/communication/notifications/domain/entities/notification_entity.dart';

enum NotificationFilter { all, unread }

@immutable
class NotificationState {
  final List<NotificationEntity> notifications;
  final NotificationSummaryEntity? summary;
  final NotificationFilter filter;
  final bool wsConnected;
  final Set<int> selectedIds;
  final bool isSelecting;

  const NotificationState({
    this.notifications = const [],
    this.summary,
    this.filter = NotificationFilter.all,
    this.wsConnected = false,
    this.selectedIds = const {},
    this.isSelecting = false,
  });

  List<NotificationEntity> get displayed => filter == NotificationFilter.unread
      ? notifications.where((n) => !n.isRead).toList()
      : notifications;

  int get unreadCount =>
      summary?.unread ?? notifications.where((n) => !n.isRead).length;

  NotificationState copyWith({
    List<NotificationEntity>? notifications,
    NotificationSummaryEntity? summary,
    NotificationFilter? filter,
    bool? wsConnected,
    Set<int>? selectedIds,
    bool? isSelecting,
  }) => NotificationState(
    notifications: notifications ?? this.notifications,
    summary: summary ?? this.summary,
    filter: filter ?? this.filter,
    wsConnected: wsConnected ?? this.wsConnected,
    selectedIds: selectedIds ?? this.selectedIds,
    isSelecting: isSelecting ?? this.isSelecting,
  );
}