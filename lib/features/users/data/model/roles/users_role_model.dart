import 'package:frontendmobile/features/users/domain/entities/role_entity.dart';

class RoleModel extends RoleEntity {
  const RoleModel({
    required super.id,
    required super.roleName,
    super.companyId,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['role_id'] ?? json['id'] ?? 0,
      roleName: json['role_name'] ?? '',
      companyId: json['company_id'],
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