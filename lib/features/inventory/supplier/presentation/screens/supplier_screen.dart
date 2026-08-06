import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/utils/confirm_delete_dialog.dart';
import 'package:frontendmobile/core/utils/error_banner.dart';
import 'package:frontendmobile/core/widgets/alertmessage/app_snacker.dart';
import 'package:frontendmobile/core/widgets/shimmer/app_list_shimmer.dart';
import 'package:frontendmobile/features/inventory/supplier/presentation/screens/supplier_detail_screen.dart';
import 'package:frontendmobile/features/inventory/supplier/presentation/widgets/supplier_card.dart';
import 'package:frontendmobile/features/inventory/supplier/presentation/widgets/supplier_count.dart';
import 'package:frontendmobile/features/inventory/supplier/presentation/widgets/supplier_empty.dart';
import 'package:frontendmobile/features/inventory/supplier/presentation/widgets/supplier_form_screen.dart';
import 'package:collection/collection.dart';
import '../providers/supplier_provider.dart';


////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class SuppliersScreen extends ConsumerStatefulWidget {
  const SuppliersScreen({super.key});
  @override
  ConsumerState<SuppliersScreen> createState() => _SuppliersScreenState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _SuppliersScreenState extends ConsumerState<SuppliersScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(supplierNotifierProvider.notifier).loadAll(),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  void _openCreate() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SupplierFormScreen()));
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  void _openEdit(int id) {
    final supplier = ref
        .read(supplierNotifierProvider)
        .suppliers
        .firstWhereOrNull((s) => s.supplierId == id);
    if (supplier == null) {
      AppSnackBar.show(
        context,
        message: 'This supplier no longer exists. Pull to refresh.',
        type: SnackType.error,
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SupplierFormScreen(existing: supplier)),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void _openDetails(int supplierId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SupplierDetailScreen(supplierId: supplierId),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<void> _confirmDelete(int id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDeleteDialog(
        title: 'Delete Supplier',
        message:
            'Are you sure you want to delete "$name"? This cannot be undone.',
      ),
    );
    if (confirmed != true || !mounted) return;

    final ok = await ref.read(supplierNotifierProvider.notifier).delete(id);
    if (mounted) {
      AppSnackBar.show(
        context,
        message: ok
            ? 'Supplier "$name" deleted.'
            : 'Failed to delete supplier.',
        type: ok ? SnackType.success : SnackType.error,
      );
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surface = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final surfaceElevated = isDark
        ? Pallets.surfaceElevated
        : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final state = ref.watch(supplierNotifierProvider);
    final notifier = ref.read(supplierNotifierProvider.notifier);

    final q = _query.toLowerCase();
    final filtered = state.suppliers
        .where(
          (s) =>
              q.isEmpty ||
              s.name.toLowerCase().contains(q) ||
              (s.phone?.contains(_query) ?? false) ||
              (s.email?.toLowerCase().contains(q) ?? false),
        )
        .toList();

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: bg,
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.isCreating ? null : _openCreate,
        backgroundColor: Pallets.blurple,
        foregroundColor: Pallets.onAccent,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add supplier',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: Column(
        children: [
          //////////////////////////////////////////////////////////////////////
          // ── Gradient header ──────────────────────────────
          //////////////////////////////////////////////////////////////////////
          Container(
            decoration: const BoxDecoration(gradient: Pallets.brandGradient),
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top + 12,
              20,
              20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 20,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Suppliers',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    CountBadge(count: state.suppliers.length),
                  ],
                ),

                const SizedBox(height: 4),
                Text(
                  'Manage the vendors you buy stock from',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 18),
                ////////////////////////////////////////////////////////////////
                // ── Search field ──────────────────────────
                ////////////////////////////////////////////////////////////////
                Container(
                  //////////////////
                  ///
                  /////////////////
                  decoration: BoxDecoration(
                    color: surfaceElevated,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: border),
                  ),

                  //////////////////
                  ///
                  /////////////////
                  child: TextField(
                    controller: _searchCtrl,
                    style: TextStyle(color: textPrimary, fontSize: 15),
                    cursorColor: Pallets.blurple,
                    decoration: InputDecoration(
                      hintText: 'Search by name, phone, email',

                      //////////////////
                      ///
                      /////////////////
                      hintStyle: TextStyle(
                        color: textSecondary,
                        fontSize: 14.5,
                      ),

                      //////////////////
                      ///
                      /////////////////
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: textSecondary,
                        size: 21,
                      ),
                      //////////////////
                      ///
                      /////////////////
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                color: textSecondary,
                                size: 18,
                              ),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _query = '');
                              },
                            )
                          : null,
                      //////////////////
                      ///
                      /////////////////
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    //////////////////
                    ///
                    /////////////////
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
              ],
            ),
          ),

          if (state.error != null)
            ErrorBanner(message: state.error!, onDismiss: notifier.clearError),

          //////////////////////////////////////////////////////////////////////
          // ── List body ────────────────────────────────────
          //////////////////////////////////////////////////////////////////////
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
              ),
              child: state.isLoading && state.suppliers.isEmpty
                  ? const AppListShimmer(itemCount: 6)
                  : filtered.isEmpty
                  ? EmptyState(
                      query: _query,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    )
                  : RefreshIndicator(
                      color: Pallets.blurple,
                      onRefresh: notifier.loadAll,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                        itemCount: filtered.length,

                        ////////////////////////////////////////////////////////
                        ///
                        ////////////////////////////////////////////////////////
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final s = filtered[i];
                          return SupplierCard(
                            name: s.name,
                            phone: s.phone,
                            email: s.email,
                            isWorking: state.loadingIds.contains(s.supplierId),
                            surface: surface,
                            surfaceElevated: surfaceElevated,
                            border: border,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            onTap: () => _openDetails(s.supplierId),
                            onEdit: () => _openEdit(s.supplierId),
                            onDelete: () =>
                                _confirmDelete(s.supplierId, s.name),
                          );
                        },

                        ////////////////////////////////////////////////////////
                        ///
                        ////////////////////////////////////////////////////////
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
