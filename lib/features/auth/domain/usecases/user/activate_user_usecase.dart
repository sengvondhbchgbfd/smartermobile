import '../../repositories/auth_repository.dart';

class ActivateUserUseCase {
  final AuthRepository repository;

  ActivateUserUseCase(this.repository);

  Future<void> call(int userId) async {
    await repository.activateUser(userId);
  }
}