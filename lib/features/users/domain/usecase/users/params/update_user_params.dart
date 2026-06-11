import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
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

  Map<String, dynamic> toJson() => {
    "username": username,
    "full_name": fullName,
    "role_id": roleId,
    "department_id": departmentId,
    "status": status,
  };
}

class UpdateUsersUsecase {
  final UserRepository repo;
  UpdateUsersUsecase(this.repo);

  Future<Either<Failure, UserEntity>> call(UpdateUsersParams params) async {
    return await repo.updateUser(params);
  }
}