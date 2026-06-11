import 'package:frontendmobile/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserUseCase {
  final AuthRepository repository;
  UpdateUserUseCase(this.repository);

  Future<void> call({
    required int userId,
    String? fullName,
    int? roleId,
    int? departmentId,
    String? status,
  }) async {
    await repository.updateUser(
      userId: userId,
      fullName: fullName,
      roleId: roleId,
      departmentId: departmentId,
      status: status,
    );
  }
}
