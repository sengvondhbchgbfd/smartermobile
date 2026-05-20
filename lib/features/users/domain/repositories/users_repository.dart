import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/users/domain/entities/department_entity.dart';
import 'package:frontendmobile/features/users/domain/entities/role_entity.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/register_user_params.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/update_user_params.dart';

import '../entities/user_entity.dart';

abstract class UserRepository {
  ///////////////////////////////////////////////////
  // USERS
  //////////////////////////////////////////////////
  Future<Either<Failure, List<UserEntity>>> getUsers(int skip, int limit);
  Future<Either<Failure, UserEntity>> getUserById(int id);

  Future<Either<Failure, UserEntity>> createUser(RegisterUserParams params);

  Future<Either<Failure, UserEntity>> updateUser(UpdateUsersParams params);
  Future<Either<Failure, void>> deleteUser(int userId);
  //////////////////////////////////////////////////
  // ROLES
  //////////////////////////////////////////////////
  Future<Either<Failure, List<RoleEntity>>> getRoles();
  Future<Either<Failure, RoleEntity>> createRole(Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteRole(int id);
  ////////////////////////////////////////////////
  // DEPARTMENTS
  ////////////////////////////////////////////////
  Future<Either<Failure, List<DepartmentEntity>>> getDepartments();
  Future<Either<Failure, DepartmentEntity>> createDepartment(
    Map<String, dynamic> data,
  );
  Future<Either<Failure, void>> deleteDepartment(int id);
}
