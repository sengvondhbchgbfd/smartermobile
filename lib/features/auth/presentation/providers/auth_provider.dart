import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/errors/api_error_handler.dart';
import 'package:frontendmobile/core/storage/secure_storage_service.dart';
import 'package:frontendmobile/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:frontendmobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:frontendmobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:frontendmobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:frontendmobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:frontendmobile/features/auth/domain/usecases/register_setup_usecase.dart';
import 'package:frontendmobile/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart'; // ← import core

// ── Auth providers ───────────────────────────────────────────

final authRemoteProvider = FutureProvider((ref) async {
  final dio = await ref.watch(dioProvider.future);
  return AuthRemoteDatasourceImpl(dio);
});

final authRepositoryProvider = FutureProvider<AuthRepository>((ref) async {
  final remote = await ref.watch(authRemoteProvider.future);
  return AuthRepositoryImpl(remote);
});

// ── UseCase providers ────────────────────────────────────────
// final validateTokenUseCaseProvider = FutureProvider<ValidateTokenUseCase>((
//   ref,
// ) async {
//   final repo = await ref.watch(authRepositoryProvider.future);
//   return ValidateTokenUseCase(repo);
// });

final loginUseCaseProvider = FutureProvider<LoginUseCase>((ref) async {
  return LoginUseCase(await ref.watch(authRepositoryProvider.future));
});

final logoutUseCaseProvider = FutureProvider<LogoutUseCase>((ref) async {
  return LogoutUseCase(await ref.watch(authRepositoryProvider.future));
});

final registerUseCaseProvider = FutureProvider<RegisterUseCase>((ref) async {
  return RegisterUseCase(await ref.watch(authRepositoryProvider.future));
});

// ── RegisterUser UseCase provider ────────────────────────────
final registerUserUseCaseProvider = FutureProvider<RegisterUserUsecase>((
  ref,
) async {
  return RegisterUserUsecase(await ref.watch(authRepositoryProvider.future));
});

// ── RegisterUser notifier ─────────────────────────────────────

class RegisterUserNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  RegisterUserNotifier(this._ref) : super(const AsyncData(null));
  Future<void> registerUser({
    required String username,
    required String password,
    required String fullName,
    required int roleId,
    required int departmentId,
  }) async {
    state = const AsyncLoading();
    try {
      final useCase = await _ref.read(registerUserUseCaseProvider.future);
      await useCase(
        username: username,
        password: password,
        fullName: fullName,
        roleId: roleId,
        departmentId: departmentId,
      );
      state = const AsyncData(null);
    } on DioException catch (e) {
      state = AsyncError(ApiErrorHandler.getMessage(e), StackTrace.current);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
}

final registerUserProvider =
    StateNotifierProvider<RegisterUserNotifier, AsyncValue<void>>(
      (ref) => RegisterUserNotifier(ref),
    );

/////////////////////////////////////////////////////////////////////////
// ── Register notifier ────────────────────────────────────────
/////////////////////////////////////////////////////////////////////////

class RegisterNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  RegisterNotifier(this._ref) : super(const AsyncData(null));

  Future<void> register({
    required String companyName,
    required String companyCode,
    required String username,
    required String password,
    required String fullName,
    required String timezone,
    required String currency,
  }) async {
    state = const AsyncLoading();
    try {
      final useCase = await _ref.read(registerUseCaseProvider.future);
      await useCase(
        companyName: companyName,
        companyCode: companyCode,
        username: username,
        password: password,
        fullName: fullName,
        timezone: timezone,
        currency: currency,
      );
      state = const AsyncData(null);
    } on DioException catch (e) {
      state = AsyncError(ApiErrorHandler.getMessage(e), StackTrace.current);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

///////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////

final registerProvider =
    StateNotifierProvider<RegisterNotifier, AsyncValue<void>>(
      (ref) => RegisterNotifier(ref),
    );

//////////////////////////////////////////////////////////////////////////
// ── Auth notifier ────────────────────────────────────────────
/////////////////////////////////////////////////////////////////////////

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  final SecureStorageService _storage;
  AuthNotifier(this._ref, this._storage) : super(const AsyncData(null));

  ///////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    try {
      final loginUseCase = await _ref.read(loginUseCaseProvider.future);
      final user = await loginUseCase(username, password);
      await _storage.saveTokens(
        accessToken: user.accessToken,
        refreshToken: user.refreshToken,
      );
      await _storage.saveUserInfo(
        userId: user.user.userId.toString(),
        companyId: user.user.companyId.toString(),
      );
      state = const AsyncData(null);
    } on DioException catch (e) {
      state = AsyncError(ApiErrorHandler.getMessage(e), StackTrace.current);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  ///////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      final logoutUseCase = await _ref.read(logoutUseCaseProvider.future);
      await logoutUseCase();
    } catch (_) {
    } finally {
      await _storage.clearAuth();
      state = const AsyncData(null);
    }
  }
}

///////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>(
  (ref) => AuthNotifier(ref, ref.read(secureStorageProvider)),
);
