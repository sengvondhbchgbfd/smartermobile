import '../entities/audit_log_entity.dart';
import '../repositories/audit_log_repository.dart';

class GetAllAuditLogsUseCase {
  final AuditLogRepository repository;
  GetAllAuditLogsUseCase(this.repository);
  Future<List<AuditLogEntity>> call({int limit = 50}) =>
      repository.getAllLogs(limit: limit);
}

class GetAuditLogsByUserUseCase {
  final AuditLogRepository repository;
  GetAuditLogsByUserUseCase(this.repository);
  Future<List<AuditLogEntity>> call(int userId, {int limit = 50}) =>
      repository.getLogsByUser(userId, limit: limit);
}

class GetAuditLogsByTableUseCase {
  final AuditLogRepository repository;
  GetAuditLogsByTableUseCase(this.repository);
  Future<List<AuditLogEntity>> call(String tableName, {int limit = 50}) =>
      repository.getLogsByTable(tableName, limit: limit);
}

class GetAuditLogsByActionUseCase {
  final AuditLogRepository repository;
  GetAuditLogsByActionUseCase(this.repository);
  Future<List<AuditLogEntity>> call(String action, {int limit = 50}) =>
      repository.getLogsByAction(action, limit: limit);
}

class GetAuditLogByIdUseCase {
  final AuditLogRepository repository;
  GetAuditLogByIdUseCase(this.repository);
  Future<AuditLogEntity> call(int logId) => repository.getLogById(logId);
}
