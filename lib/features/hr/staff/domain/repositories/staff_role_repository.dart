import 'package:frontendmobile/features/hr/staff/domain/entities/staff_role_entity.dart';

abstract class StaffRoleRepository {
  Future<List<StaffRoleEntity>> getAll();
  Future<StaffRoleEntity> getById(int id);
  Future<StaffRoleEntity> create(StaffRoleEntity role);
  Future<StaffRoleEntity> update(int id, StaffRoleEntity role);
  Future<void> delete(int id);
}