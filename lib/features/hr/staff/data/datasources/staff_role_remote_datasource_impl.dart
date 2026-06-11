import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/features/hr/staff/data/datasources/staff_role_remote_datasource.dart';
import 'package:frontendmobile/features/hr/staff/data/model/staff_role/staff_role_model.dart';

class StaffRoleRemoteDataSourceImpl implements StaffRoleRemoteDataSource {
  final Dio dio;

  StaffRoleRemoteDataSourceImpl(this.dio);

  @override
  Future<List<StaffRoleModel>> getAll() async {
    final response = await dio.get(ApiEndpoints.staffRoles);
    _checkStatus(response);
    final List<dynamic> data = response.data;
    return data.map((e) => StaffRoleModel.fromJson(e)).toList();
  }

  @override
  Future<StaffRoleModel> getById(int id) async {
    final response = await dio.get(ApiEndpoints.staffRoleById(id));
    _checkStatus(response);
    return StaffRoleModel.fromJson(response.data);
  }

  @override
  Future<StaffRoleModel> create(StaffRoleModel role) async {
    final response = await dio.post(
      ApiEndpoints.staffRoles,
      data: role.toJson(),
    );
    _checkStatus(response, expectedStatus: 201);
    return StaffRoleModel.fromJson(response.data);
  }

  @override
  Future<StaffRoleModel> update(int id, StaffRoleModel role) async {
    final response = await dio.patch(
      ApiEndpoints.staffRoleById(id),
      data: role.toUpdateJson(),
    );
    _checkStatus(response);
    return StaffRoleModel.fromJson(response.data);
  }

  @override
  Future<void> delete(int id) async {
    final response = await dio.delete(ApiEndpoints.staffRoleById(id));
    _checkStatus(response, expectedStatus: 204);
  }

  void _checkStatus(Response response, {int expectedStatus = 200}) {
    if (response.statusCode != expectedStatus) {
      throw Exception(
        'StaffRole API error ${response.statusCode}: ${response.data}',
      );
    }
  }
}
