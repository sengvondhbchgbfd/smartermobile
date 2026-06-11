import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';

class StaffLeaveState {
  final List<LeaveEntity> leaves;
  final bool isLoading;
  final String? error;

  const StaffLeaveState({
    this.leaves = const [],
    this.isLoading = false,
    this.error,
  });

  StaffLeaveState copyWith({
    List<LeaveEntity>? leaves,
    bool? isLoading,
    String? error,
  }) => StaffLeaveState(
    leaves: leaves ?? this.leaves,
    isLoading: isLoading ?? this.isLoading,
    error: error,
  );
}

class ManagerLeaveState {
  final List<LeaveEntity> leaves;
  final LeaveEntity? selected;
  final Map<String, dynamic>? summary;
  final bool isLoading;
  final String? error;

  const ManagerLeaveState({
    this.leaves = const [],
    this.selected,
    this.summary,
    this.isLoading = false,
    this.error,
  });

  ManagerLeaveState copyWith({
    List<LeaveEntity>? leaves,
    LeaveEntity? selected,
    Map<String, dynamic>? summary,
    bool? isLoading,
    String? error,
  }) => ManagerLeaveState(
    leaves: leaves ?? this.leaves,
    selected: selected ?? this.selected,
    summary: summary ?? this.summary,
    isLoading: isLoading ?? this.isLoading,
    error: error,
  );
}
