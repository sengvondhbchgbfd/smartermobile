class RegisterUserParams {
  final String username;
  final String password;
  final String fullName;
  final int roleId;
  final int? departmentId;

  const RegisterUserParams({
    required this.username,
    required this.password,
    required this.fullName,
    required this.roleId,
    this.departmentId,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      "username": username,
      "password": password,
      "full_name": fullName,
      "role_id": roleId,
    };

    if (departmentId != null) {
      data["department_id"] = departmentId;
    }

    return data;
  }
}
