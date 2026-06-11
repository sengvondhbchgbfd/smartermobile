import 'dart:io';
import 'package:frontendmobile/features/hr/staff/data/model/staff/update_staff_request.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';

abstract class StaffRepository {
  Future<List<StaffEntity>> getAll();
  Future<StaffEntity> getById(int id);
  Future<StaffEntity> getMyProfile();
  Future<List<StaffEntity>> getManagers();
  Future<List<StaffEntity>> getByRole(int staffRoleId);
  Future<List<StaffEntity>> getByDepartment(int departmentId);
  Future<StaffEntity> getByUserId(int userId);
  Future<StaffEntity> create(StaffEntity staff);
  Future<StaffEntity> update(int id, UpdateStaffRequest request, {File? avatarFile});
  Future<StaffEntity> updateAvatar(int id, File avatarFile);
  Future<void> delete(int id);



}