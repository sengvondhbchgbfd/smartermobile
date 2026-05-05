import 'package:frontendmobile/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;
  RegisterUseCase(this._repository);

  Future<void> call({
    required String companyName,
    required String companyCode,
    required String username,
    required String password,
    required String fullName,
    required String timezone,
    required String currency,
  }) async {
    await _repository.register(
      companyName: companyName,
      companyCode: companyCode,
      username:    username,
      password:    password,
      fullName:    fullName,
      timezone:    timezone,
      currency:    currency,
    );
  }
}