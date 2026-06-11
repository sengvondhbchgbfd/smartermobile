import 'package:frontendmobile/features/users/domain/entities/department_entity.dart';
import 'package:frontendmobile/features/users/domain/entities/role_entity.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
<<<<<<< HEAD
=======

>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
class UserState {
  final List<UserEntity> users;
  final List<RoleEntity> roles;
  final List<DepartmentEntity> departments;
<<<<<<< HEAD

=======
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  final bool isLoading;
  final String? errorMessage;

  const UserState({
    this.users = const [],
    this.roles = const [],
    this.departments = const [],
    this.isLoading = false,
    this.errorMessage,
  });

<<<<<<< HEAD
=======
  static const _clear = Object();

>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  UserState copyWith({
    List<UserEntity>? users,
    List<RoleEntity>? roles,
    List<DepartmentEntity>? departments,
    bool? isLoading,
<<<<<<< HEAD
    String? errorMessage,
=======
    Object? errorMessage = _clear, // sentinel
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  }) {
    return UserState(
      users: users ?? this.users,
      roles: roles ?? this.roles,
      departments: departments ?? this.departments,
      isLoading: isLoading ?? this.isLoading,
<<<<<<< HEAD
      errorMessage: errorMessage,
    );
  }
}
=======
      errorMessage: identical(errorMessage, _clear)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
