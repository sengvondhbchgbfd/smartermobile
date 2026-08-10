import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

//////////////////////////////////////////////////////////////////////////////
// ── Permission metadata: code → human-readable info ─────────────────────
//////////////////////////////////////////////////////////////////////////////

class _PermissionInfo {
  final String label;
  final String description;
  final IconData icon;
  final String category;

  const _PermissionInfo({
    required this.label,
    required this.description,
    required this.icon,
    required this.category,
  });
}

const Map<String, _PermissionInfo> _permissionCatalog = {
  'read_own_profile': _PermissionInfo(
    label: 'View Own Profile',
    description: 'See your personal profile information',
    icon: Icons.person_outline_rounded,
    category: 'Profile',
  ),
  'view_own_profile': _PermissionInfo(
    label: 'View Own Profile',
    description: 'See your personal profile information',
    icon: Icons.person_outline_rounded,
    category: 'Profile',
  ),

  // Attendance
  'view_own_attendance': _PermissionInfo(
    label: 'View Your Attendance',
    description: 'Check your own clock-in and clock-out history',
    icon: Icons.access_time_rounded,
    category: 'Attendance',
  ),
  'view_team_attendance': _PermissionInfo(
    label: 'View Team Attendance',
    description: "See your team's attendance records",
    icon: Icons.groups_2_outlined,
    category: 'Attendance',
  ),
  'manage_attendance_settings': _PermissionInfo(
    label: 'Manage Attendance Settings',
    description: 'Configure company-wide attendance rules',
    icon: Icons.settings_suggest_outlined,
    category: 'Attendance',
  ),

  // Leave
  'request_leave': _PermissionInfo(
    label: 'Request Leave',
    description: 'Submit your own time-off requests',
    icon: Icons.event_available_outlined,
    category: 'Leave',
  ),
  'approve_leave': _PermissionInfo(
    label: 'Approve Leave',
    description: "Approve or reject your team's leave requests",
    icon: Icons.fact_check_outlined,
    category: 'Leave',
  ),
  'view_team_leave': _PermissionInfo(
    label: 'View Team Leave',
    description: "See your team's leave history and balances",
    icon: Icons.calendar_month_outlined,
    category: 'Leave',
  ),

  // Salary
  'view_own_salary': _PermissionInfo(
    label: 'View Your Salary',
    description: 'See your own pay and payslip details',
    icon: Icons.receipt_long_outlined,
    category: 'Salary',
  ),
  'view_team_salary': _PermissionInfo(
    label: 'View Team Salary',
    description: "See your team's salary information",
    icon: Icons.payments_outlined,
    category: 'Salary',
  ),
  'manage_salary': _PermissionInfo(
    label: 'Manage Salary',
    description: 'Create, edit, and process payroll for staff',
    icon: Icons.account_balance_wallet_outlined,
    category: 'Salary',
  ),

  // Staff / Users
  'view_users': _PermissionInfo(
    label: 'View Staff Directory',
    description: 'Browse the list of staff and their roles',
    icon: Icons.badge_outlined,
    category: 'Staff',
  ),
  'manage_staff': _PermissionInfo(
    label: 'Manage Staff',
    description: 'Add, edit, or remove staff members',
    icon: Icons.manage_accounts_outlined,
    category: 'Staff',
  ),
  'manage_users': _PermissionInfo(
    label: 'Manage User Accounts',
    description: 'Create and manage login accounts and access',
    icon: Icons.admin_panel_settings_outlined,
    category: 'Staff',
  ),
  'manage_roles': _PermissionInfo(
    label: 'Manage Roles',
    description: 'Create roles and assign permissions to them',
    icon: Icons.security_outlined,
    category: 'Staff',
  ),
  'manage_departments': _PermissionInfo(
    label: 'Manage Departments',
    description: 'Create and organize company departments',
    icon: Icons.account_tree_outlined,
    category: 'Staff',
  ),

  // Company
  'view_company': _PermissionInfo(
    label: 'View Company Info',
    description: "See your company's profile and details",
    icon: Icons.apartment_outlined,
    category: 'Company',
  ),
  'manage_company': _PermissionInfo(
    label: 'Manage Company',
    description: "Edit your company's profile and settings",
    icon: Icons.domain_outlined,
    category: 'Company',
  ),
};

const List<String> _categoryOrder = [
  'Profile',
  'Attendance',
  'Leave',
  'Salary',
  'Staff',
  'Company',
];

//////////////////////////////////////////////////////////////////////////////
// ── Permissions Card ──────────────────────────────────────────────────────
//////////////////////////////////////////////////////////////////////////////

class PermissionsCard extends StatelessWidget {
  final List<String> permissions;
  const PermissionsCard({super.key, required this.permissions});

  bool get _isSuperuser => permissions.contains('*');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;

    if (_isSuperuser) {
      return _SuperuserBanner(
        surface: surface,
        border: border,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      );
    }

    // Group known permissions by category, preserving catalog order.
    final grouped = <String, List<String>>{};
    final unknown = <String>[];

    for (final code in permissions) {
      final info = _permissionCatalog[code];
      if (info == null) {
        unknown.add(code);
        continue;
      }
      grouped.putIfAbsent(info.category, () => []).add(code);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final category in _categoryOrder)
          if (grouped[category] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CategoryGroup(
                title: category,
                codes: grouped[category]!,
                surface: surface,
                border: border,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
            ),
        if (unknown.isNotEmpty)
          _CategoryGroup(
            title: 'Other',
            codes: unknown,
            surface: surface,
            border: border,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            fallbackLabel: true,
          ),
      ],
    );
  }
}

//////////////////////////////////////////////////////////////////////////////
// ── Superuser banner — instead of listing every permission ──────────────
//////////////////////////////////////////////////////////////////////////////

class _SuperuserBanner extends StatelessWidget {
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;

  const _SuperuserBanner({
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: Pallets.brandGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Full Access',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'You have unrestricted access to every feature in this company.',
                  style: TextStyle(color: Colors.white, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////
// ── One category section (e.g. "Salary") ──────────────────────────────────
//////////////////////////////////////////////////////////////////////////////

class _CategoryGroup extends StatelessWidget {
  final String title;
  final List<String> codes;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final bool fallbackLabel;

  const _CategoryGroup({
    required this.title,
    required this.codes,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    this.fallbackLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: Pallets.gradient2,
              ),
            ),
          ),
          for (int i = 0; i < codes.length; i++) ...[
            _PermissionRow(
              code: codes[i],
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              fallbackLabel: fallbackLabel,
            ),
            if (i != codes.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(height: 1, color: border),
              ),
          ],
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////
// ── One permission row, with icon + friendly label + description ────────
//////////////////////////////////////////////////////////////////////////////

class _PermissionRow extends StatelessWidget {
  final String code;
  final Color textPrimary;
  final Color textSecondary;
  final bool fallbackLabel;

  const _PermissionRow({
    required this.code,
    required this.textPrimary,
    required this.textSecondary,
    this.fallbackLabel = false,
  });

  String _titleCase(String raw) => raw
      .split('_')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  @override
  Widget build(BuildContext context) {
    final info = _permissionCatalog[code];
    final label = info?.label ?? _titleCase(code);
    final description = info?.description;
    final icon = info?.icon ?? Icons.check_circle_outline_rounded;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Pallets.gradient2.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: Pallets.gradient2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(fontSize: 11.5, color: textSecondary),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
