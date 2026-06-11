class UpdateUserRequest {
  final String username;
  final String fullName;
  final int departmentId;
  final int roleId;
  final String status;

  UpdateUserRequest({
    required this.username,
    required this.fullName,
    required this.departmentId,
    required this.roleId,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "full_name": fullName,
      "department_id": departmentId,
      "role_id": roleId,
      "status": status,
    };
  }
}