import 'package:frontendmobile/features/auth/domain/entities/user.dart';
import 'package:frontendmobile/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<User> call(String email, String password) {
    return repository.login(email, password) as Future<User>;
  }
}
