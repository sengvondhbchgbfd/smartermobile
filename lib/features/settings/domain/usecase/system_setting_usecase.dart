import '../entities/system_setting_entity.dart';
import '../repositories/system_setting_repository.dart';

// ---------------------------------------------------------------------------
// Get All
// ---------------------------------------------------------------------------
class GetAllSettingsUseCase {
  final SystemSettingRepository _repo;
  const GetAllSettingsUseCase(this._repo);

  Future<List<SystemSettingEntity>> call() => _repo.getAll();
}

// ---------------------------------------------------------------------------
// Get By Id
// ---------------------------------------------------------------------------
class GetSettingByIdUseCase {
  final SystemSettingRepository _repo;
  const GetSettingByIdUseCase(this._repo);

  Future<SystemSettingEntity> call(int settingId) => _repo.getById(settingId);
}

// ---------------------------------------------------------------------------
// Get By Key
// ---------------------------------------------------------------------------
class GetSettingByKeyUseCase {
  final SystemSettingRepository _repo;
  const GetSettingByKeyUseCase(this._repo);

  Future<SystemSettingEntity> call(String key) => _repo.getByKey(key);
}

// ---------------------------------------------------------------------------
// Create
// ---------------------------------------------------------------------------
class CreateSettingUseCase {
  final SystemSettingRepository _repo;
  const CreateSettingUseCase(this._repo);

  Future<SystemSettingEntity> call({
    required String key,
    required String value,
    String? description,
  }) => _repo.create(key: key, value: value, description: description);
}

// ---------------------------------------------------------------------------
// Update By Id
// ---------------------------------------------------------------------------
class UpdateSettingUseCase {
  final SystemSettingRepository _repo;
  const UpdateSettingUseCase(this._repo);

  Future<SystemSettingEntity> call({
    required int settingId,
    required String value,
    String? description,
  }) => _repo.updateById(
    settingId: settingId,
    value: value,
    description: description,
  );
}

// ---------------------------------------------------------------------------
// Upsert By Key
// ---------------------------------------------------------------------------
class UpsertSettingByKeyUseCase {
  final SystemSettingRepository _repo;
  const UpsertSettingByKeyUseCase(this._repo);

  Future<SystemSettingEntity> call({
    required String key,
    required String value,
  }) => _repo.upsertByKey(key: key, value: value);
}

// ---------------------------------------------------------------------------
// Bulk Upsert
// ---------------------------------------------------------------------------
class BulkUpsertSettingsUseCase {
  final SystemSettingRepository _repo;
  const BulkUpsertSettingsUseCase(this._repo);

  Future<List<SystemSettingEntity>> call(
    List<({String key, String value})> items,
  ) => _repo.bulkUpsert(items);
}

// ---------------------------------------------------------------------------
// Delete
// ---------------------------------------------------------------------------
class DeleteSettingUseCase {
  final SystemSettingRepository _repo;
  const DeleteSettingUseCase(this._repo);

  Future<void> call(int settingId) => _repo.delete(settingId);
}
