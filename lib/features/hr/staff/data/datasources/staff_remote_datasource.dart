import 'dart:io';

import 'package:frontendmobile/features/hr/staff/data/model/staff/staff_model.dart';

import 'package:frontendmobile/features/hr/staff/data/model/staff/update_staff_request.dart';

abstract class StaffRemoteDataSource {
  Future<List<StaffModel>> getAll();
  Future<StaffModel> getById(int id);
  Future<StaffModel> getMyProfile();
  Future<List<StaffModel>> getManagers();
  Future<List<StaffModel>> getByRole(int staffRoleId);
  Future<List<StaffModel>> getByDepartment(int departmentId);
  Future<StaffModel> getByUserId(int userId);
  Future<StaffModel> create(StaffModel staff);
  Future<StaffModel> update(int id, UpdateStaffRequest request, {File? avatarFile});
  Future<StaffModel> updateAvatar(int id, File avatarFile);
  Future<void> delete(int id);
}
