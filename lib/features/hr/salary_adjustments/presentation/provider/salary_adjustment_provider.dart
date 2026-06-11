import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontendmobile/features/hr/salary_adjustments/data/model/salaries_adjust_model.dart';
import '../../domain/entities/salary_adjustment_entity.dart';
import '../../domain/usecase/get_adjustment_usecase.dart';
import '../../domain/usecase/create_adjustment_salary.dart';
import '../../domain/usecase/delete_adjustment_usecase.dart';
import 'salary_adjustment_repository_provider.dart';
part 'salary_adjustment_provider.g.dart';

@riverpod
class AdjustmentNotifier extends _$AdjustmentNotifier {
  late GetAdjustmentsUsecase _getAdjustments;
  late CreateAdjustmentUsecase _createAdjustment;
  late DeleteAdjustmentUsecase _deleteAdjustment;

  @override
  Future<List<SalaryAdjustmentEntity>> build(int salaryId) async {
    final repository = await ref.watch(
      salaryAdjustmentRepositoryProvider.future,
    );
    _getAdjustments = GetAdjustmentsUsecase(repository);
    _createAdjustment = CreateAdjustmentUsecase(repository);
    _deleteAdjustment = DeleteAdjustmentUsecase(repository);
    return _getAdjustments(salaryId);
  }

  Future<void> create(SalaryAdjustmentCreateDto dto) async {
    final result = await AsyncValue.guard(() => _createAdjustment(dto));

    if (result.hasError) {
      state = AsyncValue.error(result.error!, result.stackTrace!);
      return;
    }
    ref.invalidateSelf();
    await future;
  }

  Future<void> delete(int adjustmentId) async {
    final result = await AsyncValue.guard(
      () => _deleteAdjustment(adjustmentId),
    );

    if (result.hasError) {
      state = AsyncValue.error(result.error!, result.stackTrace!);
      return;
    }
    ref.invalidateSelf();
    await future;
  }
}
