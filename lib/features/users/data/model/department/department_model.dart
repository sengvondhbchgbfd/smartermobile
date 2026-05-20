import 'package:frontendmobile/features/users/domain/entities/department_entity.dart';

class DepartmentModel extends DepartmentEntity {
  const DepartmentModel({
    required super.departmentId,
    required super.departmentName,
    super.managerId,
    super.companyId,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      departmentId: json['department_id'] ?? 0,
      departmentName: json['department_name'] ?? '',
      managerId: json['manager_id'],
      companyId: json['company_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "department_id": departmentId,
      "department_name": departmentName,
      "manager_id": managerId,
      "company_id": companyId,
    };
  }
}
