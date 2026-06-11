<<<<<<< HEAD
=======
import 'dart:math';
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c

import 'package:dio/dio.dart' show DioException;
import 'package:frontendmobile/features/hr/salaries/domain/entities/salaries_entity.dart';
import 'package:frontendmobile/features/hr/salaries/domain/usecases/salaries_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'salary_repository_provider.dart';
part 'salary_notifier.g.dart';

@riverpod
class SalaryNotifier extends _$SalaryNotifier {
  late final GetAllSalariesUseCase _getAll;
  late final GetSalaryByIdUseCase _getById;
  late final GetMySalariesUseCase _getMySalaries;
  late final CreateSalaryUseCase _create;
  late final UpdateSalaryUseCase _updateSalary;
  late final MarkPaidUseCase _markPaid;
  late final DeleteSalaryUseCase _delete;
  late final GetSalarySummaryUseCase _getSummary;

  @override
  Future<List<SalaryEntity>> build() async {
    final repository = await ref.read(salaryRepositoryProvider.future);

    _getAll = GetAllSalariesUseCase(repository);
    _getById = GetSalaryByIdUseCase(repository);
    _getMySalaries = GetMySalariesUseCase(repository);
    _create = CreateSalaryUseCase(repository);
    _updateSalary = UpdateSalaryUseCase(repository);
    _markPaid = MarkPaidUseCase(repository);
    _delete = DeleteSalaryUseCase(repository);
    _getSummary = GetSalarySummaryUseCase(repository);

    return _getAll();
  }

  // ─────────────────────────────
  // READ OPERATIONS (SAFE REFRESH)
  // ─────────────────────────────

  Future<void> fetchAll({int? staffId, String? status}) async {
    state = await AsyncValue.guard(
      () => _getAll(staffId: staffId, status: status),
    );
  }

  Future<void> fetchMySalaries() async {
    state = await AsyncValue.guard(() => _getMySalaries());
  }

  Future<void> fetchByStaff(int staffId) async {
    state = await AsyncValue.guard(() => _getAll(staffId: staffId));
  }

  // ─────────────────────────────
  // WRITE OPERATIONS (OPTIMIZED)
  // ─────────────────────────────

  Future<void> create(SalaryEntity salary) async {
    final result = await AsyncValue.guard(() => _create(salary));

    if (result.hasError) {
      state = AsyncValue.error(result.error!, result.stackTrace!);
      return;
    }

    await fetchAll();
  }

  Future<void> editSalary(int salaryId, SalaryEntity salary) async {
    final result = await AsyncValue.guard(
      () => _updateSalary(salaryId, salary),
    );

    if (result.hasError) {
      state = AsyncValue.error(result.error!, result.stackTrace!);
      return;
    }

    await fetchAll();
  }

  Future<void> markAsPaid(int salaryId, String paymentDate) async {
    final result = await AsyncValue.guard(
      () => _markPaid(salaryId, paymentDate),
    );

    if (result.hasError) {
      state = AsyncValue.error(result.error!, result.stackTrace!);
      return;
    }
    await fetchAll();
  }

  Future<void> delete(int salaryId) async {
    try {
      await _delete(salaryId);
      await fetchAll();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final msg = code == 429
          ? 'Too many requests. Please wait a moment.'
          : e.response?.data?['detail'] ??
                e.response?.data?['error'] ??
                'Failed to delete.';
      throw Exception(msg);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
