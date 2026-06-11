import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_role_notifier.dart';
import '../../domain/entities/staff_role_entity.dart';
import 'staff_role_form.dart';

class StaffRoleCard extends ConsumerWidget {
  final StaffRoleEntity role;
  const StaffRoleCard({super.key, required this.role});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        isThreeLine: true,
        leading: _RoleAvatar(isManager: role.isManager),
        title: Text(role.roleName,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(role.description,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(
              'Base Salary: \$${role.baseSalary.toStringAsFixed(2)}',
              style: TextStyle(
                  color: Colors.green.shade700, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (role.isManager) const _ManagerBadge(),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _showForm(context, role),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  void _showForm(BuildContext context, StaffRoleEntity existing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: StaffRoleForm(existing: existing),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Role'),
        content: Text('Delete "${role.roleName}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(staffRoleNotifierProvider.notifier).delete(role.id!);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ─── Role Avatar ──────────────────────────────────────────────────────────────

class _RoleAvatar extends StatelessWidget {
  final bool isManager;
  const _RoleAvatar({required this.isManager});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor:
          isManager ? Colors.amber.shade100 : Colors.blue.shade100,
      child: Icon(
        isManager ? Icons.manage_accounts : Icons.person,
        color: isManager ? Colors.amber.shade800 : Colors.blue,
      ),
    );
  }
}

// ─── Manager Badge ────────────────────────────────────────────────────────────

class _ManagerBadge extends StatelessWidget {
  const _ManagerBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Manager',
        style: TextStyle(
          fontSize: 11,
          color: Colors.amber.shade800,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}