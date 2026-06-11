class RoleEntity {
  final int id;
  final String roleName;
  final int? companyId;

  const RoleEntity({required this.id, required this.roleName, this.companyId});
}
