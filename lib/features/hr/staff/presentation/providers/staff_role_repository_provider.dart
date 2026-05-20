import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontendmobile/features/hr/staff/data/repositories/staff_role_repository_impl.dart';
import 'package:frontendmobile/features/hr/staff/domain/repositories/staff_role_repository.dart';
import 'staff_role_datasource_provider.dart';
part 'staff_role_repository_provider.g.dart';
@riverpod
Future<StaffRoleRepository> staffRoleRepository(StaffRoleRepositoryRef ref) async {
  final dataSource = await ref.watch(staffRoleRemoteDataSourceProvider.future);
  return StaffRoleRepositoryImpl(dataSource);
}