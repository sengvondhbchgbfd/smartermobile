import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';

<<<<<<< HEAD
=======
const _undefined = Object();

>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
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
<<<<<<< HEAD
    this.staff, // ✅ add this
=======
    this.staff,
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  });

  UserEntity copyWith({
    int? id,
    int? companyId,
    String? username,
    String? fullName,
<<<<<<< HEAD
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
=======
    int? roleId,                              // ← non-nullable, safe
    Object? departmentId = _undefined,
    Object? roleName = _undefined,
    Object? departmentName = _undefined,
    String? status,
    Object? avatarUrl = _undefined,
    Object? avatarPublicId = _undefined,
    Object? createdAt = _undefined,
    Object? updatedAt = _undefined,
    Object? staff = _undefined,
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  }) {
    return UserEntity(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
<<<<<<< HEAD
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
=======
      roleId: roleId ?? this.roleId,          // ← safe, never null
      departmentId: departmentId == _undefined
          ? this.departmentId
          : departmentId as int?,
      roleName: roleName == _undefined
          ? this.roleName
          : roleName as String?,
      departmentName: departmentName == _undefined
          ? this.departmentName
          : departmentName as String?,
      status: status ?? this.status,
      avatarUrl: avatarUrl == _undefined
          ? this.avatarUrl
          : avatarUrl as String?,
      avatarPublicId: avatarPublicId == _undefined
          ? this.avatarPublicId
          : avatarPublicId as String?,
      createdAt: createdAt == _undefined
          ? this.createdAt
          : createdAt as DateTime?,
      updatedAt: updatedAt == _undefined
          ? this.updatedAt
          : updatedAt as DateTime?,
      staff: staff == _undefined
          ? this.staff
          : staff as StaffEntity?,
    );
  }
}
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
