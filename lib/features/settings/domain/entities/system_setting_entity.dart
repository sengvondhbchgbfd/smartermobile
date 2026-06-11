class SystemSettingEntity {
  final int settingId;
  final int companyId;
  final String key;
  final String? value;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SystemSettingEntity({
    required this.settingId,
    required this.companyId,
    required this.key,
    this.value,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  SystemSettingEntity copyWith({
    int? settingId,
    int? companyId,
    String? key,
    String? value,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SystemSettingEntity(
      settingId:   settingId   ?? this.settingId,
      companyId:   companyId   ?? this.companyId,
      key:         key         ?? this.key,
      value:       value       ?? this.value,
      description: description ?? this.description,
      createdAt:   createdAt   ?? this.createdAt,
      updatedAt:   updatedAt   ?? this.updatedAt,
    );
  }
}