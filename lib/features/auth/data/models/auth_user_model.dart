class UserModel {
  final String accessToken;
  final String refreshToken;
  final int accessExpiresIn;
  final String tokenType;
  final UserInfo user;

  const UserModel({
    required this.accessToken,
    required this.refreshToken,
    required this.accessExpiresIn,
    required this.tokenType,
    required this.user,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    accessToken: json['access_token'] as String,
    refreshToken: json['refresh_token'] ?? '',
    accessExpiresIn: json['access_expires_in'] as int,
    tokenType: json['token_type'] as String,
    user: UserInfo.fromJson(json['user']),
  );
}

<<<<<<< HEAD


class UserInfo {
  final int userId;


=======
////////////////////////////////////////////////////////////////////////////////
/// User Info Model
////////////////////////////////////////////////////////////////////////////////

class UserInfo {
  final int userId;
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  final int companyId;
  final String username;
  final String fullName;
  final String role;
  final int? departmentId;

<<<<<<< HEAD

=======
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  final List<String> permissions;
  final int staffId;
  final String status;
  final bool isManager;

  const UserInfo({
    required this.userId,
    required this.companyId,
    required this.username,
    required this.fullName,
    required this.role,
    this.departmentId,
    required this.permissions,
    required this.staffId,
    required this.status,
    required this.isManager,
  });

<<<<<<< HEAD




=======
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    userId: json['user_id'] ?? 0,
    companyId: json['company_id'] ?? 0,
    username: json['username'] ?? '',
    fullName: json['full_name'] ?? '',
    role: json['role'] ?? '',
    departmentId: json['department_id'],
    permissions:
        (json['permissions'] as List?)?.map((e) => e.toString()).toList() ?? [],
    staffId: json['staff_id'] ?? 0,
    status: json['status'] ?? '',
    isManager: json['is_manager'] ?? false,
  );

<<<<<<< HEAD
   operator [](String other) {}
=======
  operator [](String other) {}
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
}
