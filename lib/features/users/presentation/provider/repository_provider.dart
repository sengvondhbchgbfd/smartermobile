// import 'package:frontendmobile/features/users/data/repositories/users_repository_impl.dart';
// import 'package:frontendmobile/features/users/domain/repositories/users_repository.dart';
// import 'package:frontendmobile/features/users/presentation/provider/datasource_provider.dart';


// final userRepositoryProvider = FutureProvider<UserRepository>((ref) async {
//   final datasource = await ref.watch(userDatasourceProvider.future);
//   return UsersRepositoryImpl(datasource);
// });


import 'package:frontendmobile/features/users/data/repositories/users_repository_impl.dart';
import 'package:frontendmobile/features/users/domain/repositories/users_repository.dart';
import 'package:frontendmobile/features/users/presentation/provider/datasource_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_provider.g.dart';

@riverpod
Future<UserRepository> userRepository(UserRepositoryRef ref) async {
  final datasource = await ref.watch(userDatasourceProvider.future);
  return UsersRepositoryImpl(datasource);
}