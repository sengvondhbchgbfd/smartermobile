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
  static const String staffRoles = '/staff-roles/';

  // ── Staff ───────────────────────────────
  static const String staff = '/staff/';
  static const String staffMy = '/staff/my';
  static const String staffManagers = '/staff/managers';

  // ── Salaries ────────────────────────────
  static const String salaries = '/salaries/';
  static const String salariesGroup = "/salaries/group/staff";
  static const String salariesMy = '/salaries/my';
  static const String salariesSummary = '/salaries/summary';
  static const String salariesAdjustments = '/salaries/adjustments';

  // ── Leave Requests ──────────────────────
  static const String leaveRequests = '/leave-requests/';
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

  // ── Attendance Settings ─────────────────
  static const String attendanceSettings = '/attendance-settings';
  static const String attendanceSettingCreate = '/attendance-settings/';

  // ── Suppliers ───────────────────────────
  static const String suppliers = '/suppliers/';

  // ── Supplier Product Prices ─────────────

  static const String supplierPrices = '/supplier-prices/';
  static String supplierPriceById(int priceId) => '/supplier-prices/$priceId';

  // ── Customers ───────────────────────────
  static const String customers = '/customers/';

  // ── Inventory: Categories ────────────────
  static const String categories = '/categories/';

  // ── Inventory: Products ──────────────────

  static const String products = '/products/';

  // ── Inventory: Stock Movements ───────────
  static const String stockMovements = '/stock-movements/';

  // ── Invoices ────────────────────────────
  static const String invoices = '/invoices/';

  // ── Audit Logs ──────────────────────────
  static const String auditLogs = '/audit-logs/';

  // ── Notifications ───────────────────────
  static const String notifications = '/notifications';
  static const String notificationsMy = '/notifications/my';
  static const String notificationsMySummary = '/notifications/my/summary';
  static const String notificationsMyReadAll = '/notifications/my/read-all';
  static const String notificationsMyBulkRead = '/notifications/my/bulk-read';
  static const String notificationsClearRead = '/notifications/my/clear-read';

  // ── Chat ────────────────────────────────
  static const String chatGroups = '/chat/groups';
  static const String chatGroupsMy = '/chat/groups/my';
  static const String chatDirect = '/chat/direct';

  // ── System Settings ─────────────────────
  static const String systemSettings = '/system-settings';

  // ─────────────────────────────────────────────────────────────────────────
  // Dynamic helpers
  // ─────────────────────────────────────────────────────────────────────────

  // Auth
  static String userById(int id) => '/auth/users/$id';
  static String userByUsername(String u) => '/auth/users/username/$u';
  static String deactivateUser(int id) => '/auth/users/$id/deactivate';
  static String activateUser(int id) => '/auth/users/$id/activate';
  static String resetPassword(int id) => '/auth/reset-password/$id';

  // Company
  static String companyById(int id) => '/companies/$id';
  static String companyMedia(int id) => '/companies/$id/media';
  static String companyPlan(int id) => '/companies/$id/plan';
  static String companyStatus(int id) => '/companies/$id/status';

  // Roles & Departments
  static String roleById(int id) => '/roles/$id';
  static String departmentById(int id) => '/departments/$id';

  // Users & Staff
  static String usersByCompany(int id) => '/users/$id';
  static String staffRoleById(int id) => '/staff-roles/$id';
  static String staffById(int id) => '/staff/$id';
  static String staffAvatar(int id) => '/staff/$id/avatar';
  static String staffByRole(int id) => '/staff/role/$id';
  static String staffByDept(int id) => '/staff/department/$id';
  static String staffByUser(int id) => '/staff/user/$id';

  // Salaries
  static String salaryById(int id) => '/salaries/$id';
  static String salaryMarkPaid(int id) => '/salaries/$id/mark-paid';
  static String salaryAdjustments(int id) => '/salaries/$id/adjustments';
  static const createAdjustment = '/salaries/adjustments';
  static String adjustmentById(int id) => '/salaries/adjustments/$id';

  // Leave
  static String leaveById(int id) => '/leave-requests/$id';
  static String leaveApprove(int id) => '/leave-requests/$id/approve';
  static String leaveReject(int id) => '/leave-requests/$id/reject';
  static String leaveCancel(int id) => '/leave-requests/$id/cancel';

  // Attendance
  static String attendanceById(int id) => '/attendance/$id';

  // Suppliers
  static String supplierById(int id) => '/suppliers/$id';
  static String supplierAvatar(int id) => '/suppliers/$id/avatar';

  // Supplier Product Prices

  // Customers
  static String customerById(int id) => '/customers/$id';
  static String customerAvatar(int id) => '/customers/$id/avatar';

  // Categories
  static String categoryById(int id) => '/categories/$id';
  static String categoryImage(int id) => '/categories/$id/image';

  // Products
  static String productById(int id) => '/products/$id';
  static String productImages(int id) => '/products/$id/images';
  static String productImageById(int productId, int imageId) =>
      '/products/$productId/images/$imageId';
  static String productImageSetPrimary(int productId, int imageId) =>
      '/products/$productId/images/$imageId/set-primary';

  // Product Variants

  static String productVariants(int? productId) =>
      '/products/$productId/variants/';

  static String productVariantById(int productId, int variantId) =>
      '/products/$productId/variants/$variantId';

  static String variantImages(int productId, int variantId) =>
      '/products/$productId/variants/$variantId/images';
  static String variantImageById(int productId, int variantId, int imageId) =>
      '/products/$productId/variants/$variantId/images/$imageId';
  static String variantImageSetPrimary(
    int productId,
    int variantId,
    int imageId,
  ) => '/products/$productId/variants/$variantId/images/$imageId/set-primary';

  // Stock Movements
  static String stockMovementById(int id) => '/stock-movements/$id';

  // Invoices
  static String invoiceById(int id) => '/invoices/$id';
  static String invoiceAttachments(int id) => '/invoices/$id/attachments';
  static String invoiceAttachmentById(int invoiceId, int attachmentId) =>
      '/invoices/$invoiceId/attachments/$attachmentId';

  // Notifications
  static String notificationById(int id) => '/notifications/my/$id';
  static String notificationMarkRead(int id) => '/notifications/my/$id/read';

  // Chat
  static String chatGroupById(int id) => '/chat/groups/$id';
  static String chatGroupMembers(int id) => '/chat/groups/$id/members';
  static String chatGroupMemberById(int groupId, int staffId) =>
      '/chat/groups/$groupId/members/$staffId';
  static String chatGroupOnline(int id) => '/chat/groups/$id/online';
  static String chatGroupMessages(int id) => '/chat/groups/$id/messages';
  static String chatGroupImages(int id) => '/chat/groups/$id/images';
  static String chatGroupVideos(int id) => '/chat/groups/$id/videos';
  static String chatGroupAudio(int id) => '/chat/groups/$id/audio';
  static String chatGroupVoice(int id) => '/chat/groups/$id/voice';
  static String chatGroupFiles(int id) => '/chat/groups/$id/files';
  static String chatMessageReadAll(int id) =>
      '/chat/groups/$id/messages/read-all';
  static String chatMessageUnreadCount(int id) =>
      '/chat/groups/$id/messages/unread-count';
  static String chatMessageById(int groupId, int messageId) =>
      '/chat/groups/$groupId/messages/$messageId';
  static String chatMessageRead(int messageId) =>
      '/chat/groups/messages/$messageId/read';

  // WebSocket
  static String chatWs(int groupId) => '/ws/chat/$groupId';
}
