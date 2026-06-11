import '../../domain/entities/system_setting_entity.dart';
import '../../domain/repositories/system_setting_repository.dart';
import '../datasources/system_setting_remote_datasource.dart';

class SystemSettingRepositoryImpl implements SystemSettingRepository {
  final SystemSettingRemoteDataSource _remote;

  const SystemSettingRepositoryImpl(this._remote);

  @override
  Future<List<SystemSettingEntity>> getAll() => _remote.getAll();

  @override
  Future<SystemSettingEntity> getById(int settingId) =>
      _remote.getById(settingId);

  @override
  Future<SystemSettingEntity> getByKey(String key) => _remote.getByKey(key);

  @override
  Future<SystemSettingEntity> create({
    required String key,
    required String value,
    String? description,
  }) => _remote.create(key: key, value: value, description: description);

  @override
  Future<SystemSettingEntity> updateById({
    required int settingId,
    required String value,
    String? description,
  }) => _remote.updateById(
    settingId: settingId,
    value: value,
    description: description,
  );

  @override
  Future<SystemSettingEntity> upsertByKey({
    required String key,
    required String value,
  }) => _remote.upsertByKey(key: key, value: value);

  @override
  Future<List<SystemSettingEntity>> bulkUpsert(
    List<({String key, String value})> items,
  ) => _remote.bulkUpsert(items);

  @override
  Future<void> delete(int settingId) => _remote.delete(settingId);
}
