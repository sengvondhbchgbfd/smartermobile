import 'package:frontendmobile/config/di/dependency_injection.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
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

  @override
  Future<UserState> build() async {
    final repo = await ref.watch(userRepositoryProvider.future);
    getUsersUseCase = GetUsersUseCase(repo);
    updateUsersUsecase = UpdateUsersUsecase(repo);
    deleteUsersUsecase = DeleteUserUsecase(repo);
    createUsersUsecase = CreateUsersUsecase(repo);
    getRolesUseCase = GetRolesUseCase(repo);
    createRoleUsecase = CreateRoleUsecae(repo);
    deleteRoleUsecase = DeleteRoleUsecase(repo);
    getDepartmentsUseCase = GetDepartmentsUseCase(repo);
    createDepartmentUsecase = CreateDepartmentUsecase(repo);
    deleteDepartmentUsecase = DeleteDepartmentUsecase(repo);
    return _loadAll();
  }

  Future<UserState> _loadAll() async {
    final usersResult = await getUsersUseCase(
      GetUsersParams(skip: 0, limit: 10),
    );
    final rolesResult = await getRolesUseCase();
    final departmentsResult = await getDepartmentsUseCase();
    return UserState(
      users: usersResult.getOrElse(() => []),
      roles: rolesResult.getOrElse(() => []),
      departments: departmentsResult.getOrElse(() => []),
    );
  }

  Future<void> loadAll() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadAll());
  }

  // ── CREATE USER ──
  Future<void> createUser(RegisterUserParams params) async {
    final current = state.value;
    if (current == null) return;
    final oldUsers = current.users;
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
    state = AsyncData(
      current.copyWith(users: old.where((e) => e.id != userId).toList()),
    );
    final result = await deleteUsersUsecase(userId);
    result.fold((f) => state = AsyncData(current.copyWith(users: old)), (_) {});
  }

  // ── UPDATE USER ──
  Future<void> updateUser(UpdateUsersParams params) async {
    final current = state.value;
    if (current == null) return;
    final old = current.users;

    // optimistic update
    final optimistic = old.map<UserEntity>((e) {
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
    final result = await createRoleUsecase(
      CreateRoleParams(roleName: roleName, companyId: int.parse(companyId!)),
    );
    result.fold(
      (f) => state = AsyncData(
        current.copyWith(isLoading: false, errorMessage: f.message),
      ),
      (role) => state = AsyncData(
        current.copyWith(roles: [...current.roles, role], errorMessage: null),
      ),
    );
  }

  Future<void> deleteRole(int roleId) async {
    final current = state.value;
    if (current == null) return;
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
      (f) => state = AsyncData(
        current.copyWith(isLoading: false, errorMessage: f.message),
      ),
      (dept) => state = AsyncData(
        current.copyWith(
          departments: [...current.departments, dept],
          errorMessage: null,
        ),
      ),
    );
  }

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
    );
  }
}
