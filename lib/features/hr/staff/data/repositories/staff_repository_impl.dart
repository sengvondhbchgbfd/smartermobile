import 'dart:io';
import 'package:frontendmobile/features/hr/staff/data/datasources/staff_remote_datasource.dart';
import 'package:frontendmobile/features/hr/staff/data/model/staff/staff_model.dart';
import 'package:frontendmobile/features/hr/staff/data/model/staff/update_staff_request.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/hr/staff/domain/repositories/staff_repository.dart';

class StaffRepositoryImpl implements StaffRepository {
 
 
  final StaffRemoteDataSource remoteDataSource;
  StaffRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<StaffEntity>> getAll() async {
    final models = await remoteDataSource.getAll();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<StaffEntity> getById(int id) async {
    final model = await remoteDataSource.getById(id);
    return model.toEntity();
  }

  @override
  Future<StaffEntity> getMyProfile() async {
    final model = await remoteDataSource.getMyProfile();
    return model.toEntity();
  }

  @override
  Future<List<StaffEntity>> getManagers() async {
    final models = await remoteDataSource.getManagers();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<StaffEntity>> getByRole(int staffRoleId) async {
    final models = await remoteDataSource.getByRole(staffRoleId);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<StaffEntity>> getByDepartment(int departmentId) async {
    final models = await remoteDataSource.getByDepartment(departmentId);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<StaffEntity> getByUserId(int userId) async {
    final model = await remoteDataSource.getByUserId(userId);
    return model.toEntity();
  }

  @override
  Future<StaffEntity> create(StaffEntity staff) async {
    final model = await remoteDataSource.create(StaffModel.fromEntity(staff));
    return model.toEntity();
  }

  @override
  Future<StaffEntity> update(
    int id,
    UpdateStaffRequest request, {
    File? avatarFile,
  }) async {
    final model = await remoteDataSource.update(
      id,
      request,
      avatarFile: avatarFile,
    );
    return model.toEntity();
  }

  @override
  Future<StaffEntity> updateAvatar(int id, File avatarFile) async {
    final model = await remoteDataSource.updateAvatar(id, avatarFile);
    return model.toEntity();
  }





  @override
  Future<void> delete(int id) => remoteDataSource.delete(id);

 
}
