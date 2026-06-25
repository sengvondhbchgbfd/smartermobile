import '../../domain/entities/audit_log_entity.dart';
import '../../domain/repositories/audit_log_repository.dart';
import '../datasources/audit_log_remote_datasource.dart';

class AuditLogRepositoryImpl implements AuditLogRepository {
  final AuditLogRemoteDataSource dataSource;
  AuditLogRepositoryImpl(this.dataSource);

  @override
  Future<List<AuditLogEntity>> getAllLogs({int limit = 50}) =>
      dataSource.getAllLogs(limit: limit);

  @override
  Future<List<AuditLogEntity>> getLogsByUser(int userId, {int limit = 50}) =>
      dataSource.getLogsByUser(userId, limit: limit);

  @override
  Future<List<AuditLogEntity>> getLogsByTable(
    String tableName, {
    int limit = 50,
  }) => dataSource.getLogsByTable(tableName, limit: limit);

  @override
  Future<List<AuditLogEntity>> getLogsByAction(
    String action, {
    int limit = 50,
  }) => dataSource.getLogsByAction(action, limit: limit);

  @override
  Future<AuditLogEntity> getLogById(int logId) => dataSource.getLogById(logId);
}
