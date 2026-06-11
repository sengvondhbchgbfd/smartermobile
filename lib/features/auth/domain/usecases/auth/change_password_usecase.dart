import '../../repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<void> call({
    required String oldPassword,
    required String newPassword,
  }) async {
    await repository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}