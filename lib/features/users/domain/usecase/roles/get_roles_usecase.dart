import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/users/domain/entities/role_entity.dart';
import 'package:frontendmobile/features/users/domain/repositories/users_repository.dart';

class GetRolesUseCase {
  final UserRepository repository;

  GetRolesUseCase(this.repository);

  Future<Either<Failure, List<RoleEntity>>> call() async {
    return await repository.getRoles();
  }
}