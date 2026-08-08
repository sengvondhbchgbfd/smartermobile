import 'package:frontendmobile/features/users/domain/entities/permission_entity.dart';

class PermissionModel extends PermissionEntity {
  const PermissionModel({
    required super.id,
    required super.code,
    super.description,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      id: json['permission_id'] ?? json['id'] ?? 0,
      code: json['code'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "permission_id": id,
      "code": code,
      "description": description,
    };
  }
}