class DepartmentEntity {
  final int departmentId;
  final String departmentName;
  final int? managerId;
  final int? companyId;

  const DepartmentEntity({
    required this.departmentId,
    required this.departmentName,
    this.managerId,
    this.companyId,
  });
}
