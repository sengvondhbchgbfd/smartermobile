import 'package:frontendmobile/config/di/dependency_injection.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/create_users_usecase.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/get_user_usecase.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/delete_user.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/get_users_params.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/register_user_params.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/update_user_params.dart';
import 'package:frontendmobile/features/users/domain/usecase/roles/get_roles_usecase.dart';
import 'package:frontendmobile/features/users/domain/usecase/roles/create_role_usecase.dart';
import 'package:frontendmobile/features/users/domain/usecase/roles/delete_role_usecase.dart';
import 'package:frontendmobile/features/users/domain/usecase/departmentt/get_department_usecase.dart';
import 'package:frontendmobile/features/users/domain/usecase/departmentt/create_department_usecase.dart';
import 'package:frontendmobile/features/users/domain/usecase/departmentt/delete_department_usecase.dart';
import 'package:frontendmobile/features/users/presentation/provider/repository_provider.dart';
import 'package:frontendmobile/features/users/presentation/provider/users_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_notifier.g.dart';

@riverpod
class UserNotifier extends _$UserNotifier {
  late GetUsersUseCase getUsersUseCase;
  late UpdateUsersUsecase updateUsersUsecase;
  late CreateUsersUsecase createUsersUsecase;
  late DeleteUserUsecase deleteUsersUsecase;

  late GetRolesUseCase getRolesUseCase;
  late CreateRoleUsecae createRoleUsecase;
  late DeleteRoleUsecase deleteRoleUsecase;

  late GetDepartmentsUseCase getDepartmentsUseCase;
  late CreateDepartmentUsecase createDepartmentUsecase;
  late DeleteDepartmentUsecase deleteDepartmentUsecase;

  ////////////////////////////////////////////////////////////
  /// Builder
  ///////////////////////////////////////////////////////////

  @override
  Future<UserState> build() async {
    final repo = await ref.watch(userRepositoryProvider.future);
    ////////////////////////////
    ///  USERS
    ////////////////////////////
    getUsersUseCase = GetUsersUseCase(repo);
    updateUsersUsecase = UpdateUsersUsecase(repo);
    deleteUsersUsecase = DeleteUserUsecase(repo);
    createUsersUsecase = CreateUsersUsecase(repo);
    ////////////////////////////
    /// ROLES
    ///////////////////////////
    getRolesUseCase = GetRolesUseCase(repo);
    createRoleUsecase = CreateRoleUsecae(repo);
    deleteRoleUsecase = DeleteRoleUsecase(repo);
    //////////////////////////
    /// DEPARTMENT
    //////////////////////////
    getDepartmentsUseCase = GetDepartmentsUseCase(repo);
    createDepartmentUsecase = CreateDepartmentUsecase(repo);
    deleteDepartmentUsecase = DeleteDepartmentUsecase(repo);
    return _loadAll();
  }

  // ===============================================================
  // LOAD ALL DATA
  // ===============================================================
  Future<UserState> _loadAll() async {
    final usersResult = await getUsersUseCase(
      GetUsersParams(skip: 0, limit: 10),
    );
    print('👤 usersResult: $usersResult'); // ← add this
    final rolesResult = await getRolesUseCase();
    final departmentsResult = await getDepartmentsUseCase();
    final users = usersResult.getOrElse(() => []);
    print('👤 users length: ${users.length}'); // ← and this
    final roles = rolesResult.getOrElse(() => []);
    final departments = departmentsResult.getOrElse(() => []);
    return UserState(users: users, roles: roles, departments: departments);
  }

  // =================================================================
  // RELOAD
  // =================================================================
  Future<void> loadAll() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadAll());
  }

  //=================================================================
  // Create Users
  //=================================================================
  Future<void> createUser(RegisterUserParams params) async {
    final current = state.value;
    if (current == null) return;
    final oldUsers = current.users;
    state = AsyncValue.data(
      current.copyWith(isLoading: true, errorMessage: null),
    );
    final result = await createUsersUsecase(params);
    result.fold(
      (failure) {
        state = AsyncValue.data(
          current.copyWith(
            users: oldUsers,
            isLoading: false,
            errorMessage: failure.message,
          ),
        );
      },
      (user) {
        final List<UserEntity> updatedUsers = [...oldUsers, user];
        state = AsyncValue.data(
          current.copyWith(
            users: updatedUsers,
            isLoading: false,
            errorMessage: null,
          ),
        );
      },
    );
  }
  // ==================================================================
  // DELETE USER
  // ==================================================================

  Future<void> deleteUser(int userId) async {
    final current = state.value;
    if (current == null) return;

    final old = current.users;

    state = AsyncData(
      current.copyWith(users: old.where((e) => e.id != userId).toList()),
    );
    final result = await deleteUsersUsecase(userId);
    result.fold((f) => state = AsyncData(current.copyWith(users: old)), (_) {});
  }

  // ===============================================================
  // UPDATE USER
  // ==============================================================

  Future<void> updateUser(UpdateUsersParams params) async {
    final current = state.value;
    if (current == null) return;
    final old = current.users;

    final updated = old.map((e) {
      if (e.id != params.userId) return e;
      return e.copyWith(
        username: params.username,
        fullName: params.fullName,
        roleId: params.roleId,
        departmentId: params.departmentId,
        status: params.status,
        updatedAt: DateTime.now(),
      );
    }).toList();

    state = AsyncData(current.copyWith(users: updated));

    final result = await updateUsersUsecase(params);
    result.fold(
      (f) => state = AsyncData(current.copyWith(users: old)),
      (_) => loadAll(),
    );
  }

  // ================================================================
  // ROLE
  // ================================================================
  Future<void> createRole(String roleName) async {
    final current = state.value;
    if (current == null) return;

    final companyId = await ref.read(secureStorageProvider).getCompanyId();

    final result = await createRoleUsecase(
      CreateRoleParams(roleName: roleName, companyId: int.parse(companyId!)),
    );
    result.fold(
      (f) => state = AsyncError(f.message, StackTrace.current),
      (role) =>
          state = AsyncData(current.copyWith(roles: [...current.roles, role])),
    );
  }
  /////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////

  Future<void> deleteRole(int roleId) async {
    final current = state.value;
    if (current == null) return;

    final old = current.roles;

    state = AsyncData(
      current.copyWith(roles: old.where((e) => e.id != roleId).toList()),
    );

    final result = await deleteRoleUsecase(roleId);

    result.fold((f) => state = AsyncData(current.copyWith(roles: old)), (_) {});
  }

  // ==============================================================
  // DEPARTMENT
  // ==============================================================

  Future<void> createDepartment({
    required String departmentName,
    required int? managerId,
  }) async {
    final current = state.value;
    if (current == null) return;

    final companyId = await ref.read(secureStorageProvider).getCompanyId();

    final result = await createDepartmentUsecase(
      CreateDepartmentParams(
        departmentName: departmentName,
        managerId: managerId,
        companyId: int.parse(companyId!),
      ),
    );

    result.fold(
      (f) => state = AsyncError(f.message, StackTrace.current),
      (dept) => state = AsyncData(
        current.copyWith(departments: [...current.departments, dept]),
      ),
    );
  }

  /////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////

  Future<void> deleteDepartment(int id) async {
    final current = state.value;
    if (current == null) return;

    final old = current.departments;

    state = AsyncData(
      current.copyWith(
        departments: old.where((e) => e.departmentId != id).toList(),
      ),
    );

    final result = await deleteDepartmentUsecase(id);

    result.fold(
      (f) => state = AsyncData(current.copyWith(departments: old)),
      (_) {},
    );
  }
}
