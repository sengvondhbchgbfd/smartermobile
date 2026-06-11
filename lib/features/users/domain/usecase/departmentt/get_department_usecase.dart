import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/users/domain/entities/department_entity.dart';
import 'package:frontendmobile/features/users/domain/repositories/users_repository.dart';

class GetDepartmentsUseCase {
  final UserRepository repository;

  GetDepartmentsUseCase(this.repository);

  Future<Either<Failure, List<DepartmentEntity>>> call() async {
    return await repository.getDepartments();
  }
}
