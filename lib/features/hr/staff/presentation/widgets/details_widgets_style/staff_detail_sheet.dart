import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';

class StaffDetailSheet extends StatelessWidget {
  final StaffEntity staff;
  const StaffDetailSheet({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 36,
              backgroundImage: staff.avatarUrl != null
                  ? NetworkImage(staff.avatarUrl!)
                  : null,
              child: staff.avatarUrl == null
                  ? Text(
                      staff.name[0].toUpperCase(),
                      style: const TextStyle(fontSize: 28),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16),
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: textTheme.bodyMedium?.copyWith(
                color: value != null
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
