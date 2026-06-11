import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/leave/presentation/providers/ManagerLeaveState/manager_leave_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontendmobile/features/hr/leave/domain/usecases/staff_leave_usecase.dart';

part 'staff_leave_provider.g.dart';

@riverpod
Future<SubmitLeaveUseCase> submitLeaveUseCase(Ref ref) async {
  final repository = await ref.watch(leaveRepositoryProvider.future);
  return SubmitLeaveUseCase(repository);
}

@riverpod
Future<GetMyLeavesUseCase> getMyLeavesUseCase(Ref ref) async {
  final repository = await ref.watch(leaveRepositoryProvider.future);
  return GetMyLeavesUseCase(repository);
}

@riverpod
Future<CancelLeaveUseCase> cancelLeaveUseCase(Ref ref) async {
  final repository = await ref.watch(leaveRepositoryProvider.future);
  return CancelLeaveUseCase(repository);
}
