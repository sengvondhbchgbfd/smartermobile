import 'package:frontendmobile/features/auth/data/models/auth_user_model.dart';
import 'package:frontendmobile/features/auth/domain/repositories/auth_repository.dart';

class GetUserUsecase {
  final AuthRepository repository;
  GetUserUsecase(this.repository);

  Future<List<UserInfo>> call() async {
    return repository.getUsers();
  }
}
