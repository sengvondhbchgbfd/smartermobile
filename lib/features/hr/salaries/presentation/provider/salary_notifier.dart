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
    ref.keepAlive();

    final repository = await ref.read(salaryRepositoryProvider.future);

    _getAll       = GetAllSalariesUseCase(repository);
    _getById      = GetSalaryByIdUseCase(repository);
    _getMySalaries = GetMySalariesUseCase(repository);
    _create       = CreateSalaryUseCase(repository);
    _updateSalary = UpdateSalaryUseCase(repository);
    _markPaid     = MarkPaidUseCase(repository);
    _delete       = DeleteSalaryUseCase(repository);
    _getSummary   = GetSalarySummaryUseCase(repository);

    return await _getAll();
  }

  // ── Fetch all (manual refresh) ──


  Future<void> fetchAll({int? staffId, String? status}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _getAll(staffId: staffId, status: status),
    );
  }




  // ── Fetch my salaries ──
  Future<void> fetchMySalaries() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _getMySalaries());
  }
  // ── Fetch by staff ──
  Future<void> fetchByStaff(int staffId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _getAll(staffId: staffId),
    );
  }

  // ── Create ──
  Future<void> create(SalaryEntity salary) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(() => _create(salary));
    await fetchAll();
  }

  // ── Update ──
  Future<void> editSalary(int salaryId, SalaryEntity salary) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(() => _updateSalary(salaryId, salary));
    await fetchAll();
  }
  


  // ── Mark as paid ──
  Future<void> markAsPaid(int salaryId, String paymentDate) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(() => _markPaid(salaryId, paymentDate));
    await fetchAll();
  }

  // ── Delete ──
  Future<void> delete(int salaryId) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(() => _delete(salaryId));
    await fetchAll();
  }
}