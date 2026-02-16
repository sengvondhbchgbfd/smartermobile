import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/networks/dio_client.dart';
import 'package:frontendmobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frontendmobile/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:frontendmobile/features/auth/domain/usecases/login_usecase.dart';


final dioProvider = Provider((ref) => DioClient().dio);

final authRemoteProvider =
    Provider((ref) =>  AuthRemoteDatasource(ref.read(dioProvider)));

final authRepositoryProvider =
    Provider((ref) => AuthRepositoryImpl(ref.read(authRemoteProvider)));

final loginUseCaseProvider =
    Provider((ref) => LoginUseCase(ref.read(authRepositoryProvider)));

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>(
  (ref) => AuthNotifier(ref.read(loginUseCaseProvider)),
);

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final LoginUseCase loginUseCase;

  AuthNotifier(this.loginUseCase) : super(const AsyncData(null));

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      await loginUseCase(email, password);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
