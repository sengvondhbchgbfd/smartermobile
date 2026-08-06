import 'package:frontendmobile/core/constants/app_permissions.dart';
import 'package:frontendmobile/features/auth/data/models/auth_user_model.dart';

extension UserInfoPermissions on UserInfo {
  bool hasPermission(String permission) =>
      permissions.contains('*') || permissions.contains(permission);

  bool hasAnyPermission(List<String> perms) =>
      perms.any((p) => hasPermission(p));

  bool get canViewTeamAttendance =>
      hasPermission(AppPermissions.viewTeamAttendance);

  bool get canManageAttendanceSettings =>
      hasPermission(AppPermissions.manageAttendanceSettings);

  bool get canApproveLeave => hasPermission(AppPermissions.approveLeave);

  bool get canViewTeamLeave => hasPermission(AppPermissions.viewTeamLeave);

  bool get canViewTeamSalary => hasPermission(AppPermissions.viewTeamSalary);

  bool get canManageStaff => hasPermission(AppPermissions.manageStaff);

  bool get canManageUsers => hasPermission(AppPermissions.manageUsers);

  // Company
  bool get canManageCompany => hasPermission(AppPermissions.manageCompany);

  bool get canViewCompany =>
      hasPermission(AppPermissions.viewCompany) || canManageCompany;
}
