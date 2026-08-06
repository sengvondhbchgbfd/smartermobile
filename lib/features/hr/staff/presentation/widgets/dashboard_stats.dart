

import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/state_cart.dart';

class DashboardStats extends StatelessWidget {
  final List<StaffEntity> list;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;

  const DashboardStats({super.key, 
    required this.list,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final total = list.length;
    final managers = list.where((s) => s.staffRole?.isManager == true).length;
    final roles = list.map((s) => s.staffRoleId).toSet().length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              icon: Icons.groups_2_rounded,
              label: 'Total Staff',
              value: '$total',
              color: Pallets.blurple,
              tint: Pallets.infoTint,
              surface: surface,
              border: border,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: StatCard(
              icon: Icons.verified_user_outlined,
              label: 'Managers',
              value: '$managers',
              color: Pallets.warning,
              tint: Pallets.warningTint,
              surface: surface,
              border: border,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: StatCard(
              icon: Icons.badge_outlined,
              label: 'Roles',
              value: '$roles',
              color: Pallets.success,
              tint: Pallets.successTint,
              surface: surface,
              border: border,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}












