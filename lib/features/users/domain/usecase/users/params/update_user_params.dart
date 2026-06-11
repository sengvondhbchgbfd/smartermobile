import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
<<<<<<< HEAD
=======
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
import 'package:frontendmobile/features/users/domain/repositories/users_repository.dart';

class UpdateUsersParams {
  final int userId;
  final String username;
  final String fullName;
  final int roleId;
  final int? departmentId;
  final String status;

  const UpdateUsersParams({
    required this.userId,
    required this.username,
    required this.fullName,
    required this.roleId,
    this.departmentId,
    required this.status,
  });

<<<<<<< HEAD
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "full_name": fullName,
      "role_id": roleId,
      "department_id": departmentId,
      "status": status,
    };
  }
=======
  Map<String, dynamic> toJson() => {
    "username": username,
    "full_name": fullName,
    "role_id": roleId,
    "department_id": departmentId,
    "status": status,
  };
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
}

class UpdateUsersUsecase {
  final UserRepository repo;
  UpdateUsersUsecase(this.repo);

<<<<<<< HEAD
  Future<Either<Failure, void>> call(UpdateUsersParams params) async {
    return await repo.updateUser(params);
  }
}
=======
  Future<Either<Failure, UserEntity>> call(UpdateUsersParams params) async {
    return await repo.updateUser(params);
  }
}
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
