import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/state_cart.dart';
import 'package:go_router/go_router.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_role_notifier.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/error_view.dart';
import '../widgets/role/staff_role_card.dart';
import '../../domain/entities/staff_role_entity.dart';

class StaffRoleScreen extends ConsumerWidget {
  const StaffRoleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final notifier = ref.read(staffRoleNotifierProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          'Staff Roles',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 19,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: false,
        backgroundColor: surface,
        surfaceTintColor: Pallets.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        shape: Border(bottom: BorderSide(color: border, width: 1)),
        iconTheme: IconThemeData(color: textPrimary),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: Pallets.brandGradient,
          boxShadow: [
            BoxShadow(
              color: Pallets.blurple.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => context.push(RouteNames.staffRoleForm),
          backgroundColor: Pallets.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            'Add Role',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: ref
          .watch(staffRoleNotifierProvider)
          .when(
            loading: () => Center(
              child: CircularProgressIndicator(color: Pallets.blurple),
            ),
            error: (e, _) =>
                ErrorView(message: '$e', onRetry: notifier.fetchAll),
            data: (roles) => roles.isEmpty
                ? _EmptyView(
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 90),
                    itemCount: roles.length + 1,
                    itemBuilder: (_, i) {
                      if (i == 0) {
                        return _RoleStats(
                          roles: roles,
                          surface: surface,
                          border: border,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                        );
                      }
                      return StaffRoleCard(role: roles[i - 1]);
                    },
                  ),
          ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
// ─── Stats header ───────────────────────────────────────────────────────
////////////////////////////////////////////////////////////////////////////////

class _RoleStats extends StatelessWidget {
  final List<StaffRoleEntity> roles;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;

  const _RoleStats({
    required this.roles,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final total = roles.length;
    final managerRoles = roles.where((r) => r.isManager).length;

    // ✅ only average roles that actually have a salary set —
    // roles with baseSalary == 0 no longer drag the average down.
    final salaried = roles.where((r) => r.baseSalary > 0).toList();
    final avgSalary = salaried.isEmpty
        ? 0
        : salaried.map((r) => r.baseSalary).reduce((a, b) => a + b) /
              salaried.length;
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              icon: Icons.badge_outlined,
              label: 'Total Roles',
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
              icon: Icons.manage_accounts_outlined,
              label: 'Manager Roles',
              value: '$managerRoles',
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
              icon: Icons.attach_money_rounded,
              label: 'Avg. Salary',
              value: '\$${avgSalary.toStringAsFixed(0)}',
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

////////////////////////////////////////////////////////////////////////////////
// ─── Empty View ───────────────────────────────────────────────────────────
////////////////////////////////////////////////////////////////////////////////

class _EmptyView extends StatelessWidget {
  final Color textPrimary;
  final Color textSecondary;
  const _EmptyView({required this.textPrimary, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Pallets.infoTint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.manage_accounts_outlined,
              size: 40,
              color: Pallets.blurple,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No staff roles found',
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Create a role first, then add staff.',
            style: TextStyle(color: textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: Pallets.blurple,
              side: const BorderSide(color: Pallets.blurple),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            icon: const Icon(Icons.people),
            label: const Text('Go to Staff'),
          ),
        ],
      ),
    );
  }
}
