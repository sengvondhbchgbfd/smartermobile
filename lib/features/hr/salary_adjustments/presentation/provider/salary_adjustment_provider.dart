import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasource/adjust_salaries_remote_datasource_impl.dart';
import '../../data/repositories/salaries_adjust_repository_impl.dart';
import '../../domain/entities/salary_adjustment_entity.dart';
import '../../domain/usecase/create_adjustment_salary.dart';
import '../../domain/usecase/delete_adjustment_usecase.dart';
import '../../domain/usecase/get_adjustment_usecase.dart';

part 'salary_adjustment_provider.g.dart';

// ── State ─────────────────────────────────────────────────────────────────────

class SalaryAdjustmentState {
  final List<SalaryAdjustmentEntity> adjustments;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;
  final String? successMessage;

  const SalaryAdjustmentState({
    this.adjustments = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.successMessage,
  });

  SalaryAdjustmentState copyWith({
    List<SalaryAdjustmentEntity>? adjustments,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    String? successMessage,
  }) => SalaryAdjustmentState(
    adjustments: adjustments ?? this.adjustments,
    isLoading: isLoading ?? this.isLoading,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    error: error ?? this.error,
    successMessage: successMessage ?? this.successMessage,
  );
}

// ── Dependency providers ──────────────────────────────────────────────────────

@riverpod
Dio dio(DioRef ref) => Dio();

@riverpod
SalaryAdjustmentRemoteDataSource salaryAdjustmentRemoteDataSource(
  SalaryAdjustmentRemoteDataSourceRef ref,
) => SalaryAdjustmentRemoteDataSource(ref.watch(dioProvider));

@riverpod
SalaryAdjustmentRepositoryImpl salaryAdjustmentRepository(
  SalaryAdjustmentRepositoryRef ref,
) => SalaryAdjustmentRepositoryImpl(
  ref.watch(salaryAdjustmentRemoteDataSourceProvider),
);

@riverpod
GetAdjustmentsUseCase getAdjustmentsUseCase(GetAdjustmentsUseCaseRef ref) =>
    GetAdjustmentsUseCase(ref.watch(salaryAdjustmentRepositoryProvider));

@riverpod
CreateAdjustmentUseCase createAdjustmentUseCase(
  CreateAdjustmentUseCaseRef ref,
) => CreateAdjustmentUseCase(ref.watch(salaryAdjustmentRepositoryProvider));

@riverpod
DeleteAdjustmentUseCase deleteAdjustmentUseCase(
  DeleteAdjustmentUseCaseRef ref,
) => DeleteAdjustmentUseCase(ref.watch(salaryAdjustmentRepositoryProvider));

// ── Notifier ──────────────────────────────────────────────────────────────────

@riverpod
class SalaryAdjustmentNotifier extends _$SalaryAdjustmentNotifier {
  @override
  SalaryAdjustmentState build() => const SalaryAdjustmentState();

  // ── Load ───────────────────────────────────────────────────────────────────

  Future<void> loadAdjustments({required int salaryId}) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    final result = await ref
        .read(getAdjustmentsUseCaseProvider)
        .call(salaryId: salaryId);

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (adjustments) =>
          state = state.copyWith(isLoading: false, adjustments: adjustments),
    );
  }

  // ── Create ─────────────────────────────────────────────────────────────────

  Future<void> createAdjustment({
    required int salaryId,
    required AdjustmentType adjustmentType,
    required double amount,
    String? reason,
  }) async {
    state = state.copyWith(
      isSubmitting: true,
      error: null,
      successMessage: null,
    );

    final result = await ref
        .read(createAdjustmentUseCaseProvider)
        .call(
          salaryId: salaryId,
          adjustmentType: adjustmentType,
          amount: amount,
          reason: reason,
        );

    result.fold(
      (failure) =>
          state = state.copyWith(isSubmitting: false, error: failure.message),
      (newAdjustment) => state = state.copyWith(
        isSubmitting: false,
        adjustments: [newAdjustment, ...state.adjustments],
        successMessage: 'Adjustment created successfully',
      ),
    );
  }

  // ── Delete ─────────────────────────────────────────────────────────────────

  Future<void> deleteAdjustment({required int adjustmentId}) async {
    state = state.copyWith(error: null, successMessage: null);

    final result = await ref
        .read(deleteAdjustmentUseCaseProvider)
        .call(adjustmentId: adjustmentId);

    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (message) => state = state.copyWith(
        adjustments: state.adjustments
            .where((a) => a.adjustmentId != adjustmentId)
            .toList(),
        successMessage: message,
      ),
    );
  }

  void clearMessages() =>
      state = state.copyWith(error: null, successMessage: null);
}
