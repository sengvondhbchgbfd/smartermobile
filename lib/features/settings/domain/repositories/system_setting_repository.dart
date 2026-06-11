import '../entities/system_setting_entity.dart';

abstract class SystemSettingRepository {
  Future<List<SystemSettingEntity>> getAll();
  Future<SystemSettingEntity> getById(int settingId);
  Future<SystemSettingEntity> getByKey(String key);
  Future<SystemSettingEntity> create({
    required String key,
    required String value,
    String? description,
  });
  Future<SystemSettingEntity> updateById({
    required int settingId,
    required String value,
    String? description,
  });
  Future<SystemSettingEntity> upsertByKey({
    required String key,
    required String value,
  });
  Future<List<SystemSettingEntity>> bulkUpsert(
    List<({String key, String value})> items,
  );
  Future<void> delete(int settingId);
}