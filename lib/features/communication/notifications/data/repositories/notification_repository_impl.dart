import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remote;
  NotificationRepositoryImpl(this._remote);

  @override
  Future<List<NotificationEntity>> getMyNotifications({
    bool unreadOnly = false,
  }) => _remote.getMyNotifications(unreadOnly: unreadOnly);

  @override
  Future<NotificationSummaryEntity> getSummary() => _remote.getSummary();

  @override
  Future<List<NotificationEntity>> getAllNotifications({
    bool unreadOnly = false,
  }) => _remote.getAllNotifications(unreadOnly: unreadOnly);

  @override
  Future<NotificationEntity> createNotification({
    required int userId,
    required String title,
    required String message,
    required String type,
    int? referenceId,
    String? referenceType,
  }) => _remote.createNotification({
    'user_id': userId,
    'title': title,
    'message': message,
    'type': type,
    'reference_id': referenceId,
    'reference_type': referenceType,
  });

  @override
  Future<NotificationEntity> markOneRead(int notificationId) =>
      _remote.markOneRead(notificationId);

  @override
  Future<void> markAllRead() => _remote.markAllRead();

  @override
  Future<void> bulkMarkRead(List<int> ids) => _remote.bulkMarkRead(ids);

  @override
  Future<void> deleteOne(int notificationId) =>
      _remote.deleteOne(notificationId);

  @override
  Future<void> deleteAllRead() => _remote.deleteAllRead();
}
