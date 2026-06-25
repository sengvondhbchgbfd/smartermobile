import '../entities/audit_log_entity.dart';

abstract class AuditLogRepository {
  Future<List<AuditLogEntity>> getAllLogs({int limit = 50});
  Future<List<AuditLogEntity>> getLogsByUser(int userId, {int limit = 50});
  Future<List<AuditLogEntity>> getLogsByTable(String tableName, {int limit = 50});
  Future<List<AuditLogEntity>> getLogsByAction(String action, {int limit = 50});
  Future<AuditLogEntity> getLogById(int logId);
}