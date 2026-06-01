import '../entities/leave_entity.dart';
import '../repositories/leave_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Manager use cases
// ─────────────────────────────────────────────────────────────────────────────

class GetAllLeavesUseCase {
  final LeaveRepository _repo;
  const GetAllLeavesUseCase(this._repo);

  Future<List<LeaveEntity>> call({
    int skip = 0,
    int limit = 50,
    LeaveStatus? status,
    LeaveType? leaveType,
  }) => _repo.getAllLeaves(
    skip: skip,
    limit: limit,
    status: status,
    leaveType: leaveType,
  );
}

class GetPendingLeavesUseCase {
  final LeaveRepository _repo;
  const GetPendingLeavesUseCase(this._repo);

  Future<List<LeaveEntity>> call({int skip = 0, int limit = 50}) =>
      _repo.getPendingLeaves(skip: skip, limit: limit);
}

class GetLeaveSummaryUseCase {
  final LeaveRepository _repo;
  const GetLeaveSummaryUseCase(this._repo);

  Future<Map<String, dynamic>> call() => _repo.getLeaveSummary();
}

class GetLeaveByIdUseCase {
  final LeaveRepository _repo;
  const GetLeaveByIdUseCase(this._repo);

  Future<LeaveEntity> call(int leaveId) => _repo.getLeaveById(leaveId);
}

class ApproveLeaveUseCase {
  final LeaveRepository _repo;
  const ApproveLeaveUseCase(this._repo);

  Future<LeaveEntity> call(int leaveId) => _repo.approveLeave(leaveId);
}

class RejectLeaveUseCase {
  final LeaveRepository _repo;
  const RejectLeaveUseCase(this._repo);

  Future<LeaveEntity> call(int leaveId, {String? reason}) =>
      _repo.rejectLeave(leaveId, reason: reason);
}

class DeleteLeaveUseCase {
  final LeaveRepository _repo;
  const DeleteLeaveUseCase(this._repo);

  Future<Map<String, dynamic>> call(int leaveId) => _repo.deleteLeave(leaveId);
}
