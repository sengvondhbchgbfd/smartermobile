import 'package:equatable/equatable.dart';

class AuditLogEntity extends Equatable {
  final int logId;
  final int? userId;
  final String action;
  final String tableName;
  final int? recordId;
  final Map<String, dynamic>? oldValue;
  final Map<String, dynamic>? newValue;
  final String? ipAddress;
  final DateTime createdAt;

  const AuditLogEntity({
    required this.logId,
    this.userId,
    required this.action,
    required this.tableName,
    this.recordId,
    this.oldValue,
    this.newValue,
    this.ipAddress,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [logId, userId, action, tableName, recordId, createdAt];
}