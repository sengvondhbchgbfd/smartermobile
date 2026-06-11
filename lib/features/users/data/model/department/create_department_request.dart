class CreateDepartmentRequest {
  final String departmentName;
  final int managerId;
  final int companyId;

  CreateDepartmentRequest({
    required this.departmentName,
    required this.managerId,
    required this.companyId,
  });

  Map<String, dynamic> toJson() {
    return {
      "department_name": departmentName,
      "manager_id": managerId,
      "company_id": companyId,
    };
  }
}
