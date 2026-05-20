import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/users/domain/repositories/users_repository.dart';

class DeleteUserUsecase {
  final UserRepository repository;
  DeleteUserUsecase(this.repository);
  Future<Either<Failure, void>> call(int userId) {
    return repository.deleteUser(userId);
  }
}
