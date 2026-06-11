import '../../domain/entities/system_setting_entity.dart';

class SystemSettingModel extends SystemSettingEntity {
  const SystemSettingModel({
    required super.settingId,
    required super.companyId,
    required super.key,
    super.value,
    super.description,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SystemSettingModel.fromJson(Map<String, dynamic> json) {
    return SystemSettingModel(
      settingId: json['setting_id'] as int,
      companyId: json['company_id'] as int,
      key: json['key'] as String,
      value: json['value'] as String?,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'setting_id': settingId,
    'company_id': companyId,
    'key': key,
    'value': value,
    'description': description,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
