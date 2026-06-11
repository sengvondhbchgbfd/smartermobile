import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontendmobile/features/hr/staff/data/datasources/staff_role_remote_datasource.dart';
import 'package:frontendmobile/features/hr/staff/data/datasources/staff_role_remote_datasource_impl.dart';
import 'package:frontendmobile/config/di/dependency_injection.dart';

part 'staff_role_datasource_provider.g.dart';

@riverpod
Future<StaffRoleRemoteDataSource> staffRoleRemoteDataSource(StaffRoleRemoteDataSourceRef ref) async {
   final dioClient = await ref.watch(dioClientProvider.future);
  return StaffRoleRemoteDataSourceImpl(dioClient.dio);
}