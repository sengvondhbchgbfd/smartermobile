import '../../domain/entities/leave_entity.dart';
import '../../domain/repositories/leave_repository.dart';
import '../datasource/leave_remote_datasource.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemoteDataSource _remote;
  const LeaveRepositoryImpl(this._remote);
  ///////////////////////////////////////////////////////////////////////////////
  // ── Staff ──────────────────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////
  @override
  Future<LeaveEntity> createLeave({
    required LeaveType leaveType,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
  }) async {
    final model = await _remote.createLeave(
      leaveType: leaveType,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
    );
    return model.toEntity();
  }
  //////////////////////////////////////////////////////////////////////////////
  /// get leaves of the current user (staff)
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<List<LeaveEntity>> getMyLeaves({int skip = 0, int limit = 50}) async {
    final models = await _remote.getMyLeaves(skip: skip, limit: limit);
    return models.map((m) => m.toEntity()).toList();
  }
  //////////////////////////////////////////////////////////////////////////////
  /// cancel a leave request (staff)
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<LeaveEntity> cancelLeave(int leaveId) async {
    final model = await _remote.cancelLeave(leaveId);
    return model.toEntity();
  }

  // ── Manager ────────────────────────────────────────────────────────────────

  @override
  Future<List<LeaveEntity>> getAllLeaves({
    int skip = 0,
    int limit = 50,
    LeaveStatus? status,
    LeaveType? leaveType,
  }) async {
    final models = await _remote.getAllLeaves(
      skip: skip,
      limit: limit,
      status: status,
      leaveType: leaveType,
    );
    return models.map((m) => m.toEntity()).toList();
  }
  //////////////////////////////////////////////////////////////////////////////
  /// get pending leaves (manager)
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<List<LeaveEntity>> getPendingLeaves({
    int skip = 0,
    int limit = 50,
  }) async {
    final models = await _remote.getPendingLeaves(skip: skip, limit: limit);
    return models.map((m) => m.toEntity()).toList();
  }

  //////////////////////////////////////////////////////////////////////////////
  /// get leave summary (manager)
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<Map<String, dynamic>> getLeaveSummary() => _remote.getLeaveSummary();

  //////////////////////////////////////////////////////////////////////////////
  /// get leave by id (manager)
  //////////////////////////////////////////////////////////////////////////////
  @override
  Future<LeaveEntity> getLeaveById(int leaveId) async {
    final model = await _remote.getLeaveById(leaveId);
    return model.toEntity();
  }
  //////////////////////////////////////////////////////////////////////////////
  /// approve a leave (manager)
  /////////////////////////////////////////////////////////////////////////////////

  @override
  Future<LeaveEntity> approveLeave(int leaveId) async {
    final model = await _remote.approveLeave(leaveId);
    return model.toEntity();
  }
  //////////////////////////////////////////////////////////////////////////////
  /// reject a leave (manager)
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<LeaveEntity> rejectLeave(int leaveId, {String? reason}) async {
    final model = await _remote.rejectLeave(leaveId, reason: reason);
    return model.toEntity();
  }
  //////////////////////////////////////////////////////////////////////////////
  /// delete a leave (manager)
  /// NOTE: this is a soft delete, the backend will just mark it as deleted
  //////////////////////////////////////////////////////////////////////////////

  @override
  Future<Map<String, dynamic>> deleteLeave(int leaveId) =>
      _remote.deleteLeave(leaveId);
}
