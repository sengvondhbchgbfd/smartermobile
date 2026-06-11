import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.notificationId,
    required super.userId,
    required super.companyId,
    required super.title,
    required super.message,
    required super.type,
    required super.isRead,
    super.referenceId,
    super.referenceType,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notification_id'] as int,
<<<<<<< HEAD
      userId:         json['user_id']         as int,
      companyId:      json['company_id']       as int,
      title:          json['title']            as String,
      message:        json['message']          as String,
      type:           _parseType(json['type'] as String? ?? 'info'),
      isRead:         json['is_read']          as bool? ?? false,
      referenceId:    json['reference_id']     as int?,
      referenceType:  json['reference_type']   as String?,
      createdAt:      DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'notification_id': notificationId,
    'user_id':         userId,
    'company_id':      companyId,
    'title':           title,
    'message':         message,
    'type':            type.name,
    'is_read':         isRead,
    'reference_id':    referenceId,
    'reference_type':  referenceType,
    'created_at':      createdAt.toIso8601String(),
=======
      userId: json['user_id'] as int,
      companyId: (json['company_id'] as int?) ?? 0,
      title: json['title'] as String,
      message: json['message'] as String,
      type: _parseType(json['type'] as String? ?? 'info'),
      isRead: json['is_read'] as bool? ?? false,
      referenceId: json['reference_id'] as int?,
      referenceType: json['reference_type'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
  Map<String, dynamic> toJson() => {
    'notification_id': notificationId,
    'user_id': userId,
    'company_id': companyId,
    'title': title,
    'message': message,
    'type': type.name,
    'is_read': isRead,
    'reference_id': referenceId,
    'reference_type': referenceType,
    'created_at': createdAt.toIso8601String(),
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  };

  static NotificationType _parseType(String raw) {
    switch (raw) {
<<<<<<< HEAD
      case 'success': return NotificationType.success;
      case 'warning': return NotificationType.warning;
      case 'error':   return NotificationType.error;
      default:        return NotificationType.info;
=======
      case 'success':
        return NotificationType.success;
      case 'warning':
        return NotificationType.warning;
      case 'error':
        return NotificationType.error;
      default:
        return NotificationType.info;
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
    }
  }
}

class NotificationSummaryModel extends NotificationSummaryEntity {
  const NotificationSummaryModel({
    required super.total,
    required super.unread,
    required super.read,
  });

  factory NotificationSummaryModel.fromJson(Map<String, dynamic> json) {
    return NotificationSummaryModel(
<<<<<<< HEAD
      total:  json['total']  as int? ?? 0,
      unread: json['unread'] as int? ?? 0,
      read:   json['read']   as int? ?? 0,
=======
      total: json['total'] as int? ?? 0,
      unread: json['unread'] as int? ?? 0,
      read: json['read'] as int? ?? 0,
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
    );
  }
}
