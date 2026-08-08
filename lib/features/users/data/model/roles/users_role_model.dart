import 'package:frontendmobile/features/users/domain/entities/role_entity.dart';
import 'package:frontendmobile/features/users/data/model/roles/permission_model.dart';

class RoleModel extends RoleEntity {
  const RoleModel({
    required super.id,
    required super.roleName,
    super.companyId,
    super.permissions,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['role_id'] ?? json['id'] ?? 0,
      roleName: json['role_name'] ?? '',
      companyId: json['company_id'],
      permissions: (json['permissions'] as List<dynamic>? ?? [])
          .map((p) => PermissionModel.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "role_id": id,
      "role_name": roleName,
      "company_id": companyId,
    };
  }
}