import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/errors/api_error_handler.dart';
import 'package:frontendmobile/core/storage/secure_storage_service.dart';
import 'package:frontendmobile/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:frontendmobile/features/auth/data/models/auth_user_model.dart';
import 'package:frontendmobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:frontendmobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:frontendmobile/features/auth/domain/usecases/auth/change_password_usecase.dart';
import 'package:frontendmobile/features/auth/domain/usecases/auth/login_usecase.dart';
import 'package:frontendmobile/features/auth/domain/usecases/auth/logout_usecase.dart';
import 'package:frontendmobile/features/auth/domain/usecases/auth/refresh_token_usecase.dart';
import 'package:frontendmobile/features/auth/domain/usecases/auth/reset_password_usecase.dart';
import 'package:frontendmobile/features/auth/domain/usecases/auth/setup/register_setup_usecase.dart';
import 'package:frontendmobile/features/auth/domain/usecases/user/activate_user_usecase.dart';
import 'package:frontendmobile/features/auth/domain/usecases/user/deactivate_user_usecase.dart';
import 'package:frontendmobile/features/auth/domain/usecases/user/get_user_usecase.dart';
import 'package:frontendmobile/features/auth/domain/usecases/user/get_users_usecase.dart';
import 'package:frontendmobile/features/auth/domain/usecases/user/register_user_usecase.dart';
import 'package:frontendmobile/features/auth/domain/usecases/user/update_user_usecase.dart';
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

/////////////////////////////////////////////////////////////////
// approve get update users
////////////////////////////////////////////////////////////////

final getUserUsecaseProvider = FutureProvider<GetUsersUsecase>((ref) async {
  return GetUsersUsecase(await ref.watch(authRepositoryProvider.future));
});

final getUsersUsecaseProvider = FutureProvider<GetUserUsecase>((ref) async {
  return GetUserUsecase(await ref.watch(authRepositoryProvider.future));
});

final updateUserUseCaseProvider = FutureProvider<UpdateUserUseCase>((
  ref,
) async {
  return UpdateUserUseCase(await ref.watch(authRepositoryProvider.future));
});

/////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////
final changePasswordUseCaseProvider = FutureProvider<ChangePasswordUseCase>((
  ref,
) async {
  return ChangePasswordUseCase(await ref.watch(authRepositoryProvider.future));
});

final resetPasswordUseCaseProvider = FutureProvider<ResetPasswordUseCase>((
  ref,
) async {
  return ResetPasswordUseCase(await ref.watch(authRepositoryProvider.future));
});

final refreshTokenUseCaseProvider = FutureProvider<RefreshTokenUseCase>((
  ref,
) async {
  return RefreshTokenUseCase(await ref.watch(authRepositoryProvider.future));
});

///////////////////////////////////////////////////////////////////////
///
/////////////////////////////////////////////////////////////////////

final activateUserUseCaseProvider = FutureProvider<ActivateUserUseCase>((
  ref,
) async {
  return ActivateUserUseCase(await ref.watch(authRepositoryProvider.future));
});

final deactivateUserUseCaseProvider = FutureProvider<DeactivateUserUseCase>((
  ref,
) async {
  return DeactivateUserUseCase(await ref.watch(authRepositoryProvider.future));
});
//////////////////////////////////////////////////////////////////////
///
/////////////////////////////////////////////////////////////////////

class UserNotifier extends StateNotifier<AsyncValue<List<UserInfo>>> {
  final Ref _ref;
  UserNotifier(this._ref) : super(const AsyncLoading());
  //////////////////////////////////////////////////////////////
  // ACTIVATE USER
  //////////////////////////////////////////////////////////////
  Future<void> activateUser(int userId) async {
    try {
      final useCase = await _ref.read(activateUserUseCaseProvider.future);

      await useCase(userId);

      await getUsers();
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
  // ============================================================
  // PROFILE PROVIDER
  // ============================================================

  final profileProvider = FutureProvider<UserInfo?>((ref) async {
    final storage = ref.read(secureStorageProvider);

    return await storage.getUserInfo();
  });

  //////////////////////////////////////////////////////////////
  // DEACTIVATE USER
  //////////////////////////////////////////////////////////////

  Future<void> deactivateUser(int userId) async {
    try {
      final useCase = await _ref.read(deactivateUserUseCaseProvider.future);

      await useCase(userId);

      await getUsers();
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  /////////////////////////////////////////////////////////
  // GET USERS
  ///////////////////////////////////////////////////////
  Future<void> getUsers() async {
    try {
      final useCase = await _ref.read(getUsersUsecaseProvider.future);
      final users = await useCase();
      state = AsyncData(users);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  /////////////////////////////////////////////////////
  // UPDATE USER
  /////////////////////////////////////////////////////

  Future<void> updateUser({
    required int userId,
    String? fullName,
    int? roleId,
    int? departmentId,
    String? status,
  }) async {
    try {
      final userCase = await _ref.read(updateUserUseCaseProvider.future);
      await userCase(
        userId: userId,
        fullName: fullName,
        roleId: roleId,
        departmentId: departmentId,
        status: status,
      );

      await getUsers();
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}
////////////////////////////////////////////////////
///
////////////////////////////////////////////////////

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<List<UserInfo>>>(
      (ref) => UserNotifier(ref),
    );

// ============================================================
// CURRENT USER PROVIDER
// ============================================================

final currentUserProvider = StateProvider<UserInfo?>((ref) => null);

//////////////////////////////////////////////////////////
///
/////////////////////////////////////////////////////////
///
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

  // Future<void> login(String username, String password) async {
  //   state = const AsyncLoading();
  //   try {
  //     final loginUseCase = await _ref.read(loginUseCaseProvider.future);
  //     final user = await loginUseCase(username, password);
  //     await _storage.saveTokens(
  //       accessToken: user.accessToken,
  //       refreshToken: user.refreshToken,
  //     );
  //     await _storage.saveUserInfo(
  //       userId: user.user.userId.toString(),
  //       companyId: user.user.companyId.toString(),
  //     );
  //     state = const AsyncData(null);
  //   } on DioException catch (e) {
  //     state = AsyncError(ApiErrorHandler.getMessage(e), StackTrace.current);
  //   } catch (e) {
  //     state = AsyncError(e.toString(), StackTrace.current);
  //   }
  // }
  // ============================================================
  // AUTH NOTIFIER LOGIN
  // ============================================================

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();

    try {
      final loginUseCase = await _ref.read(loginUseCaseProvider.future);

      final result = await loginUseCase(username, password);

      // SAVE TOKEN
      await _storage.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );

      // SAVE USER
      await _storage.saveUserInfo(result.user);

      // SET CURRENT USER
      _ref.read(currentUserProvider.notifier).state = result.user;

      state = const AsyncData(null);
    } catch (e, s) {
      state = AsyncError(e, s);
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

  /////////////////////////////////////////////////////////////////
  ///
  ///////////////////////////////////////////////////////////////

  Future<void> refreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();

      if (refreshToken == null) {
        throw Exception('No refresh token');
      }

      final useCase = await _ref.read(refreshTokenUseCaseProvider.future);

      final result = await useCase(refreshToken);

      await _storage.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
    } catch (e) {
      await logout();
    }
  }
  ////////////////////////////////////////////////////////////
  // CHANGE PASSWORD
  ////////////////////////////////////////////////////////////

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading();

    try {
      final useCase = await _ref.read(changePasswordUseCaseProvider.future);

      await useCase(oldPassword: oldPassword, newPassword: newPassword);

      state = const AsyncData(null);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
  ////////////////////////////////////////////////////////////
  // RESET PASSWORD
  ////////////////////////////////////////////////////////////

  Future<void> resetPassword({
    required int userId,
    required String newPassword,
  }) async {
    state = const AsyncLoading();

    try {
      final useCase = await _ref.read(resetPasswordUseCaseProvider.future);

      await useCase(userId: userId, newPassword: newPassword);

      state = const AsyncData(null);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}

///////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////
///
//////////////////////////////////////////////////////////////////////
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>(
  (ref) => AuthNotifier(ref, ref.read(secureStorageProvider)),
);
