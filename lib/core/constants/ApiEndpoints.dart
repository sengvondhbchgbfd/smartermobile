class ApiEndpoints {
  // ── Setup (first run) ───────────────────
  static const String setupStatus = '/setup/status';
  static const String setupRegister = '/setup/register';
  // ── Auth ────────────────────────────────
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String register = '/auth/register';
  static const String users = '/auth/users';
  static const String changePassword = '/auth/change-password';

  // ── Company ─────────────────────────────
  static const String companies = '/companies';
  // ── Roles ───────────────────────────────
  static const String roles = '/roles';

  // ── Departments ─────────────────────────
  static const String departments = '/departments';
  // ── Users ───────────────────────────────
  static const String usersV1 = '/users';

  // ── Staff Roles ─────────────────────────
  static const String staffRoles = '/staff-roles';

  // ── Staff ───────────────────────────────
  static const String staff = '/staff';
  static const String staffMy = '/staff/my';
  static const String staffManagers = '/staff/managers';

  // ── Salaries ────────────────────────────
  static const String salaries = '/salaries';
  static const String salariesMy = '/salaries/my';
  static const String salariesSummary = '/salaries/summary';
  static const String salariesAdjustments = '/salaries/adjustments';

  // ── Leave Requests ──────────────────────
  static const String leaveRequests = '/leave-requests';
  static const String leaveRequestsMy = '/leave-requests/my';
  static const String leaveRequestsPending = '/leave-requests/pending';
  static const String leaveRequestsSummary = '/leave-requests/summary';

  // ── Attendance ──────────────────────────
  static const String attendanceScanAuth = '/attendance/scan/authenticate';
  static const String attendanceScanCheckIn = '/attendance/scan/check-in';
  static const String attendanceScanCheckOut = '/attendance/scan/check-out';
  static const String attendanceOfficeQr = '/attendance/office-qr';
  static const String attendanceMy = '/attendance/my';
  static const String attendanceMonthlyStats = '/attendance/my/monthly-stats';
  static const String attendanceSummaryToday = '/attendance/summary/today';
  static const String attendanceDateRange = '/attendance/date-range';
  static const String attendance = '/attendance';

  // ── Suppliers ───────────────────────────
  static const String suppliers = '/suppliers';

  // ── Customers ───────────────────────────
  static const String customers = '/customers';

  // ── Inventory ───────────────────────────
  static const String categories = '/categories';
  static const String products = '/products';
  static const String stockMovements = '/stock-movements';

  // ── Invoices ────────────────────────────
  static const String invoices = '/invoices';

  // ── Audit Logs ──────────────────────────
  static const String auditLogs = '/audit-logs';

  // ── Notifications ───────────────────────
  static const String notifications = '/notifications';

  // ── Chat ────────────────────────────────
  static const String chat = '/chat';

  // ── System Settings ─────────────────────
  static const String systemSettings = '/system-settings';

  // ── Helper: build dynamic paths ─────────
  static String userById(int id) => '/auth/users/$id';
  static String userByUsername(String u) => '/auth/users/username/$u';
  static String deactivateUser(int id) => '/auth/users/$id/deactivate';
  static String activateUser(int id) => '/auth/users/$id/activate';
  static String resetPassword(int id) => '/auth/reset-password/$id';

  static String companyById(int id) => '/companies/$id';
  static String companyMedia(int id) => '/companies/$id/media';
  static String companyPlan(int id) => '/companies/$id/plan';
  static String companyStatus(int id) => '/companies/$id/status';

  static String roleById(int id) => '/roles/$id';
  static String departmentById(int id) => '/departments/$id';

  static String usersByCompany(int id) => '/users/$id';
  static String staffRoleById(int id) => '/staff-roles/$id';

  static String staffById(int id) => '/staff/$id';
  static String staffAvatar(int id) => '/staff/$id/avatar';
  static String staffByRole(int id) => '/staff/role/$id';
  static String staffByDept(int id) => '/staff/department/$id';
  static String staffByUser(int id) => '/staff/user/$id';

  static String salaryById(int id) => '/salaries/$id';
  static String salaryMarkPaid(int id) => '/salaries/$id/mark-paid';
  static String salaryAdjustments(int id) => '/salaries/$id/adjustments';
  static String adjustmentById(int id) => '/salaries/adjustments/$id';

  static String leaveById(int id) => '/leave-requests/$id';
  static String leaveApprove(int id) => '/leave-requests/$id/approve';
  static String leaveReject(int id) => '/leave-requests/$id/reject';
  static String leaveCancel(int id) => '/leave-requests/$id/cancel';

  static String attendanceById(int id) => '/attendance/$id';

  static String supplierById(int id) => '/suppliers/$id';
  static String supplierAvatar(int id) => '/suppliers/$id/avatar';

  static String customerById(int id) => '/customers/$id';

  static String productById(int id) => '/products/$id';
  static String invoiceById(int id) => '/invoices/$id';
}
