class RegisterRequestModel {
  final String companyName;
  final String companyCode;
  final String username;
  final String password;
  final String fullName;
  final String timezone;
  final String currency;
  RegisterRequestModel({
    required this.companyName,
    required this.companyCode,
    required this.username,
    required this.password,
    required this.fullName,
    required this.timezone,
    required this.currency,
  });

  Map<String, dynamic> toJson() => {
    "company_name": companyName,
    "company_code": companyCode,
    "username": username,
    "password": password,
    "full_name": fullName,
    "timezone": timezone,
    "currency": currency,
  };
}

/////////////////////////////////////////////////////
///
////////////////////////////////////////////////////


class RegisterUserRequestModel {
  final String username;
  final String password;
  final String fullName;
  final int roleId;
  final int departmentId;

  const RegisterUserRequestModel({
    required this.username,
    required this.password,
    required this.fullName,
    required this.roleId,
    required this.departmentId,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'full_name': fullName,
    'role_id': roleId,
    'department_id': departmentId,
  };
}