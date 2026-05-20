import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/features/hr/staff/data/datasources/staff_remote_datasource.dart';
import 'package:frontendmobile/features/hr/staff/data/model/staff/staff_model.dart';
import 'package:frontendmobile/features/hr/staff/data/model/staff/update_staff_request.dart';

class StaffRemoteDatasourceImpl implements StaffRemoteDataSource {
  final Dio dio;

  StaffRemoteDatasourceImpl(this.dio);

  @override
  Future<List<StaffModel>> getAll() async {
    final response = await dio.get(ApiEndpoints.staff);
    _checkStatus(response);
    final List<dynamic> data = response.data;
    return data.map((e) => StaffModel.fromJson(e)).toList();
  }

  @override
  Future<StaffModel> getById(int id) async {
    final response = await dio.get(ApiEndpoints.staffById(id));
    _checkStatus(response);
    return StaffModel.fromJson(response.data);
  }

  @override
  Future<StaffModel> getMyProfile() async {
    final response = await dio.get(ApiEndpoints.staffMy);
    _checkStatus(response);
    return StaffModel.fromJson(response.data);
  }

  @override
  Future<List<StaffModel>> getManagers() async {
    final response = await dio.get(ApiEndpoints.staffManagers);
    _checkStatus(response);
    final List<dynamic> data = response.data;
    return data.map((e) => StaffModel.fromJson(e)).toList();
  }

  @override
  Future<List<StaffModel>> getByRole(int staffRoleId) async {
    final response = await dio.get(ApiEndpoints.staffByRole(staffRoleId));
    _checkStatus(response);
    final List<dynamic> data = response.data;
    return data.map((e) => StaffModel.fromJson(e)).toList();
  }

  @override
  Future<List<StaffModel>> getByDepartment(int departmentId) async {
    final response = await dio.get(ApiEndpoints.staffByDept(departmentId));
    _checkStatus(response);
    final List<dynamic> data = response.data;
    return data.map((e) => StaffModel.fromJson(e)).toList();
  }

  @override
  Future<StaffModel> getByUserId(int userId) async {
    final response = await dio.get(ApiEndpoints.staffByUser(userId));
    _checkStatus(response);
    return StaffModel.fromJson(response.data);
  }

  @override
  Future<StaffModel> create(StaffModel staff) async {
    final response = await dio.post(ApiEndpoints.staff, data: staff.toJson());
    _checkStatus(response, expectedStatus: 201);
    return StaffModel.fromJson(response.data);
  }

  @override
  Future<StaffModel> update(
    int id,
    UpdateStaffRequest request, {
    File? avatarFile,
  }) async {
    final formData = FormData.fromMap({
      ...request.toJson(),
      if (avatarFile != null)
        'avatar_file': await MultipartFile.fromFile(
          avatarFile.path,
          filename: avatarFile.path.split('/').last,
        ),
    });
    final response = await dio.patch(
      ApiEndpoints.staffById(id),
      data: formData,
    );
    _checkStatus(response);
    return StaffModel.fromJson(response.data);
  }

  @override
  Future<StaffModel> updateAvatar(int id, File avatarFile) async {
    final formData = FormData.fromMap({
      'avatar_file': await MultipartFile.fromFile(
        avatarFile.path,
        filename: avatarFile.path.split('/').last,
      ),
    });
    final response = await dio.patch(
      ApiEndpoints.staffAvatar(id),
      data: formData,
    );
    _checkStatus(response);
    return StaffModel.fromJson(response.data);
  }

  @override
  Future<void> delete(int id) async {
    final response = await dio.delete(ApiEndpoints.staffById(id));
    _checkStatus(
      response,
      expectedStatus: 200,
    ); // ← backend returns 200 not 204
  }

  void _checkStatus(Response response, {int expectedStatus = 200}) {
    if (response.statusCode != expectedStatus) {
      throw Exception(
        'Staff API error ${response.statusCode}: ${response.data}',
      );
    }
  }
}
