import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import '../../data/datasource/adjust_salaries_remote_datasource_impl.dart';
import '../../data/repositories/salaries_adjust_repository_impl.dart';
import '../../domain/repositories/salary_adjust_repository.dart';

part 'salary_adjustment_repository_provider.g.dart';

@riverpod
Future<SalariesAdjustRepository> salaryAdjustmentRepository(
  SalaryAdjustmentRepositoryRef ref,
) async {
  final dio        = await ref.watch(dioProvider.future);
  final datasource = SalaryAdjustmentRemoteDataSource(dio);
  return SalariesAdjustRepositoryImpl(datasource);
}