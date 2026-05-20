import 'package:frontendmobile/features/auth/data/models/auth_user_model.dart';
import 'package:frontendmobile/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<UserModel> call(String username, String password) {
    return _repository.login(username, password);
  }
}
