import 'package:frontendmobile/features/users/domain/entities/permission_entity.dart';

class RoleEntity {
  final int id;
  final String roleName;
  final int? companyId;
  final List<PermissionEntity> permissions;   // 👈 new

  const RoleEntity({
    required this.id,
    required this.roleName,
    this.companyId,
    this.permissions = const [],              // 👈 new, default empty
  });
}