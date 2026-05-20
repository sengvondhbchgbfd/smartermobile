import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/error_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/staff_form.dart';

class StaffDetailScreen extends ConsumerStatefulWidget {
  final int staffId;
  const StaffDetailScreen({super.key, required this.staffId});

  @override
  ConsumerState<StaffDetailScreen> createState() => _StaffDetailScreenState();
}

class _StaffDetailScreenState extends ConsumerState<StaffDetailScreen> {
  void _refresh() =>
      ref.read(staffNotifierProvider.notifier).fetchById(widget.staffId);

  @override
  void initState() {
    super.initState();
    Future.microtask(_refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Detail'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
        ],
      ),
      body: ref
          .watch(staffNotifierProvider)
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => ErrorView(message: '$e', onRetry: _refresh),
            data: (list) => list.isEmpty
                ? const Center(child: Text('Staff not found.'))
                : _StaffDetailBody(staff: list.first),
          ),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _StaffDetailBody extends ConsumerWidget {
  final StaffEntity staff;
  const _StaffDetailBody({required this.staff});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AvatarSection(staff: staff, onPickAvatar: () => _pickAvatar(ref)),
          const SizedBox(height: 24),
          _InfoCard(
            title: 'Personal Info',
            rows: [
              _InfoRow(Icons.person, 'Name', staff.name),
              _InfoRow(Icons.wc, 'Gender', staff.gender),
              _InfoRow(Icons.cake, 'Date of Birth', staff.dateOfBirth),
              _InfoRow(Icons.location_on, 'Address', staff.address),
            ],
          ),
          const SizedBox(height: 12),
          _InfoCard(
            title: 'Contact',
            rows: [
              _InfoRow(Icons.email, 'Email', staff.email),
              _InfoRow(Icons.phone, 'Phone', staff.phone),
            ],
          ),
          if (staff.staffRole != null) ...[
            const SizedBox(height: 12),
            _InfoCard(
              title: 'Role',
              rows: [
                _InfoRow(Icons.work, 'Role Name', staff.staffRole!.roleName),
                _InfoRow(
                  Icons.attach_money,
                  'Base Salary',
                  '\$${staff.staffRole!.baseSalary.toStringAsFixed(2)}',
                ),
                _InfoRow(
                  Icons.manage_accounts,
                  'Is Manager',
                  staff.staffRole!.isManager ? 'Yes' : 'No',
                ),
              ],
            ),
          ],
          if (staff.createdAt != null) ...[
            const SizedBox(height: 12),
            _InfoCard(
              title: 'Meta',
              rows: [
                _InfoRow(
                  Icons.calendar_today,
                  'Joined',
                  staff.createdAt!.toLocal().toString(),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          _ActionButtons(
            onEdit: () => _showEditForm(context),
            onDelete: () => _confirmDelete(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAvatar(WidgetRef ref) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    await ref
        .read(staffNotifierProvider.notifier)
        .updateAvatar(staff.id!, File(picked.path));
  }

  void _showEditForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: StaffForm(existing: staff),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Staff'),
        content: Text('Delete "${staff.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(staffNotifierProvider.notifier).delete(staff.id!);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ─── Avatar Section ───────────────────────────────────────────────────────────

class _AvatarSection extends StatelessWidget {
  final StaffEntity staff;
  final VoidCallback onPickAvatar;
  const _AvatarSection({required this.staff, required this.onPickAvatar});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 52,
            backgroundImage: staff.avatarUrl != null
                ? NetworkImage(staff.avatarUrl!)
                : null,
            child: staff.avatarUrl == null
                ? Text(
                    staff.name[0].toUpperCase(),
                    style: const TextStyle(fontSize: 36),
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onPickAvatar,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Info Card ────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final String title;
  final List<_InfoRow> rows;
  const _InfoCard({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...rows,
          ],
        ),
      ),
    );
  }
}

// ─── Info Row ─────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value ?? 'N/A',
                  style: TextStyle(
                    color: value != null
                        ? Colors.black87
                        : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action Buttons ───────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _ActionButtons({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
            onPressed: onEdit,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }
}
