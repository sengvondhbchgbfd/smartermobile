

class CreateStaffRoleRequest {
  final String roleName;
  final String description;
  final double baseSalary;
  final bool isManager;

  const CreateStaffRoleRequest({
    required this.roleName,
    required this.description,
    required this.baseSalary,
    required this.isManager,
  });

  Map<String, dynamic> toJson() => {
        'role_name': roleName,
        'description': description,
        'base_salary': baseSalary,
        'is_manager': isManager,
      };
}