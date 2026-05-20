import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/users/domain/repositories/users_repository.dart';

class DeleteDepartmentUsecase {
  final UserRepository repository;
  DeleteDepartmentUsecase(this.repository);
  Future<Either<Failure, void>> call(int departmentId) {
    return repository.deleteDepartment(departmentId);
  }
}
