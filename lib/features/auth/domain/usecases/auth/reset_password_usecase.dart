import '../../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> call({
    required int userId,
    required String newPassword,
  }) async {
    await repository.resetPassword(
      userId: userId,
      newPassword: newPassword,
    );
  }
}