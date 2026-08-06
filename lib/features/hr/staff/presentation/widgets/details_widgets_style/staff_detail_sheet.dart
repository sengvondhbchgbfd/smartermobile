import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';

class StaffDetailSheet extends StatelessWidget {
  final StaffEntity staff;
  const StaffDetailSheet({super.key, required this.staff});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 36,
              backgroundColor: Pallets.infoTint,
              backgroundImage: staff.avatarUrl != null
                  ? NetworkImage(staff.avatarUrl!)
                  : null,
              child: staff.avatarUrl == null
                  ? Text(
                      staff.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 28,
                        color: Pallets.blurple,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              staff.name,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _DetailRow('Name', staff.name),
          _DetailRow('Email', staff.email),
          _DetailRow('Phone', staff.phone),
          _DetailRow('Gender', staff.gender),
          _DetailRow('Date of Birth', staff.dateOfBirth),
          _DetailRow('Address', staff.address),
          if (staff.staffRole != null)
            _DetailRow('Role', staff.staffRole!.roleName),
          if (staff.createdAt != null)
            _DetailRow('Joined', staff.createdAt!.toLocal().toString()),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String? value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
                color: textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 13.5,
                color: value != null
                    ? textPrimary
                    : textSecondary.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
