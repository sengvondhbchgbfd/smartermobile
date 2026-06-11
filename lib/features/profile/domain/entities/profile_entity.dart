class ProfileEntity {
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
  /////////////////////////////////
  // staffProfile
  ////////////////////////////////
  final String? avatarUrl;
  final String? memberSince;
  final String? department;

  ProfileEntity({
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
}
