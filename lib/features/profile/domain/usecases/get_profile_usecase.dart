import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository _repo;
  GetProfileUseCase(this._repo);
  Future<ProfileEntity> call() => _repo.getProfile();
}