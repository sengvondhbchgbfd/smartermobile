import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';

class AuthManagerTile extends StatelessWidget {
  final StaffEntity staff;
  const AuthManagerTile({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),

      //////////////////////////////////////////////////////
      ///
      /////////////////////////////////////////////////////
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: staff.avatarUrl != null
                ? NetworkImage(staff.avatarUrl!)
                : null,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: staff.avatarUrl == null
                ? Text(
                    staff.name[0].toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          /////////////////////////////////////////////////////
          ///
          ////////////////////////////////////////////////////
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      staff.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'You',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                if (staff.staffRole?.roleName != null)
                  Text(
                    staff.staffRole!.roleName,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
              ],
            ),
          ),
          Icon(Icons.lock_outline, size: 16, color: Colors.blue.shade300),
        ],
      ),
    );
  }
}
