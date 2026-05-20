import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/users/data/datasoures/users_remote_datasource.dart';
import 'package:frontendmobile/features/users/data/model/department/department_model.dart';
import 'package:frontendmobile/features/users/data/model/roles/users_role_model.dart';
import 'package:frontendmobile/features/users/data/model/users/user_model.dart';
import 'package:frontendmobile/features/users/domain/entities/department_entity.dart';
import 'package:frontendmobile/features/users/domain/entities/role_entity.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
import 'package:frontendmobile/features/users/domain/repositories/users_repository.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/register_user_params.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/update_user_params.dart';

class UsersRepositoryImpl implements UserRepository {
  final UserDatasource datasource;
  UsersRepositoryImpl(this.datasource);
  ////////////////////////////////////////////////////////////
  /// USERS
  ////////////////////////////////////////////////////////////

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers(
    int skip,
    int limit,
  ) async {
    try {
      final result = await datasource.getUsers(skip, limit);
      return Right(result);
    } on ServerEception catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  ////////////////////////////////////////////////////////////
  ///
  ///////////////////////////////////////////////////////////

  @override
  Future<Either<Failure, UserEntity>> getUserById(int id) async {
    try {
      final result = await datasource.getUserById(id);
      final user = UserModel.fromJson(result);
      return Right(user);
    } on ServerEception catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  ////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////

  @override
  Future<Either<Failure, UserEntity>> createUser(
    RegisterUserParams params,
  ) async {
    try {
      final response = await datasource.createUser(params);
      final user = UserModel.fromJson(response);
      return Right(user);
    } on ServerEception catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  ////////////////////////////////////////////////////
  ///
  ///////////////////////////////////////////////////////////

  @override
  Future<Either<Failure, UserEntity>> updateUser(
    UpdateUsersParams params,
  ) async {
    try {
      final response = await datasource.updateUser(
        params.userId,
        params.toJson(),
      );
      final user = UserModel.fromJson(response);
      return Right(user);
    } on ServerEception catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  ////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////

  @override
  Future<Either<Failure, void>> deleteUser(int userId) async {
    try {
      await datasource.deleteUser(userId);
      return const Right(null);
    } on ServerEception catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  ////////////////////////////////////////////////////////////
  /// ROLES
  ///////////////////////////////////////////////////////////

  @override
  Future<Either<Failure, List<RoleEntity>>> getRoles() async {
    try {
      final result = await datasource.getRoles();
      return Right(result);
    } on ServerEception catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  ////////////////////////////////////////////
  ///
  ///////////////////////////////////////////
  @override
  Future<Either<Failure, RoleEntity>> createRole(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await datasource.createRole(data);
      final role = RoleModel.fromJson(result);
      return Right(role);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  /////////////////////////////////////////////
  ///
  ////////////////////////////////////////////
  @override
  Future<Either<Failure, List<DepartmentEntity>>> getDepartments() async {
    try {
      final result = await datasource.getDepartments();
      return Right(result);
    } on ServerEception catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  ////////////////////////////////////////////
  ///
  ///////////////////////////////////////////

  @override
  Future<Either<Failure, void>> deleteRole(int id) async {
    try {
      await datasource.deleteRole(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  ///////////////////////////////////////
  ///
  //////////////////////////////////////
  @override
  Future<Either<Failure, DepartmentEntity>> createDepartment(
    Map<String, dynamic> data,
  ) async {
    try {
      final result = await datasource.createDepartment(data);

      final department = DepartmentModel.fromJson(result);

      return Right(department);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  ////////////////////////////////////
  ///
  //////////////////////////////////
  @override
  Future<Either<Failure, void>> deleteDepartment(int id) async {
    try {
      await datasource.deleteDepartment(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  ////////////////////////////////////
  ///
  //////////////////////////////////
}
