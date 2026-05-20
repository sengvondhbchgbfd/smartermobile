import 'package:frontendmobile/features/users/domain/entities/department_entity.dart';
import 'package:frontendmobile/features/users/domain/entities/role_entity.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
class UserState {
  final List<UserEntity> users;
  final List<RoleEntity> roles;
  final List<DepartmentEntity> departments;

  final bool isLoading;
  final String? errorMessage;

  const UserState({
    this.users = const [],
    this.roles = const [],
    this.departments = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  UserState copyWith({
    List<UserEntity>? users,
    List<RoleEntity>? roles,
    List<DepartmentEntity>? departments,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserState(
      users: users ?? this.users,
      roles: roles ?? this.roles,
      departments: departments ?? this.departments,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}