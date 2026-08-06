import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/widgets/shimmer/app_list_shimmer.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/dashboard_stats.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/error_view.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/staff/staff_card.dart';
import 'package:go_router/go_router.dart';

class StaffScreen extends ConsumerStatefulWidget {
  const StaffScreen({super.key});
  @override
  ConsumerState<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends ConsumerState<StaffScreen> {
  bool _managersOnly = false;

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final notifier = ref.read(staffNotifierProvider.notifier);
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

    // ── Switch source based on filter ──
    final asyncList = _managersOnly
        ? ref.watch(staffManagersProvider)
        : ref.watch(staffNotifierProvider);
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: bg,
      appBar: _buildAppBar(
        notifier: notifier,
        context: context,
        surface: surface,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        border: border,
      ),
      floatingActionButton: _buildFab(context),
      body: Column(
        children: [
          if (_managersOnly) _buildFilterBanner(textSecondary, surface, border),
          Expanded(
            child: asyncList.when(
              loading: () => const AppListShimmer(itemCount: 6),
              error: (e, _) => ErrorView(
                message: '$e',
                onRetry: () => _managersOnly
                    ? ref.invalidate(staffManagersProvider)
                    : notifier.fetchAll(),
              ),
              data: (list) => list.isEmpty
                  ? _buildEmptyState(context, textPrimary, textSecondary)
                  : RefreshIndicator(
                      color: Pallets.blurple,
                      backgroundColor: surface,
                      onRefresh: () => _managersOnly
                          ? ref.refresh(staffManagersProvider.future)
                          : notifier.fetchAll(),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 4, bottom: 90),
                        itemCount: list.length + (_managersOnly ? 0 : 1),
                        itemBuilder: (_, i) {
                          if (!_managersOnly && i == 0) {
                            return DashboardStats(
                              list: list,
                              surface: surface,
                              border: border,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                            );
                          }
                          final index = _managersOnly ? i : i - 1;
                          return StaffCard(staff: list[index]);
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Widget _buildFilterBanner(Color textSecondary, Color surface, Color border) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Pallets.infoTint,
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.filter_alt_rounded,
            size: 15,
            color: Pallets.blurple,
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Showing managers only',
              style: TextStyle(fontSize: 12.5, color: Pallets.blurple),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _managersOnly = false),
            child: const Text(
              'Clear',
              style: TextStyle(
                fontSize: 12.5,
                color: Pallets.blurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  PreferredSizeWidget _buildAppBar({
    required dynamic notifier,
    required BuildContext context,
    required Color surface,
    required Color textPrimary,
    required Color textSecondary,
    required Color border,
  }) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: surface,
      surfaceTintColor: Pallets.transparent,
      centerTitle: false,
      titleSpacing: 20,
      shape: Border(bottom: BorderSide(color: border, width: 1)),
      title: Text(
        'Staff',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert_rounded, color: textPrimary),
          color: surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: border),
          ),
          onSelected: (value) {
            if (value == 'managers') setState(() => _managersOnly = true);
            if (value == 'roles') context.push(RouteNames.staffRoles);
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'managers',
              child: Row(
                children: [
                  Icon(
                    Icons.people_outline_rounded,
                    size: 18,
                    color: textSecondary,
                  ),
                  const SizedBox(width: 10),
                  Text('Managers', style: TextStyle(color: textPrimary)),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'roles',
              child: Row(
                children: [
                  Icon(
                    Icons.manage_accounts_outlined,
                    size: 18,
                    color: textSecondary,
                  ),
                  const SizedBox(width: 10),
                  Text('Staff Roles', style: TextStyle(color: textPrimary)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Widget _buildFab(BuildContext context) {
    return Container(
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
        onPressed: () => _showForm(context, null),
        backgroundColor: Pallets.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        icon: const Icon(Icons.add_rounded, color: Pallets.onAccent),
        label: const Text(
          'Add Staff',
          style: TextStyle(
            color: Pallets.onAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Widget _buildEmptyState(
    BuildContext context,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Pallets.infoTint,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _managersOnly
                  ? Icons.verified_user_outlined
                  : Icons.people_alt_outlined,
              size: 40,
              color: Pallets.blurple,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _managersOnly ? 'No managers found' : 'No staff found',
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _managersOnly
                ? 'No staff are currently marked as managers.'
                : 'Add your first team member to get started.',
            style: TextStyle(color: textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => _showForm(context, null),
            style: OutlinedButton.styleFrom(
              foregroundColor: Pallets.blurple,
              side: const BorderSide(color: Pallets.blurple),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Add Staff'),
          ),
        ],
      ),
    );
  }

  void _showForm(BuildContext context, StaffEntity? existing) {
    context.push(RouteNames.staffForm, extra: existing);
  }
}
