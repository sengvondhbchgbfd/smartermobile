import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
import 'package:frontendmobile/features/users/domain/repositories/users_repository.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/get_users_params.dart';

class GetUsersUseCase {
  final UserRepository repository;
  GetUsersUseCase(this.repository);
  Future<Either<Failure, List<UserEntity>>> call(GetUsersParams params) async {
    return await repository.getUsers(params.skip, params.limit);
  }
}