import 'package:frontendmobile/features/hr/staff/data/model/staff_role/create_staff_role_request.dart';
import 'package:frontendmobile/features/hr/staff/data/model/staff_role/update_staff_role_request.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_role_entity.dart';

class StaffRoleModel extends StaffRoleEntity {
  const StaffRoleModel({
    super.id,
    required super.companyId,
    required super.roleName,
    required super.description,
    required super.baseSalary,
    required super.isManager,
    super.createdAt,
  });

  factory StaffRoleModel.fromJson(Map<String, dynamic> json) => StaffRoleModel(
    id: json['staff_role_id'] as int?,
    companyId: json['company_id'] as int,
    roleName: json['role_name'] as String,
    description: json['description'] as String,
    // baseSalary: (json['base_salary'] as num).toDouble(),
    baseSalary: double.parse(json['base_salary'].toString()),
    isManager: json['is_manager'] as bool,
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'] as String)
        : null,
  );

  Map<String, dynamic> toJson() => CreateStaffRoleRequest(
    roleName: roleName,
    description: description,
    baseSalary: baseSalary,
    isManager: isManager,
  ).toJson();

  Map<String, dynamic> toUpdateJson() => UpdateStaffRoleRequest(
    roleName: roleName,
    description: description,
    baseSalary: baseSalary,
    isManager: isManager,
  ).toJson();

  factory StaffRoleModel.fromEntity(StaffRoleEntity entity) => StaffRoleModel(
    id: entity.id,
    companyId: entity.companyId,
    roleName: entity.roleName,
    description: entity.description,
    baseSalary: entity.baseSalary,
    isManager: entity.isManager,
    createdAt: entity.createdAt,
  );

  StaffRoleEntity toEntity() => StaffRoleEntity(
    id: id,
    companyId: companyId,
    roleName: roleName,
    description: description,
    baseSalary: baseSalary,
    isManager: isManager,
    createdAt: createdAt,
  );
}
