import 'package:frontendmobile/features/hr/salaries/data/datasources/salaries_remote_datasourec_impl.dart';
import 'package:frontendmobile/features/hr/salaries/data/repositories/salaries_repository_impl.dart';
import 'package:frontendmobile/features/hr/salaries/domain/repositories/salaries_repository.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'salary_repository_provider.g.dart';
@riverpod
Future<SalaryRepository> salaryRepository(SalaryRepositoryRef ref) async {
  final dio = await ref.read(dioProvider.future);
  final datasource = SalaryRemoteDatasourceImpl(dio);
  return SalaryRepositoryImpl(datasource);
}
