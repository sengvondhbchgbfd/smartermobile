import 'package:frontendmobile/features/auth/domain/repositories/auth_repository.dart';

class RegisterUserUsecase {
  final AuthRepository _repo;
  const RegisterUserUsecase(this._repo);
  Future<void> call({
    required String username,
    required String password,
    required String fullName,
    required int roleId,
    required int departmentId,
  }) => _repo.registerUser(
    username: username,
    password: password,
    fullName: fullName,
    roleId: roleId,
    departmentId: departmentId,
  );
}
