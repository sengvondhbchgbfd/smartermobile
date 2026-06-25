import 'package:flutter/material.dart';

class SettingDef {
  final String key;
  final String label;
  final IconData icon;
  final String? route;
  const SettingDef(this.key, this.label, this.icon, {this.route});
}

class SettingGroup {
  final String label;
  final List<SettingDef> items;
  const SettingGroup({required this.label, required this.items});
}

const kSettingGroups = [
  SettingGroup(
    label: 'APPEARANCE',
    items: [
      SettingDef(
        'dark_mode',
        'Dark Mode',
        Icons.dark_mode_outlined,
        route: '/settings/theme',
      ),
    ],
  ),

  // ← Add this new group
  SettingGroup(
    label: 'ATTENDANCE',
    items: [
      SettingDef(
        'attendance_office_location',
        'Office Location & Geofence',
        Icons.location_on_outlined,
        route: '/settings/attendance',
      ),
      SettingDef(
        'attendance_work_hours',
        'Work Hours & Thresholds',
        Icons.access_time_outlined,
        route: '/settings/attendance',
      ),
    ],
  ),

  SettingGroup(
    label: 'PAYROLL',
    items: [
      SettingDef(
        'currency_code',
        'Currency Code',
        Icons.attach_money_outlined,
        route: '/settings/payroll/currency',
      ),
      SettingDef(
        'payroll_day',
        'Payroll Day',
        Icons.calendar_today_outlined,
        route: '/settings/payroll/day',
      ),
      SettingDef(
        'overtime_rate_multiplier',
        'Overtime Rate',
        Icons.timer_outlined,
        route: '/settings/payroll/overtime',
      ),
    ],
  ),
  SettingGroup(
    label: 'LEAVE',
    items: [
      SettingDef(
        'annual_leave_days',
        'Annual Leave Days',
        Icons.event_available_outlined,
        route: '/settings/leave/annual',
      ),
      SettingDef(
        'sick_leave_days',
        'Sick Leave Days',
        Icons.sick_outlined,
        route: '/settings/leave/sick',
      ),
      SettingDef(
        'leave_approval_required',
        'Approval Required',
        Icons.approval_outlined,
        route: '/settings/leave/approval',
      ),
    ],
  ),
  SettingGroup(
    label: 'INVENTORY',
    items: [
      SettingDef(
        'low_stock_threshold',
        'Low Stock Threshold',
        Icons.inventory_2_outlined,
        route: '/settings/inventory/low-stock',
      ),
      SettingDef(
        'stock_movement_approval',
        'Movement Approval',
        Icons.rule_outlined,
        route: '/settings/inventory/movement-approval',
      ),
    ],
  ),
  SettingGroup(
    label: 'NOTIFICATIONS',
    items: [
      SettingDef(
        'notification_retention_days',
        'Retention Days',
        Icons.notifications_outlined,
        route: '/settings/notifications/retention',
      ),
      SettingDef(
        'push_notifications_enabled',
        'Push Notifications',
        Icons.mobile_friendly_outlined,
        route: '/settings/notifications/push',
      ),
    ],
  ),
  SettingGroup(
    label: 'COMPANY',
    items: [
      SettingDef(
        'company_timezone',
        'Timezone',
        Icons.schedule_outlined,
        route: '/settings/company/timezone',
      ),
      SettingDef(
        'company_language',
        'Language',
        Icons.language_outlined,
        route: '/settings/company/language',
      ),
      SettingDef(
        'max_staff_count',
        'Max Staff Count',
        Icons.groups_outlined,
        route: '/settings/company/max-staff',
      ),
    ],
  ),
];
