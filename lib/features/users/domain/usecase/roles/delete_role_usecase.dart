import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/users/domain/repositories/users_repository.dart';

class DeleteRoleUsecase {
  final UserRepository repository;
  DeleteRoleUsecase(this.repository);
  Future<Either<Failure, void>> call(int roleId) {
    return repository.deleteRole(roleId);
  }
}
