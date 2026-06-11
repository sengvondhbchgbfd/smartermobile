import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontendmobile/features/hr/salaries/domain/entities/salary_staff_group_entity.dart';
import 'package:frontendmobile/features/hr/salaries/domain/usecases/salaries_usecase.dart';
import 'salary_repository_provider.dart';
part 'salary_group_notifier.g.dart';

@riverpod
class SalaryGroupNotifier extends _$SalaryGroupNotifier {
  late final GetSalariesGroupCase _getGroup;

  /////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////
  @override
  Future<List<SalaryStaffGroupEntity>> build() async {
    final repository = await ref.read(salaryRepositoryProvider.future);
    _getGroup = GetSalariesGroupCase(repository);
    return await _getGroup();
  }

  // =========================================================
  // REFRESH GROUPED DATA
  // =========================================================
  Future<void> fetchGroup() async {
    state = await AsyncValue.guard(() async {
      return await _getGroup();
    });
  }

  // =========================================================
  // OPTIONAL: manual reload (force rebuild)
  // =========================================================
  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _getGroup());
  }
}
