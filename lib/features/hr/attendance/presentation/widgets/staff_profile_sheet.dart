import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/staff/avatar_cart.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/staff/contact_tile_cart.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/staff/leave_balance_cart.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/staff/section_header.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/staff/state_cart.dart';

class StaffProfile {
  const StaffProfile({
    required this.id,
    required this.name,
    this.photoUrl,
    this.jobTitle,
    this.department,
    this.phone,
    this.email,
    this.presentDays = 0,
    this.lateDays = 0,
    this.absentDays = 0,
    this.leaveBalance = 0,
    this.totalLeaveDays = 0,
  });

  final int id;
  final String name;
  final String? photoUrl;
  final String? jobTitle;
  final String? department;
  final String? phone;
  final String? email;
  final int presentDays;
  final int lateDays;
  final int absentDays;
  final int leaveBalance;
  final int totalLeaveDays;
}

// ── Widget ─────────────────────────────────────────────────────────────────

class StaffProfileSheet extends StatelessWidget {
  const StaffProfileSheet({super.key, required this.profile});

  final StaffProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          children: [
            // ── Drag handle ───────────────────────────────────────────────
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ── Avatar + name ─────────────────────────────────────────────
            Center(
              child: Column(
                children: [
                  Avatar(url: profile.photoUrl, name: profile.name, radius: 40),
                  const SizedBox(height: 12),
                  Text(
                    profile.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (profile.jobTitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      profile.jobTitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                  if (profile.department != null) ...[
                    const SizedBox(height: 4),
                    _Chip(label: profile.department!),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Contact info ──────────────────────────────────────────────
            SectionHeader(title: 'Contact'),
            const SizedBox(height: 8),
            if (profile.phone != null)
              ContactTile(
                icon: Icons.phone_outlined,
                value: profile.phone!,
                color: Colors.green,
              ),
            if (profile.email != null)
              ContactTile(
                icon: Icons.email_outlined,
                value: profile.email!,
                color: Colors.blue,
              ),

            const SizedBox(height: 24),

            // ── This-month attendance summary ─────────────────────────────
            SectionHeader(title: 'This Month'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Present',
                    value: profile.presentDays,
                    color: Colors.green,
                    icon: Icons.check_circle_outline,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatCard(
                    label: 'Late',
                    value: profile.lateDays,
                    color: Colors.orange,
                    icon: Icons.access_time,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatCard(
                    label: 'Absent',
                    value: profile.absentDays,
                    color: Colors.red,
                    icon: Icons.cancel_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            ///////////////////////////////////////////////////////////////////
            // ── Leave balance ─────────────────────────────────────────────
            //////////////////////////////////////////////////////////////////
            SectionHeader(title: 'Leave Balance'),
            const SizedBox(height: 8),
            LeaveBalanceCard(
              used: profile.totalLeaveDays - profile.leaveBalance,
              remaining: profile.leaveBalance,
              total: profile.totalLeaveDays,
            ),

            const SizedBox(height: 16),

            //////////////////////////////////////////////////////////////////
            // ── Close ─────────────────────────────────────────────────────
            //////////////////////////////////////////////////////////////////
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.blue.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
