
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetMyNotificationsUseCase {
  final NotificationRepository _repo;
  GetMyNotificationsUseCase(this._repo);

  Future<List<NotificationEntity>> call({bool unreadOnly = false}) =>
      _repo.getMyNotifications(unreadOnly: unreadOnly);
}

class GetSummaryUseCase {
  final NotificationRepository _repo;
  GetSummaryUseCase(this._repo);

  Future<NotificationSummaryEntity> call() => _repo.getSummary();
}

class GetAllNotificationsUseCase {
  final NotificationRepository _repo;
  GetAllNotificationsUseCase(this._repo);

  Future<List<NotificationEntity>> call({bool unreadOnly = false}) =>
      _repo.getAllNotifications(unreadOnly: unreadOnly);
}

class CreateNotificationUseCase {
  final NotificationRepository _repo;
  CreateNotificationUseCase(this._repo);

  Future<NotificationEntity> call({
    required int    userId,
    required String title,
    required String message,
    required String type,
    int?    referenceId,
    String? referenceType,
  }) =>
      _repo.createNotification(
        userId:        userId,
        title:         title,
        message:       message,
        type:          type,
        referenceId:   referenceId,
        referenceType: referenceType,
      );
}

class MarkOneReadUseCase {
  final NotificationRepository _repo;
  MarkOneReadUseCase(this._repo);

  Future<NotificationEntity> call(int id) => _repo.markOneRead(id);
}

class MarkAllReadUseCase {
  final NotificationRepository _repo;
  MarkAllReadUseCase(this._repo);

  Future<void> call() => _repo.markAllRead();
}

class BulkMarkReadUseCase {
  final NotificationRepository _repo;
  BulkMarkReadUseCase(this._repo);

  Future<void> call(List<int> ids) => _repo.bulkMarkRead(ids);
}

class DeleteOneUseCase {
  final NotificationRepository _repo;
  DeleteOneUseCase(this._repo);

  Future<void> call(int id) => _repo.deleteOne(id);
}

class DeleteAllReadUseCase {
  final NotificationRepository _repo;
  DeleteAllReadUseCase(this._repo);

  Future<void> call() => _repo.deleteAllRead();
}
