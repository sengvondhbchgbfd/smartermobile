import 'package:frontendmobile/core/constants/app_permissions.dart';
import 'package:frontendmobile/features/auth/data/models/auth_user_model.dart';

extension UserInfoPermissions on UserInfo {
  bool hasPermission(String permission) =>
      permissions.contains('*') || permissions.contains(permission);

  bool hasAnyPermission(List<String> perms) =>
      perms.any((p) => hasPermission(p));

  // Attendance
  bool get canViewTeamAttendance =>
      hasPermission(AppPermissions.viewTeamAttendance);

  bool get canManageAttendanceSettings =>
      hasPermission(AppPermissions.manageAttendanceSettings);

  // Leave
  bool get canApproveLeave => hasPermission(AppPermissions.approveLeave);

  bool get canViewTeamLeave => hasPermission(AppPermissions.viewTeamLeave);

  // Salary
  bool get canViewTeamSalary => hasPermission(AppPermissions.viewTeamSalary);

  bool get canManageSalary => hasPermission(AppPermissions.manageSalary); // ← ADDED, was missing

  // Staff / Users
  bool get canManageStaff => hasPermission(AppPermissions.manageStaff);

  bool get canViewStaff =>
      hasPermission(AppPermissions.viewUsers) || canManageStaff;

  bool get canManageUsers => hasPermission(AppPermissions.manageUsers);

  // Company
  bool get canManageCompany => hasPermission(AppPermissions.manageCompany);

  bool get canViewCompany =>
      hasPermission(AppPermissions.viewCompany) || canManageCompany;
}