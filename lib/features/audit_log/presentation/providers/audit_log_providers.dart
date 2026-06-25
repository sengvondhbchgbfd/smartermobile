import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/di/dependency_injection.dart';
import 'package:frontendmobile/features/audit_log/domain/usecases/get_audit_logs_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/audit_log_remote_datasource.dart';
import '../../data/repositories/audit_log_repository_impl.dart';
import '../../domain/entities/audit_log_entity.dart';
part 'audit_log_providers.g.dart';

// ── filter state ─────────────────────────────────────────────
class AuditLogFilter {
  final String? action;
  final String? table;
  final int limit;

  const AuditLogFilter({this.action, this.table, this.limit = 50});

  AuditLogFilter copyWith({
    String? action,
    String? table,
    int? limit,
    bool clearAction = false,
    bool clearTable = false,
  }) => AuditLogFilter(
    action: clearAction ? null : action ?? this.action,
    table: clearTable ? null : table ?? this.table,
    limit: limit ?? this.limit,
  );
}

// ── datasource ──────────────────────────────────────────────
@riverpod
Future<AuditLogRemoteDataSource> auditLogDataSource(Ref ref) async {
  final client = await ref.watch(dioClientProvider.future);
  return AuditLogRemoteDataSourceImpl(client);
}


// ── repository ───────────────────────────────────────────────
@riverpod
Future<AuditLogRepositoryImpl> auditLogRepository(Ref ref) async {
  final ds = await ref.watch(auditLogDataSourceProvider.future);
  return AuditLogRepositoryImpl(ds);
}

// ── filter state ─────────────────────────────────────────────
@riverpod
class AuditLogFilterNotifier extends _$AuditLogFilterNotifier {
  @override
  AuditLogFilter build() => const AuditLogFilter();

  void update(AuditLogFilter Function(AuditLogFilter) updater) {
    state = updater(state);
  }
}

// ── main list ────────────────────────────────────────────────
@riverpod
Future<List<AuditLogEntity>> auditLogList(Ref ref) async {
  final repo = await ref.watch(auditLogRepositoryProvider.future);
  final filter = ref.watch(auditLogFilterNotifierProvider);

  if (filter.action != null) {
    return GetAuditLogsByActionUseCase(repo)(
      filter.action!,
      limit: filter.limit,
    );
  }
  if (filter.table != null) {
    return GetAuditLogsByTableUseCase(repo)(filter.table!, limit: filter.limit);
  }
  return GetAllAuditLogsUseCase(repo)(limit: filter.limit);
}

// ── detail ───────────────────────────────────────────────────
@riverpod
Future<AuditLogEntity> auditLogDetail(Ref ref, int logId) async {
  final repo = await ref.watch(auditLogRepositoryProvider.future);
  return GetAuditLogByIdUseCase(repo)(logId);
}

// ── by user ──────────────────────────────────────────────────
@riverpod
Future<List<AuditLogEntity>> auditLogsByUser(Ref ref, int userId) async {
  final repo = await ref.watch(auditLogRepositoryProvider.future);
  return GetAuditLogsByUserUseCase(repo)(userId);
}
