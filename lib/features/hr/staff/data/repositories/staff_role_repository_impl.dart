import 'package:frontendmobile/features/hr/staff/data/datasources/staff_role_remote_datasource.dart';
import 'package:frontendmobile/features/hr/staff/data/model/staff_role/staff_role_model.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_role_entity.dart';
import 'package:frontendmobile/features/hr/staff/domain/repositories/staff_role_repository.dart';

class StaffRoleRepositoryImpl implements StaffRoleRepository {
  final StaffRoleRemoteDataSource remoteDataSource;
  StaffRoleRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<StaffRoleEntity>> getAll() async {
    final models = await remoteDataSource.getAll();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<StaffRoleEntity> getById(int id) async {
    final model = await remoteDataSource.getById(id);
    return model.toEntity();
  }

  @override
  Future<StaffRoleEntity> create(StaffRoleEntity role) async {
    final model = await remoteDataSource.create(StaffRoleModel.fromEntity(role));
    return model.toEntity();
  }

  @override
  Future<StaffRoleEntity> update(int id, StaffRoleEntity role) async {
    final model = await remoteDataSource.update(id, StaffRoleModel.fromEntity(role));
    return model.toEntity();
  }

  @override
  Future<void> delete(int id) => remoteDataSource.delete(id);
}