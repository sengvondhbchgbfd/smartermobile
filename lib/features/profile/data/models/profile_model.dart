import 'package:frontendmobile/features/auth/data/models/auth_user_model.dart';

class ProfileModel {
  final int userId;
  final int companyId;
  final int staffId;
  final String username;
  final String fullName;
  final String role;
  final String status;
  final bool isManager;
  final List<String> permissions;
  final int? departmentId;
  final String? avatarUrl;
  final String? memberSince;
  final String? department;

  ProfileModel({
    required this.userId,
    required this.companyId,
    required this.staffId,
    required this.username,
    required this.fullName,
    required this.role,
    required this.status,
    required this.isManager,
    required this.permissions,
    this.departmentId,
    this.avatarUrl,
    this.memberSince,
    this.department,
  });

  factory ProfileModel.fromUserInfo(UserInfo user) {
    return ProfileModel(
      userId: user.userId,
      companyId: user.companyId,
      staffId: user.staffId,
      username: user.username,
      fullName: user.fullName,
      role: user.role,
      status: user.status,
      isManager: user.isManager,
      permissions: user.permissions,
      departmentId: user.departmentId,
    );
  }
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['user_id'],
      companyId: json['company_id'],
      staffId: json['staff_id'],
      username: json['username'],
      fullName: json['full_name'],
      role: json['role'],
      status: json['status'],
      isManager: json['is_manager'] ?? false,
      permissions: List<String>.from(json['permissions'] ?? []),
      departmentId: json['department_id'],
      avatarUrl: json['avatar_url'],
      memberSince: json['member_since'],
      department: json['department'],
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'company_id': companyId,
    'staff_id': staffId,
    'username': username,
    'full_name': fullName,
    'role': role,
    'status': status,
    'is_manager': isManager,
    'permissions': permissions,
    'department_id': departmentId,
  };
}
