import '../model/leave_model.dart';
import '../../domain/entities/leave_entity.dart';

abstract class LeaveRemoteDataSource {
  // ── Staff ──────────────────────────────────────────────────────────────────
  Future<LeaveModel> createLeave({
    required LeaveType leaveType,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
  });
  Future<List<LeaveModel>> getMyLeaves({int skip = 0, int limit = 50});
  Future<LeaveModel> cancelLeave(int leaveId);

  // ── Manager ────────────────────────────────────────────────────────────────
  Future<List<LeaveModel>> getAllLeaves({
    int skip = 0,
    int limit = 50,
    LeaveStatus? status,
    LeaveType? leaveType,
  });
  Future<List<LeaveModel>> getPendingLeaves({int skip = 0, int limit = 50});
  Future<Map<String, dynamic>> getLeaveSummary();
  Future<LeaveModel> getLeaveById(int leaveId);
  Future<LeaveModel> approveLeave(int leaveId);
  Future<LeaveModel> rejectLeave(int leaveId, {String? reason});
  Future<Map<String, dynamic>> deleteLeave(int leaveId);
}
