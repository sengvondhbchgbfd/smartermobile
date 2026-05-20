import 'package:frontendmobile/features/hr/staff/domain/entities/staff_role_entity.dart';
import 'package:frontendmobile/features/hr/staff/domain/repositories/staff_role_repository.dart';

class GetAllStaffRoleUseCase {
  final StaffRoleRepository repository;
  GetAllStaffRoleUseCase(this.repository);

  Future<List<StaffRoleEntity>> call() => repository.getAll();
}

class GetStaffRoleByIdUseCase {
  final StaffRoleRepository repository;
  GetStaffRoleByIdUseCase(this.repository);

  Future<StaffRoleEntity> call(int id) => repository.getById(id);
}

class CreateStaffRoleUseCase {
  final StaffRoleRepository repository;
  CreateStaffRoleUseCase(this.repository);

  Future<StaffRoleEntity> call(StaffRoleEntity role) => repository.create(role);
}

class UpdateStaffRoleUseCase {
  final StaffRoleRepository repository;
  UpdateStaffRoleUseCase(this.repository);

  Future<StaffRoleEntity> call(int id, StaffRoleEntity role) =>
      repository.update(id, role);
}

class DeleteStaffRoleUseCase {
  final StaffRoleRepository repository;
  DeleteStaffRoleUseCase(this.repository);

  Future<void> call(int id) => repository.delete(id);
}