import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
import 'package:frontendmobile/features/users/domain/repositories/users_repository.dart';
import 'package:frontendmobile/features/users/domain/usecase/users/params/update_user_params.dart';

class UpdateUsersUsecase {
  final UserRepository repository;
  UpdateUsersUsecase(this.repository);
  Future<Either<Failure, UserEntity>> call(UpdateUsersParams params) async {
    return await repository.updateUser(params);
  }
}
