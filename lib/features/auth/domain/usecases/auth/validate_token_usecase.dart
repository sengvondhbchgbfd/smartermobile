import 'package:frontendmobile/features/auth/domain/repositories/auth_repository.dart';

class ValidateTokenUseCase {
  final AuthRepository _repository;
  ValidateTokenUseCase(this._repository);

  Future<bool> call(String token) async {
    return await _repository.validateToken(token);
  }
}