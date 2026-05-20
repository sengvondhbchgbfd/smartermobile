import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/users/domain/entities/department_entity.dart';
import 'package:frontendmobile/features/users/domain/repositories/users_repository.dart';

class CreateDepartmentParams {
  final String departmentName;
  final int? managerId; // ✅ nullable
  final int? companyId; // ✅ nullable — comes from JWT

  const CreateDepartmentParams({
    required this.departmentName,
    this.managerId, // ✅ optional
    this.companyId, // ✅ optional
  });

  Map<String, dynamic> toJson() => {
    'department_name': departmentName,
    if (managerId != null) 'manager_id': managerId,
    if (companyId != null) 'company_id': companyId,
  };
}

class CreateDepartmentUsecase {
  final UserRepository repository;
  CreateDepartmentUsecase(this.repository);

  Future<Either<Failure, DepartmentEntity>> call(
    CreateDepartmentParams params,
  ) {
    return repository.createDepartment(params.toJson());
  }
}
