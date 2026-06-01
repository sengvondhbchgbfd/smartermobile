import '../entities/leave_entity.dart';
import '../repositories/leave_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Staff use cases
// ─────────────────────────────────────────────────────────────────────────────

class SubmitLeaveUseCase {
  final LeaveRepository _repo;
  const SubmitLeaveUseCase(this._repo);

  Future<LeaveEntity> call({
    required LeaveType leaveType,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
  }) => _repo.createLeave(
    leaveType: leaveType,
    startDate: startDate,
    endDate: endDate,
    reason: reason,
  );
}




class GetMyLeavesUseCase {
  final LeaveRepository _repo;
  const GetMyLeavesUseCase(this._repo);

  Future<List<LeaveEntity>> call({int skip = 0, int limit = 50}) =>
      _repo.getMyLeaves(skip: skip, limit: limit);
}





class CancelLeaveUseCase {
  final LeaveRepository _repo;
  const CancelLeaveUseCase(this._repo);

  Future<LeaveEntity> call(int leaveId) => _repo.cancelLeave(leaveId);
}
