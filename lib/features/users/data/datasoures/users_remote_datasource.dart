import 'package:frontendmobile/features/users/domain/entities/department_entity.dart';
import 'package:frontendmobile/features/users/domain/entities/role_entity.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/register_user_params.dart';

abstract class UserDatasource {
  ////////////////////////////////////////////
  // USERS
  ////////////////////////////////////////////
  Future<List<UserEntity>> getUsers(int skip, int limit);
  Future<Map<String, dynamic>> getUserById(int id);
  Future<Map<String, dynamic>> createUser(RegisterUserParams data);
  Future<Map<String, dynamic>> updateUser(int id, Map<String, dynamic> data);
  Future<void> deleteUser(int userId);

  ////////////////////////////////////////////
  // ROLES
  ////////////////////////////////////////////

  Future<List<RoleEntity>> getRoles();
  Future<dynamic> createRole(Map<String, dynamic> data);
  Future<void> deleteRole(int id);

  ////////////////////////////////////////////
  //  DEPARTMENT
  ////////////////////////////////////////////

  Future<List<DepartmentEntity>> getDepartments();
  Future<dynamic> createDepartment(Map<String, dynamic> data);
  Future<void> deleteDepartment(int id);

  ////////////////////////////////////////////
  //
  ////////////////////////////////////////////
}
