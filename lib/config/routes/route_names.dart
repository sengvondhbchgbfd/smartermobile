class RouteNames {
  // ── Core ─────────────────────────────
  static const splash = "/";
  static const onboarding = "/onboarding";
  static const setupWizard = "/setup-wizard";

  // ── Auth ─────────────────────────────
  static const login = "/login";
  static const register = "/register";

  // ── Main ─────────────────────────────
  static const dashboard = "/dashboard";
  static const home = "/home";
  static const profile = "/profile";
  static const editedProfile = "/profile/edit";
  static const settings = "/settings";

  // ── Users ────────────────────────────
  static const users = "/users";
  static const userDetail = "/users/:id";
  static const createUser = '/users/create-user';
  static const createRole = '/users/create-role';
  static const createDepartment = '/users/create-department';
  static const updateUser = '/users/update-user';
  static const userDetailPage = '/users/detail';
  static const filteredUsers = '/users/filtered';

  // ── Company ──────────────────────────
  static const companies = "/companies";
  static const companyDetail = "/companies/:id";
  static const companyEdit = "/companies/:id/edit"; // ← added

  // ── HR Staff ──────────────────────────
  static const staffRoles = "/staff-roles";

  static const staff = "/staff";

  static const staffDetail = "/staff/:id";
  static const staffManagers = "/staff/managers";

  // ── Departments ──────────────────────
  static const departments = "/departments";
  static const departmentDetail = "/departments/:id";

  // ── Salaries ─────────────────────────
  static const salaries = "/salaries";
  static const salaryDetail = "/salaries/:id";
  static const salarySummary = "/salaries/summary";
  static const salaryMy = "/salaries/my";
  static const salaryAdjustments = '/salaries/:id/adjustments';

  // ── Leave Requests ───────────────────
  static const leaves = "/leave-requests";
  static const leaveDetail = "/leave-requests/:id";
  static const leaveMy = "/leave-requests/my";
  static const leavePending = "/leave-requests/pending";

  // ── Attendance ───────────────────────
  static const attendance = "/attendance";

  /// STAFF
  static const attendanceMy = "/attendance/my";
  static const attendanceMonthlyStats = "/attendance/my/monthly-stats";

  /// QR SCAN
  static const attendanceScanAuth = "/attendance/scan/authenticate";
  static const attendanceCheckIn = "/attendance/scan/check-in";
  static const attendanceCheckOut = "/attendance/scan/check-out";

  /// OFFICE QR
  static const attendanceOfficeQr = "/attendance/office-qr";
  static const attendanceOfficeQrImage = "/attendance/office-qr/image";

  /// MANAGER
  static const attendanceTodaySummary = "/attendance/summary/today";
  static const attendanceDateRange = "/attendance/date-range";
  static const attendanceDetail = "/attendance/:attendance_id";

  // ── Inventory ────────────────────────
  static const products = "/products";
  static const productDetail = "/products/:id";
  static const categories = "/categories";

  // ── Sales / Invoice ──────────────────
  static const invoices = "/invoices";
  static const invoiceDetail = "/invoices/:id";

  // ── Suppliers / Customers ────────────
  static const suppliers = "/suppliers";
  static const supplierDetail = "/suppliers/:id";
  static const customers = "/customers";
  static const customerDetail = "/customers/:id";

  // ── System ───────────────────────────
  static const notifications = "/notifications";
  static const chat = "/chat";
  static const auditLogs = "/audit-logs";
  static const systemSettings = "/system-settings";
}
