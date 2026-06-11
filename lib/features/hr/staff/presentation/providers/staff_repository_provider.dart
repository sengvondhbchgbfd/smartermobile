import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_datasource_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontendmobile/features/hr/staff/data/repositories/staff_repository_impl.dart';
import 'package:frontendmobile/features/hr/staff/domain/repositories/staff_repository.dart';
part 'staff_repository_provider.g.dart';
@riverpod
Future<StaffRepository> staffRepository(StaffRepositoryRef ref) async {
  final dataSource = await ref.watch(staffRemoteDataSourceProvider.future);
  return StaffRepositoryImpl(dataSource);
}