import '../entities/notification_entity.dart';
abstract class NotificationRepository {
  // ── Queries ──────────────────────────────────────────────────────────────
  Future<List<NotificationEntity>> getMyNotifications({bool unreadOnly = false});
  Future<NotificationSummaryEntity> getSummary();
  // ── Admin ─────────────────────────────────────────────────────────────────
  Future<List<NotificationEntity>> getAllNotifications({bool unreadOnly = false});
  Future<NotificationEntity> createNotification({
    required int userId,
    required String title,
    required String message,
    required String type,
    int?    referenceId,
    String? referenceType,
  });

  // ── Mutations ─────────────────────────────────────────────────────────────
  Future<NotificationEntity> markOneRead(int notificationId);
  Future<void>               markAllRead();
  Future<void>               bulkMarkRead(List<int> ids);
  Future<void>               deleteOne(int notificationId);
  Future<void>               deleteAllRead();
}
