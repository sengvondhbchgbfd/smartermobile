import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
import 'package:frontendmobile/features/users/domain/repositories/users_repository.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/register_user_params.dart';

class CreateUsersUsecase {
  final UserRepository repository;
  CreateUsersUsecase(this.repository);
  Future<Either<Failure, UserEntity>> call(RegisterUserParams params) async {
    return await repository.createUser(params);
  }
}
