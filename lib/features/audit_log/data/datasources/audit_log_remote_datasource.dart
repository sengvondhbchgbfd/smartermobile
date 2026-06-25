import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/core/network/dio_client.dart';
import '../models/audit_log_model.dart';

abstract class AuditLogRemoteDataSource {
  Future<List<AuditLogModel>> getAllLogs({int limit = 50});
  Future<List<AuditLogModel>> getLogsByUser(int userId, {int limit = 50});
  Future<List<AuditLogModel>> getLogsByTable(
    String tableName, {
    int limit = 50,
  });
  Future<List<AuditLogModel>> getLogsByAction(String action, {int limit = 50});
  Future<AuditLogModel> getLogById(int logId);
}

class AuditLogRemoteDataSourceImpl implements AuditLogRemoteDataSource {
  final DioClient _dioClient;
  static const _base = ApiEndpoints.auditLogs;
  AuditLogRemoteDataSourceImpl(this._dioClient);
  Dio get _dio => _dioClient.dio;

  @override
  Future<List<AuditLogModel>> getAllLogs({int limit = 50}) async {
    final res = await _dio.get('$_base/', queryParameters: {'limit': limit});
    return (res.data as List).map((e) => AuditLogModel.fromJson(e)).toList();
  }

  @override
  Future<List<AuditLogModel>> getLogsByUser(
    int userId, {
    int limit = 50,
  }) async {
    final res = await _dio.get(
      '$_base/user/$userId',
      queryParameters: {'limit': limit},
    );
    return (res.data as List).map((e) => AuditLogModel.fromJson(e)).toList();
  }

  @override
  Future<List<AuditLogModel>> getLogsByTable(
    String tableName, {
    int limit = 50,
  }) async {
    final res = await _dio.get(
      '$_base/table/$tableName',
      queryParameters: {'limit': limit},
    );
    return (res.data as List).map((e) => AuditLogModel.fromJson(e)).toList();
  }

  @override
  Future<List<AuditLogModel>> getLogsByAction(
    String action, {
    int limit = 50,
  }) async {
    final res = await _dio.get(
      '$_base/action/$action',
      queryParameters: {'limit': limit},
    );
    return (res.data as List).map((e) => AuditLogModel.fromJson(e)).toList();
  }

  @override
  Future<AuditLogModel> getLogById(int logId) async {
    final res = await _dio.get('$_base/$logId');
    return AuditLogModel.fromJson(res.data as Map<String, dynamic>);
  }
}
