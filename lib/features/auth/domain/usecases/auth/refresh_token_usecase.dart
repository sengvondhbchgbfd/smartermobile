import '../../../data/models/auth_user_model.dart';
import '../../repositories/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<UserModel> call(
    String refreshToken,
  ) async {
    return await repository.refreshToken(refreshToken);
  }
}