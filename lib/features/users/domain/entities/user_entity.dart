import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';

class UserEntity {
  final int id;
  final int? companyId;
  final String username;
  final String fullName;
  final int roleId;
  final int? departmentId;
  final String? roleName;
  final String? departmentName;
  final String status;
  final String? avatarUrl;
  final String? avatarPublicId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final StaffEntity? staff;

  const UserEntity({
    required this.id,
    this.companyId,
    required this.username,
    required this.fullName,
    required this.roleId,
    this.departmentId,
    this.roleName,
    this.departmentName,
    required this.status,
    this.avatarUrl,
    this.avatarPublicId,
    this.createdAt,
    this.updatedAt,
    this.staff, // ✅ add this
  });

  UserEntity copyWith({
    int? id,
    int? companyId,
    String? username,
    String? fullName,
    int? roleId,
    int? departmentId,
    String? roleName,
    String? departmentName,
    String? status,
    String? avatarUrl,
    String? avatarPublicId,
    DateTime? createdAt,
    DateTime? updatedAt,
    StaffEntity? staff,
  }) {
    return UserEntity(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      roleId: roleId ?? this.roleId,
      departmentId: departmentId ?? this.departmentId,
      roleName: roleName ?? this.roleName,
      departmentName: departmentName ?? this.departmentName,
      status: status ?? this.status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarPublicId: avatarPublicId ?? this.avatarPublicId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      staff: staff ?? this.staff, // ✅ preserved
    );
  }
}
