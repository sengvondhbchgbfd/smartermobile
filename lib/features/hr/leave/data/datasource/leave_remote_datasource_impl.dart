import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import '../model/leave_model.dart';
import '../../domain/entities/leave_entity.dart';
import 'leave_remote_datasource.dart';

class LeaveRemoteDataSourceImpl implements LeaveRemoteDataSource {
  final Dio _dio;
  LeaveRemoteDataSourceImpl(this._dio);
  ////////////////////////////////////////////////////////////////////////////
  // ── helpers ───────────────────────────────────────────────────────────────
  ////////////////////////////////////////////////////////////////////////////

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  Map<String, dynamic> _params(Map<String, dynamic> raw) =>
      Map.fromEntries(raw.entries.where((e) => e.value != null));

  LeaveModel _toModel(dynamic data) =>
      LeaveModel.fromJson(data as Map<String, dynamic>);

  List<LeaveModel> _toModelList(dynamic data) => (data as List<dynamic>)
      .map((e) => LeaveModel.fromJson(e as Map<String, dynamic>))
      .toList();
  ////////////////////////////////////////////////////////////////////////////
  // ── Staff ─────────────────────────────────────────────────────────────────
  ////////////////////////////////////////////////////////////////////////////

  @override
  Future<LeaveModel> createLeave({
    required LeaveType leaveType,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.leaveRequests,
      data: {
        'leave_type': leaveType.name,
        'start_date': _fmtDate(startDate),
        'end_date': _fmtDate(endDate),
        if (reason != null) 'reason': reason,
      },
    );
    return _toModel(res.data);
  }

  /////////////////////////////////////////////////////////////////////
  /// get leaves of the current user (staff)
  /////////////////////////////////////////////////////////////////////

  @override
  Future<List<LeaveModel>> getMyLeaves({int skip = 0, int limit = 50}) async {
    final res = await _dio.get<List<dynamic>>(
      ApiEndpoints.leaveRequestsMy,
      queryParameters: _params({
        'skip': skip,
        'limit': limit,
      }), // ✅ no await needed
    );
    return _toModelList(res.data);
  }

  /////////////////////////////////////////////////////////////////////
  /// cancel a leave (staff)
  /////////////////////////////////////////////////////////////////////

  @override
  Future<LeaveModel> cancelLeave(int leaveId) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '${ApiEndpoints.leaveRequests}/$leaveId/cancel',
    );
    return _toModel(res.data);
  }
  ////////////////////////////////////////////////////////////////////////////
  // ── Manager ───────────────────────────────────────────────────────────────
  ////////////////////////////////////////////////////////////////////////////

  @override
  Future<List<LeaveModel>> getAllLeaves({
    int skip = 0,
    int limit = 50,
    LeaveStatus? status,
    LeaveType? leaveType,
  }) async {
    final res = await _dio.get<List<dynamic>>(
      ApiEndpoints.leaveRequests,
      queryParameters: _params({
        'skip': skip,
        'limit': limit,
        'leave_status': status?.name,
        'leave_type': leaveType?.name,
      }),
    );
    return _toModelList(res.data);
  }

  ////////////////////////////////////////////////////////////////////
  /// get pending leaves (manager)
  ////////////////////////////////////////////////////////////////////

  @override
  Future<List<LeaveModel>> getPendingLeaves({
    int skip = 0,
    int limit = 50,
  }) async {
    final res = await _dio.get<List<dynamic>>(
      ApiEndpoints.leaveRequestsPending,
      queryParameters: _params({
        'skip': skip,
        'limit': limit,
      }), // ✅ no await needed
    );
    return _toModelList(res.data);
  }

  ////////////////////////////////////////////////////////////////////
  /// get leave summary (manager)
  ////////////////////////////////////////////////////////////////////

  @override
  Future<Map<String, dynamic>> getLeaveSummary() async {
    final res = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.leaveRequestsSummary,
    );
    return res.data!;
  }

  ////////////////////////////////////////////////////////////////////
  /// get leave by id (manager)
  ////////////////////////////////////////////////////////////////////

  @override
  Future<LeaveModel> getLeaveById(int leaveId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '${ApiEndpoints.leaveRequests}/$leaveId',
    );
    return _toModel(res.data);
  }

  ////////////////////////////////////////////////////////////////////
  /// get approve leave (manager)
  ////////////////////////////////////////////////////////////////////

  @override
  Future<LeaveModel> approveLeave(int leaveId) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '${ApiEndpoints.leaveRequests}/$leaveId/approve',
    );
    return _toModel(res.data);
  }
  ////////////////////////////////////////////////////////////////////
  /// get reject leave (manager)
  ////////////////////////////////////////////////////////////////////

  @override
  Future<LeaveModel> rejectLeave(int leaveId, {String? reason}) async {
    final res = await _dio.patch<Map<String, dynamic>>(
      '${ApiEndpoints.leaveRequests}/$leaveId/reject',
      data: {if (reason != null) 'reason': reason},
    );
    return _toModel(res.data);
  }
  ////////////////////////////////////////////////////////////////////
  /// delete leave (manager)
  /////////////////////////////////////////////////////////////////////

  @override
  Future<Map<String, dynamic>> deleteLeave(int leaveId) async {
    final res = await _dio.delete<Map<String, dynamic>>(
      '${ApiEndpoints.leaveRequests}/$leaveId',
    );
    return res.data!;
  }
}
