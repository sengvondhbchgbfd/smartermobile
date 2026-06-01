import 'package:dio/dio.dart';
import 'package:frontendmobile/core/errors/api_error_handler.dart';
import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';
import 'package:frontendmobile/features/hr/leave/presentation/providers/ManagerLeaveState/manager_leave_usecase_provider.dart';
import 'package:frontendmobile/features/hr/leave/presentation/providers/leave_state.dart';
import 'package:frontendmobile/features/hr/leave/presentation/providers/staff_leave_provider.dart'; // ✅ staff usecases
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontendmobile/features/hr/leave/domain/usecases/manager_leave_usecase.dart';
import 'package:frontendmobile/features/hr/leave/domain/usecases/staff_leave_usecase.dart';

part 'leave_notifier.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Staff Notifier
// ─────────────────────────────────────────────────────────────────────────────

@riverpod
class StaffLeave extends _$StaffLeave {
  late final SubmitLeaveUseCase _submitLeave;
  late final GetMyLeavesUseCase _getMyLeaves;
  late final CancelLeaveUseCase _cancelLeave;

  @override
  Future<StaffLeaveState> build() async {
    _submitLeave = await ref.watch(submitLeaveUseCaseProvider.future);
    _getMyLeaves = await ref.watch(getMyLeavesUseCaseProvider.future);
    _cancelLeave = await ref.watch(cancelLeaveUseCaseProvider.future);
    final leaves = await _getMyLeaves(skip: 0, limit: 50);
    return StaffLeaveState(leaves: leaves);
  }

  Future<void> _run(Future<void> Function() fn) async {
    final current = state.value ?? const StaffLeaveState();
    state = AsyncData(current.copyWith(isLoading: true, error: null));
    try {
      await fn();
    } on DioException catch (e) {
      final message = ApiErrorHandler.getMessage(e);
      final s = state.value ?? const StaffLeaveState();
      state = AsyncData(s.copyWith(isLoading: false, error: message));
    }
  }

  Future<void> submitLeave({
    required LeaveType leaveType,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
  }) async {
    try {
      state = const AsyncLoading();

      final result = await _submitLeave(
        leaveType: leaveType,
        startDate: startDate,
        endDate: endDate,
        reason: reason,
      );
      state = AsyncData(
        state.value!.copyWith(
          leaves: [result, ...state.value!.leaves],
          error: null,
          isLoading: false,
        ),
      );
    } on DioException catch (e) {
      final message = ApiErrorHandler.getMessage(e);
      state = AsyncData(
        state.value!.copyWith(error: message, isLoading: false),
      );
    }
  }

  Future<void> fetchMyLeaves({int skip = 0, int limit = 50}) => _run(() async {
    final list = await _getMyLeaves(skip: skip, limit: limit);
    final current = state.value ?? const StaffLeaveState();
    state = AsyncData(current.copyWith(leaves: list, isLoading: false));
  });

  Future<void> cancelLeave(int leaveId) => _run(() async {
    final updated = await _cancelLeave(leaveId);
    state = AsyncData(
      state.value!.copyWith(
        leaves: [
          for (final l in state.value!.leaves)
            if (l.leaveId == updated.leaveId) updated else l,
        ],
        isLoading: false,
      ),
    );
  });

  void clearError() => state = AsyncData(state.value!.copyWith(error: null));
}

// ─────────────────────────────────────────────────────────────────────────────
// Manager Notifier
// ─────────────────────────────────────────────────────────────────────────────

@riverpod
class ManagerLeave extends _$ManagerLeave {
  late final GetAllLeavesUseCase _getAllLeaves;
  late final GetPendingLeavesUseCase _getPendingLeaves;
  late final GetLeaveSummaryUseCase _getLeaveSummary;
  late final GetLeaveByIdUseCase _getLeaveById;
  late final ApproveLeaveUseCase _approveLeave;
  late final RejectLeaveUseCase _rejectLeave;
  late final DeleteLeaveUseCase _deleteLeave;

  @override
  Future<ManagerLeaveState> build() async {
    _getAllLeaves = await ref.watch(getAllLeavesUseCaseProvider.future);
    _getPendingLeaves = await ref.watch(getPendingLeavesUseCaseProvider.future);
    _getLeaveSummary = await ref.watch(getLeaveSummaryUseCaseProvider.future);
    _getLeaveById = await ref.watch(getLeaveByIdUseCaseProvider.future);
    _approveLeave = await ref.watch(approveLeaveUseCaseProvider.future);
    _rejectLeave = await ref.watch(rejectLeaveUseCaseProvider.future);
    _deleteLeave = await ref.watch(deleteLeaveUseCaseProvider.future);
    return const ManagerLeaveState();
  }

  Future<void> _run(Future<void> Function() fn) async {
    final current = state.value ?? const ManagerLeaveState();
    state = AsyncData(current.copyWith(isLoading: true, error: null));
    try {
      await fn();
    } on DioException catch (e) {
      final message = ApiErrorHandler.getMessage(e);
      final s = state.value ?? const ManagerLeaveState();
      state = AsyncData(s.copyWith(isLoading: false, error: message));
    }
  }

  Future<void> fetchAllLeaves({
    int skip = 0,
    int limit = 50,
    LeaveStatus? status,
    LeaveType? leaveType,
  }) => _run(() async {
    final list = await _getAllLeaves(
      skip: skip,
      limit: limit,
      status: status,
      leaveType: leaveType,
    );
    state = AsyncData(state.value!.copyWith(leaves: list, isLoading: false));
  });

  Future<void> fetchPendingLeaves({int skip = 0, int limit = 50}) => _run(
    () async {
      final list = await _getPendingLeaves(skip: skip, limit: limit);
      state = AsyncData(state.value!.copyWith(leaves: list, isLoading: false));
    },
  );

  Future<void> fetchLeaveSummary() => _run(() async {
    final summary = await _getLeaveSummary();
    state = AsyncData(
      state.value!.copyWith(summary: summary, isLoading: false),
    );
  });

  Future<void> fetchLeaveById(int leaveId) => _run(() async {
    final leave = await _getLeaveById(leaveId);
    state = AsyncData(state.value!.copyWith(selected: leave, isLoading: false));
  });

  Future<void> approveLeave(int leaveId) => _run(() async {
    final updated = await _approveLeave(leaveId);
    state = AsyncData(
      state.value!.copyWith(
        leaves: _replaceInList(updated),
        selected: updated,
        isLoading: false,
      ),
    );
  });

  Future<void> rejectLeave(int leaveId, {String? reason}) => _run(() async {
    final updated = await _rejectLeave(leaveId, reason: reason);
    state = AsyncData(
      state.value!.copyWith(
        leaves: _replaceInList(updated),
        selected: updated,
        isLoading: false,
      ),
    );
  });

  Future<void> deleteLeave(int leaveId) => _run(() async {
    await _deleteLeave(leaveId);
    state = AsyncData(
      state.value!.copyWith(
        leaves: state.value!.leaves.where((l) => l.leaveId != leaveId).toList(),
        selected: state.value!.selected?.leaveId == leaveId
            ? null
            : state.value!.selected,
        isLoading: false,
      ),
    );
  });

  void clearError() => state = AsyncData(state.value!.copyWith(error: null));
  void clearSelected() =>
      state = AsyncData(state.value!.copyWith(selected: null));
  List<LeaveEntity> _replaceInList(LeaveEntity updated) => [
    for (final l in state.value!.leaves)
      if (l.leaveId == updated.leaveId) updated else l,
  ];
}
