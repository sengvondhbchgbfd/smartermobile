class CreateRoleRequest {
  final String roleName;
  final int companyId;

  CreateRoleRequest({
    required this.roleName,
    required this.companyId,
  });

  Map<String, dynamic> toJson() {
    return {
      "role_name": roleName,
      "company_id": companyId,
    };
  }
}