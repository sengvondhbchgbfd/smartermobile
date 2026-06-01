import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/error_view.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/staff_card.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/staff_form.dart';
import 'package:go_router/go_router.dart';

class StaffScreen extends ConsumerWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(staffNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff'),
        actions: [
          /////////////////////////////////
          ///
          /////////////////////////////////
          IconButton(
            icon: const Icon(Icons.manage_accounts),
            tooltip: 'Staff Roles',
            onPressed: () => context.push(RouteNames.staffRoles),
          ),

          ////////////////////////////
          ///
          ///////////////////////////
          IconButton(
            icon: const Icon(Icons.people_outline),
            tooltip: 'Managers',
            onPressed: notifier.fetchManagers,
          ),
          /////////////////////////////
          ///
          /////////////////////////////
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: notifier.fetchAll,
          ),

          /////////////////////////////////////
          ///
          //////////////////////////////////////
        ],
      ),

      /////////////////////////////////////////
      ///
      ////////////////////////////////////////
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: const Icon(Icons.add),
      ),

      ///////////////////////////////////////
      ///
      //////////////////////////////////////
      body: ref
          .watch(staffNotifierProvider)
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                ErrorView(message: '$e', onRetry: notifier.fetchAll),
            data: (list) => list.isEmpty
                ? const Center(child: Text('No staff found.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: list.length,
                    itemBuilder: (_, i) => StaffCard(staff: list[i]),
                  ),
          ),
    );
  }
  ///////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////

  void _showForm(BuildContext context, StaffEntity? existing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: StaffForm(
          existing: existing,
          onGoToRoles: () => context.go(RouteNames.staffRoles),
        ),
      ),
    );
  }

  /////////////////////////////////////////////
  ///
  /////////////////////////////////////////////
}
