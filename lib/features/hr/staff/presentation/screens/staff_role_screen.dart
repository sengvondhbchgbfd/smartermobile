import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_role_notifier.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/error_view.dart';
import 'package:go_router/go_router.dart';
import '../widgets/staff_role_card.dart';
import '../widgets/staff_role_form.dart';
import '../../domain/entities/staff_role_entity.dart';

class StaffRoleScreen extends ConsumerWidget {
  const StaffRoleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(staffRoleNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Roles'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: notifier.fetchAll,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: const Icon(Icons.add),
      ),
      body: ref
          .watch(staffRoleNotifierProvider)
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                ErrorView(message: '$e', onRetry: notifier.fetchAll),
            data: (roles) => roles.isEmpty
                ? const _EmptyView()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: roles.length,
                    itemBuilder: (_, i) => StaffRoleCard(role: roles[i]),
                  ),
          ),
    );
  }

  void _showForm(BuildContext context, StaffRoleEntity? existing) {
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
}

// ─── Empty View ───────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.manage_accounts_outlined,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 12),
          const Text(
            'No staff roles found.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          const Text(
            'Create a role first, then add staff.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.people),
            label: const Text('Go to Staff'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
