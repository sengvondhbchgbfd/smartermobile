import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/users/domain/entities/role_entity.dart';
import 'package:frontendmobile/features/users/domain/repositories/users_repository.dart';

class CreateRoleParams {
  final String roleName;
  final int companyId;
  const CreateRoleParams({required this.roleName, required this.companyId});

  Map<String, dynamic> toJson() {
    return {"role_name": roleName, "company_id": companyId};
  }
}
class CreateRoleUsecae {
  final UserRepository repository;
  CreateRoleUsecae(this.repository);
  Future<Either<Failure, RoleEntity>> call(CreateRoleParams params) {
    return repository.createRole(params.toJson());
  }
}

class SetRolePermissionsParams {
  final int roleId;
  final List<String> permissionCodes;
  const SetRolePermissionsParams({
    required this.roleId,
    required this.permissionCodes,
  });
}

class SetRolePermissionsUseCase {
  final UserRepository repository;

  SetRolePermissionsUseCase(this.repository);

  Future<Either<Failure, RoleEntity>> call(SetRolePermissionsParams params) {
    return repository.setRolePermissions(
      params.roleId,
      params.permissionCodes,
    );
  }
}