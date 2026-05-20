// profile_repository_impl.dart
import 'package:frontendmobile/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:frontendmobile/features/profile/domain/entities/profile_entity.dart';
import 'package:frontendmobile/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDatasource _local;  
  ProfileRepositoryImpl(this._local);

  @override
  Future<ProfileEntity> getProfile() async {
    final model = await _local.getProfile();
    return ProfileEntity(
      userId:       model.userId,
      companyId:    model.companyId,
      staffId:      model.staffId,
      username:     model.username,
      fullName:     model.fullName,
      role:         model.role,
      status:       model.status,
      isManager:    model.isManager,
      permissions:  model.permissions,
      departmentId: model.departmentId,
    );
  }
}