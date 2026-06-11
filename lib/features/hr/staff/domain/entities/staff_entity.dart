import 'package:frontendmobile/features/hr/staff/domain/entities/staff_role_entity.dart';

class StaffEntity {
  final int? id;
  final int? companyId;
  final int? userId;
  final int? staffRoleId;
  final String name; // ✅ only name is truly required
  final String? gender; // ✅ optional
  final String? dateOfBirth; // ✅ optional
  final String? address; // ✅ optional
  final String? email; // ✅ optional
  final String? phone; // ✅ optional
  final int? age; // ✅ add age
  final DateTime? createdAt;
  final String? avatarUrl;
  final String? avatarPublicId;
  final StaffRoleEntity? staffRole;

  const StaffEntity({
    this.id,
    this.companyId,
    this.userId,
    this.staffRoleId,
    required this.name,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.email,
    this.phone,
    this.age,
    this.createdAt,
    this.avatarUrl,
    this.avatarPublicId,
    this.staffRole,
  });

  StaffEntity copyWith({
    int? id,
    int? companyId,
    int? userId,
    int? staffRoleId,
    String? name,
    String? gender,
    String? dateOfBirth,
    String? address,
    String? email,
    String? phone,
    int? age,
    DateTime? createdAt,
    String? avatarUrl,
    String? avatarPublicId,
    StaffRoleEntity? staffRole,
  }) {
    return StaffEntity(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      userId: userId ?? this.userId,
      staffRoleId: staffRoleId ?? this.staffRoleId,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      createdAt: createdAt ?? this.createdAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarPublicId: avatarPublicId ?? this.avatarPublicId,
      staffRole: staffRole ?? this.staffRole,
    );
  }
}
