// import 'package:frontendmobile/config/di/dependency_injection.dart';
// import 'package:frontendmobile/features/users/data/datasoures/users_remote_datasource.dart';
// import 'package:frontendmobile/features/users/data/datasoures/users_remote_datasource_impl.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// final userDatasourceProvider = FutureProvider<UserDatasource>((ref) async {
//   final dioClient = await ref.watch(dioClientProvider.future);
//   return UserDatasourceImpl(dioClient.dio);
// });

import 'package:frontendmobile/config/di/dependency_injection.dart';
import 'package:frontendmobile/features/users/data/datasoures/users_remote_datasource.dart';
import 'package:frontendmobile/features/users/data/datasoures/users_remote_datasource_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'datasource_provider.g.dart';

@riverpod
Future<UserDatasource> userDatasource(UserDatasourceRef ref) async {
  final dioClient = await ref.watch(dioClientProvider.future);
  return UserDatasourceImpl(dioClient.dio);
}
