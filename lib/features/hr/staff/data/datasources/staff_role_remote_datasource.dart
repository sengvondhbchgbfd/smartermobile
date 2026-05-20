import 'package:frontendmobile/features/hr/staff/data/model/staff_role/staff_role_model.dart';

abstract class StaffRoleRemoteDataSource {
  Future<List<StaffRoleModel>> getAll();
  Future<StaffRoleModel> getById(int id);
  Future<StaffRoleModel> create(StaffRoleModel role);
  Future<StaffRoleModel> update(int id, StaffRoleModel role);
  Future<void> delete(int id);
}