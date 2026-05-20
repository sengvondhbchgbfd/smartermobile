class UpdateStaffRoleRequest {
  final String? roleName;
  final String? description;
  final double? baseSalary;
  final bool? isManager;

  const UpdateStaffRoleRequest({
    this.roleName,
    this.description,
    this.baseSalary,
    this.isManager,
  });

  Map<String, dynamic> toJson() => {
        if (roleName != null) 'role_name': roleName,
        if (description != null) 'description': description,
        if (baseSalary != null) 'base_salary': baseSalary,
        if (isManager != null) 'is_manager': isManager,
      };
}
