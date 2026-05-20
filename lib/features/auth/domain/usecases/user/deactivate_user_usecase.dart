import '../../repositories/auth_repository.dart';

class DeactivateUserUseCase {
  final AuthRepository repository;

  DeactivateUserUseCase(this.repository);

  Future<void> call(int userId) async {
    await repository.deactivateUser(userId);
  }
}
