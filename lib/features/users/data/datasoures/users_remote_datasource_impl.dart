import 'package:dio/dio.dart';
import 'package:frontendmobile/features/users/data/datasoures/users_remote_datasource.dart';
import 'package:frontendmobile/features/users/data/model/department/department_model.dart';
import 'package:frontendmobile/features/users/data/model/roles/users_role_model.dart';
import 'package:frontendmobile/features/users/data/model/users/user_model.dart';
import 'package:frontendmobile/features/users/domain/entities/department_entity.dart';
import 'package:frontendmobile/features/users/domain/entities/role_entity.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/register_user_params.dart';

class UserDatasourceImpl implements UserDatasource {
  final Dio dio;
  UserDatasourceImpl(this.dio);

  // ================================================================
  // USERS
  // ================================================================

  @override
  Future<List<UserEntity>> getUsers(int skip, int limit) async {
    final res = await dio.get(
      '/users/',
      queryParameters: {'skip': skip, 'limit': limit},
    );
    final List items = res.data['items'] as List;
    return items
        .map((e) {
          try {
            return UserModel.fromJson(e as Map<String, dynamic>);
          } catch (e, s) {
            print('❌ ERROR: $e');
            print('❌ STACK: $s');
          }
        })
        .whereType<UserModel>()
        .toList();
  }
  //=============================================================
  //
  //=============================================================

  @override
  Future<Map<String, dynamic>> getUserById(int id) async {
    final res = await dio.get('/users/$id/');
    return res.data;
  }

  //=============================================================
  //
  //=============================================================

  @override
  Future<Map<String, dynamic>> createUser(RegisterUserParams model) async {
    final res = await dio.post('/users/', data: model.toJson());
    return res.data;
  }

  //=============================================================
  //
  //=============================================================

  @override
  Future<Map<String, dynamic>> updateUser(
    int id,
    Map<String, dynamic> data,
  ) async {
    final res = await dio.patch('/users/$id', data: data);
    return res.data;
  }

  //=============================================================
  //
  //=============================================================

  @override
  Future<void> deleteUser(int userId) async {
    await dio.delete('/users/$userId');
  }

  // ================================================================
  // ROLES
  // ================================================================

  @override
  Future<List<RoleEntity>> getRoles() async {
    final res = await dio.get('/roles/');
    final List data = res.data as List;
    return data
        .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
        .cast<RoleEntity>()
        .toList();
  }

  //=============================================================
  //
  //=============================================================

  @override
  Future<Map<String, dynamic>> createRole(Map<String, dynamic> data) async {
    final res = await dio.post('/roles/', data: data);
    return res.data;
  }

  //=============================================================
  //
  //=============================================================

  @override
  Future<void> deleteRole(int id) async {
    await dio.delete('/roles/$id');
  }

  // ================================================================
  // DEPARTMENTS
  // ================================================================

  @override
  Future<List<DepartmentEntity>> getDepartments() async {
    final res = await dio.get('/departments/');
    final List data = res.data as List;
    return data
        .map((e) => DepartmentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  //=============================================================
  //
  //=============================================================

  @override
  Future<Map<String, dynamic>> createDepartment(
    Map<String, dynamic> data,
  ) async {
    final res = await dio.post('/departments/', data: data);
    return res.data;
  }

  @override
  Future<void> deleteDepartment(int id) async {
    await dio.delete('/departments/$id');
  }
}
