enum NotificationType { info, success, warning, error }

class NotificationEntity {
  final int notificationId;
  final int userId;
  final int companyId;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final int? referenceId;
  final String? referenceType;
  final DateTime createdAt;

  const NotificationEntity({
    required this.notificationId,
    required this.userId,
    required this.companyId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    this.referenceId,
    this.referenceType,
    required this.createdAt,
  });

  NotificationEntity copyWith({
    int? notificationId,
    int? userId,
    int? companyId,
    String? title,
    String? message,
    NotificationType? type,
    bool? isRead,
    int? referenceId,
    String? referenceType,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      companyId: companyId ?? this.companyId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      referenceId: referenceId ?? this.referenceId,
      referenceType: referenceType ?? this.referenceType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class NotificationSummaryEntity {
  final int total;
  final int unread;
  final int read;

  const NotificationSummaryEntity({
    required this.total,
    required this.unread,
    required this.read,
  });

  NotificationSummaryEntity copyWith({int? total, int? unread, int? read}) =>
      NotificationSummaryEntity(
        total: total ?? this.total,
        unread: unread ?? this.unread,
        read: read ?? this.read,
      );
}
