class PermissionEntity {
  final int id;
  final String code;
  final String? description;

  const PermissionEntity({
    required this.id,
    required this.code,
    this.description,
  });
}