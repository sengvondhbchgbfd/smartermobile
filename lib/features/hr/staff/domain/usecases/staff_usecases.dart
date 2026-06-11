import 'dart:io';
import 'package:frontendmobile/features/hr/staff/data/model/staff/update_staff_request.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/hr/staff/domain/repositories/staff_repository.dart';

class GetAllStaffUseCase {
  final StaffRepository repository;
  GetAllStaffUseCase(this.repository);
  Future<List<StaffEntity>> call() => repository.getAll();
}

class GetStaffByIdUseCase {
  final StaffRepository repository;
  GetStaffByIdUseCase(this.repository);
  Future<StaffEntity> call(int id) => repository.getById(id);
}

class GetMyStaffProfileUseCase {
  final StaffRepository repository;
  GetMyStaffProfileUseCase(this.repository);
  Future<StaffEntity> call() => repository.getMyProfile();
}

<<<<<<< HEAD
=======


>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
class GetStaffManagersUseCase {
  final StaffRepository repository;
  GetStaffManagersUseCase(this.repository);
  Future<List<StaffEntity>> call() => repository.getManagers();
}



class GetStaffByRoleUseCase {
  final StaffRepository repository;
  GetStaffByRoleUseCase(this.repository);
  Future<List<StaffEntity>> call(int staffRoleId) =>
      repository.getByRole(staffRoleId);
}

class GetStaffByDepartmentUseCase {
  final StaffRepository repository;
  GetStaffByDepartmentUseCase(this.repository);
  Future<List<StaffEntity>> call(int departmentId) =>
      repository.getByDepartment(departmentId);
}

class GetStaffByUserIdUseCase {
  final StaffRepository repository;
  GetStaffByUserIdUseCase(this.repository);
  Future<StaffEntity> call(int userId) => repository.getByUserId(userId);
}

class CreateStaffUseCase {
  final StaffRepository repository;
  CreateStaffUseCase(this.repository);
  Future<StaffEntity> call(StaffEntity staff) => repository.create(staff);
}





class UpdateStaffUseCase {
  final StaffRepository repository;
  UpdateStaffUseCase(this.repository);
  Future<StaffEntity> call(
    int id,
    UpdateStaffRequest request, {
    File? avatarFile,
  }) => repository.update(id, request, avatarFile: avatarFile);
}

class UpdateStaffAvatarUseCase {
  final StaffRepository repository;
  UpdateStaffAvatarUseCase(this.repository);
  Future<StaffEntity> call(int id, File avatarFile) =>
      repository.updateAvatar(id, avatarFile);
}

class DeleteStaffUseCase {
  final StaffRepository repository;
  DeleteStaffUseCase(this.repository);
  Future<void> call(int id) => repository.delete(id);
}
