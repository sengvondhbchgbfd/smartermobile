class AppPermissions {
  AppPermissions._();

  // Profile & self
  static const rcheadOwnProfile = 'read_own_profile';

  // Attendance
  static const viewOwnAttendance = 'view_own_attendance';
  static const viewTeamAttendance = 'view_team_attendance';
  static const manageAttendanceSettings = 'manage_attendance_settings';

  // Leave
  static const requestLeave = 'request_leave';
  static const approveLeave = 'approve_leave';
  static const viewTeamLeave = 'view_team_leave';

  // Salary
  static const viewOwnSalary = 'view_own_salary';
  static const viewTeamSalary = 'view_team_salary';
  static const manageSalary = 'manage_salary';

  // Staff
  static const viewUsers = 'view_users';
  static const manageStaff = 'manage_staff';
  static const manageUsers = 'manage_users';

  // Company
  static const viewCompany = 'view_company';
  static const manageCompany = 'manage_company';
}
