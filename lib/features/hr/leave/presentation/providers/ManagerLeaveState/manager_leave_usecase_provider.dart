import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'; // ✅ FIX: removed unused flutter_riverpod import
import 'package:frontendmobile/features/hr/leave/domain/usecases/manager_leave_usecase.dart';
import 'manager_leave_provider.dart';

part 'manager_leave_usecase_provider.g.dart';

@riverpod
Future<GetAllLeavesUseCase> getAllLeavesUseCase(Ref ref) async {
  final repository = await ref.watch(leaveRepositoryProvider.future);
  return GetAllLeavesUseCase(repository);
}

@riverpod
Future<GetPendingLeavesUseCase> getPendingLeavesUseCase(Ref ref) async {
  final repository = await ref.watch(leaveRepositoryProvider.future);
  return GetPendingLeavesUseCase(repository);
}

@riverpod
Future<GetLeaveSummaryUseCase> getLeaveSummaryUseCase(Ref ref) async {
  final repository = await ref.watch(leaveRepositoryProvider.future);
  return GetLeaveSummaryUseCase(repository);
}

@riverpod
Future<GetLeaveByIdUseCase> getLeaveByIdUseCase(Ref ref) async {
  final repository = await ref.watch(leaveRepositoryProvider.future);
  return GetLeaveByIdUseCase(repository);
}

@riverpod
Future<ApproveLeaveUseCase> approveLeaveUseCase(Ref ref) async {
  final repository = await ref.watch(leaveRepositoryProvider.future);
  return ApproveLeaveUseCase(repository);
}

@riverpod
Future<RejectLeaveUseCase> rejectLeaveUseCase(Ref ref) async {
  final repository = await ref.watch(leaveRepositoryProvider.future);
  return RejectLeaveUseCase(repository);
}

@riverpod
Future<DeleteLeaveUseCase> deleteLeaveUseCase(Ref ref) async {
  final repository = await ref.watch(leaveRepositoryProvider.future);
  return DeleteLeaveUseCase(repository);
}
