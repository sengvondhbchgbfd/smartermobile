import '../../domain/entities/audit_log_entity.dart';

class AuditLogModel extends AuditLogEntity {
  const AuditLogModel({
    required super.logId,
    super.userId,
    required super.action,
    required super.tableName,
    super.recordId,
    super.oldValue,
    super.newValue,
    super.ipAddress,
    required super.createdAt,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) => AuditLogModel(
    logId: json['log_id'] as int,
    userId: json['user_id'] as int?,
    action: json['action'] as String,
    tableName: json['table_name'] as String,
    recordId: json['record_id'] as int?,
    oldValue: json['old_value'] != null
        ? Map<String, dynamic>.from(json['old_value'] as Map)
        : null,
    newValue: json['new_value'] != null
        ? Map<String, dynamic>.from(json['new_value'] as Map)
        : null,
    ipAddress: json['ip_address'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}
