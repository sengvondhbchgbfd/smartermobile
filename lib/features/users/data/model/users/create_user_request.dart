class CreateUserRequest {
  final String username;
  final String password;
  final String fullName;

  final int roleId;
  final int departmentId;
  const CreateUserRequest({
    required this.username,
    required this.password,
    required this.fullName,
    required this.roleId,
    required this.departmentId,
  });
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "full_name": fullName,
      "role_id": roleId,
      "department_id": departmentId,
    };
  }
}
