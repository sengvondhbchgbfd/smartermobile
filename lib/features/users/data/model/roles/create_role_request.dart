class CreateRoleRequest {
  final String roleName;

  CreateRoleRequest({required this.roleName});

  Map<String, dynamic> toJson() {
    return {"role_name": roleName};
  }
}