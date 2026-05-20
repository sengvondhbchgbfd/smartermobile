import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
import 'package:frontendmobile/features/hr/staff/data/model/staff/staff_model.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.fullName,
    required super.roleId,
    super.departmentId,
    required super.status,
    super.roleName,
    super.departmentName,
    super.avatarUrl,
    super.avatarPublicId,
    super.createdAt,
    super.updatedAt,
    super.staff,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['user_id'] as num?)?.toInt() ?? 0,
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      roleId: (json['role_id'] as num?)?.toInt() ?? 0,
      departmentId: (json['department_id'] as num?)?.toInt(),
      roleName: json['role']?['role_name'],
      departmentName: json['department']?['department_name'],
      status: json['status'] ?? 'inactive',
      avatarUrl: json['avatar_url'] as String?,
      avatarPublicId: json['avatar_public_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      staff:
          json['staff'] !=
              null // ✅ add this
          ? StaffModel.fromJson(json['staff'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toCreateJson() => {
    "username": username,
    "full_name": fullName,
    "role_id": roleId,
    "department_id": departmentId,
    "company_id": companyId,
    "status": status,
  };

  Map<String, dynamic> toUpdateJson() => {
    "username": username,
    "full_name": fullName,
    "role_id": roleId,
    "department_id": departmentId,
    "status": status,
  };
}
