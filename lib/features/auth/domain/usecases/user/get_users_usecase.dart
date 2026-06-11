import 'package:frontendmobile/features/auth/data/models/auth_user_model.dart';
import 'package:frontendmobile/features/auth/domain/repositories/auth_repository.dart';

class GetUsersUsecase {
  final AuthRepository repository;
  GetUsersUsecase(this.repository);

  Future<UserInfo> call(int userId) async {
    return repository.getUserById(userId);
  }
}
