import 'package:frontendmobile/config/di/dependency_injection.dart';
<<<<<<< HEAD
=======
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
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

<<<<<<< HEAD
  ////////////////////////////////////////////////////////////
  /// Builder
  ///////////////////////////////////////////////////////////

  @override
  Future<UserState> build() async {
    final repo = await ref.watch(userRepositoryProvider.future);
    ////////////////////////////
    ///  USERS
    ////////////////////////////
=======
  @override
  Future<UserState> build() async {
    final repo = await ref.watch(userRepositoryProvider.future);
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
    getUsersUseCase = GetUsersUseCase(repo);
    updateUsersUsecase = UpdateUsersUsecase(repo);
    deleteUsersUsecase = DeleteUserUsecase(repo);
    createUsersUsecase = CreateUsersUsecase(repo);
<<<<<<< HEAD
    ////////////////////////////
    /// ROLES
    ///////////////////////////
    getRolesUseCase = GetRolesUseCase(repo);
    createRoleUsecase = CreateRoleUsecae(repo);
    deleteRoleUsecase = DeleteRoleUsecase(repo);
    //////////////////////////
    /// DEPARTMENT
    //////////////////////////
=======
    getRolesUseCase = GetRolesUseCase(repo);
    createRoleUsecase = CreateRoleUsecae(repo);
    deleteRoleUsecase = DeleteRoleUsecase(repo);
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
    getDepartmentsUseCase = GetDepartmentsUseCase(repo);
    createDepartmentUsecase = CreateDepartmentUsecase(repo);
    deleteDepartmentUsecase = DeleteDepartmentUsecase(repo);
    return _loadAll();
  }

<<<<<<< HEAD
  // ===============================================================
  // LOAD ALL DATA
  // ===============================================================
=======
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  Future<UserState> _loadAll() async {
    final usersResult = await getUsersUseCase(
      GetUsersParams(skip: 0, limit: 10),
    );
<<<<<<< HEAD
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
=======
    final rolesResult = await getRolesUseCase();
    final departmentsResult = await getDepartmentsUseCase();
    return UserState(
      users: usersResult.getOrElse(() => []),
      roles: rolesResult.getOrElse(() => []),
      departments: departmentsResult.getOrElse(() => []),
    );
  }

>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  Future<void> loadAll() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadAll());
  }

<<<<<<< HEAD
  //=================================================================
  // Create Users
  //=================================================================
=======
  // ── CREATE USER ──
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  Future<void> createUser(RegisterUserParams params) async {
    final current = state.value;
    if (current == null) return;
    final oldUsers = current.users;
<<<<<<< HEAD
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

=======
    state = AsyncData(current.copyWith(isLoading: true, errorMessage: null));
    final result = await createUsersUsecase(params);
    result.fold(
      (failure) => state = AsyncData(
        current.copyWith(
          users: oldUsers,
          isLoading: false,
          errorMessage: failure.message,
        ),
      ),
      (user) => state = AsyncData(
        current.copyWith(
          users: [...oldUsers, user],
          isLoading: false,
          errorMessage: null,
        ),
      ),
    );
  }

  // ── DELETE USER ──
  Future<void> deleteUser(int userId) async {
    final current = state.value;
    if (current == null) return;
    final old = current.users;
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
    state = AsyncData(
      current.copyWith(users: old.where((e) => e.id != userId).toList()),
    );
    final result = await deleteUsersUsecase(userId);
    result.fold((f) => state = AsyncData(current.copyWith(users: old)), (_) {});
  }

<<<<<<< HEAD
  // ===============================================================
  // UPDATE USER
  // ==============================================================

=======
  // ── UPDATE USER ──
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  Future<void> updateUser(UpdateUsersParams params) async {
    final current = state.value;
    if (current == null) return;
    final old = current.users;

<<<<<<< HEAD
    final updated = old.map((e) {
=======
    // optimistic update
    final optimistic = old.map<UserEntity>((e) {
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
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

<<<<<<< HEAD
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

=======
    state = AsyncData(current.copyWith(users: optimistic));

    final result = await updateUsersUsecase(params);
    result.fold(
      (f) => state = AsyncData(
        current.copyWith(users: old, errorMessage: f.message),
      ),
      (updatedUser) {
        final current2 = state.valueOrNull;
        if (current2 == null) return;
        state = AsyncData(
          current2.copyWith(
            users: current2.users
                .map<UserEntity>(
                  (e) => e.id == updatedUser.id ? updatedUser : e,
                )
                .toList(),
          ),
        );
      },
    );
  }

  // ── PATCH STAFF (called from StaffNotifier) ──
  void patchStaff(StaffEntity staff) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        users: current.users.map((u) {
          if (u.id == staff.userId) return u.copyWith(staff: staff);
          return u;
        }).toList(),
      ),
    );
  }

  // ── REMOVE STAFF (called from StaffNotifier) ──
  void removeStaff(int userId) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        users: current.users.map((u) {
          if (u.id == userId) return u.copyWith(staff: null);
          return u;
        }).toList(),
      ),
    );
  }

  // ── ROLE ──
  Future<void> createRole(String roleName) async {
    final current = state.value;
    if (current == null) return;
    final companyId = await ref.read(secureStorageProvider).getCompanyId();
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
    final result = await createRoleUsecase(
      CreateRoleParams(roleName: roleName, companyId: int.parse(companyId!)),
    );
    result.fold(
<<<<<<< HEAD
      (f) => state = AsyncError(f.message, StackTrace.current),
      (role) =>
          state = AsyncData(current.copyWith(roles: [...current.roles, role])),
    );
  }
  /////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////
=======
      (f) => state = AsyncData(
        current.copyWith(isLoading: false, errorMessage: f.message),
      ),
      (role) => state = AsyncData(
        current.copyWith(roles: [...current.roles, role], errorMessage: null),
      ),
    );
  }
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c

  Future<void> deleteRole(int roleId) async {
    final current = state.value;
    if (current == null) return;
<<<<<<< HEAD

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

=======
    final old = current.roles;
    final result = await deleteRoleUsecase(roleId);
    result.fold(
      (f) => state = AsyncData(current.copyWith(errorMessage: f.message)),
      (_) {
        final updatedUsers = current.users.map((u) {
          if (u.roleId == roleId)
            return u.copyWith(roleId: null, roleName: null);
          return u;
        }).toList();
        state = AsyncData(
          current.copyWith(
            roles: old.where((e) => e.id != roleId).toList(),
            users: updatedUsers,
            errorMessage: null,
          ),
        );
      },
    );
  }

  // ── DEPARTMENT ──
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  Future<void> createDepartment({
    required String departmentName,
    required int? managerId,
  }) async {
    final current = state.value;
    if (current == null) return;
<<<<<<< HEAD

    final companyId = await ref.read(secureStorageProvider).getCompanyId();

=======
    final companyId = await ref.read(secureStorageProvider).getCompanyId();
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
    final result = await createDepartmentUsecase(
      CreateDepartmentParams(
        departmentName: departmentName,
        managerId: managerId,
        companyId: int.parse(companyId!),
      ),
    );
<<<<<<< HEAD

    result.fold(
      (f) => state = AsyncError(f.message, StackTrace.current),
      (dept) => state = AsyncData(
        current.copyWith(departments: [...current.departments, dept]),
=======
    result.fold(
      (f) => state = AsyncData(
        current.copyWith(isLoading: false, errorMessage: f.message),
      ),
      (dept) => state = AsyncData(
        current.copyWith(
          departments: [...current.departments, dept],
          errorMessage: null,
        ),
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
      ),
    );
  }

<<<<<<< HEAD
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
=======
  Future<void> deleteDepartment(int id) async {
    final current = state.value;
    if (current == null) return;
    final old = current.departments;
    final result = await deleteDepartmentUsecase(id);
    result.fold(
      (f) => state = AsyncData(current.copyWith(errorMessage: f.message)),
      (_) {
        final updatedUsers = current.users.map((u) {
          if (u.departmentId == id) {
            return u.copyWith(departmentId: null, departmentName: null);
          }
          return u;
        }).toList();
        state = AsyncData(
          current.copyWith(
            departments: old.where((e) => e.departmentId != id).toList(),
            users: updatedUsers,
            errorMessage: null,
          ),
        );
      },
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
    );
  }
}
