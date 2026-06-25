import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/supplier_color.dart';
import 'package:frontendmobile/core/utils/confirm_delete_dialog.dart';
import 'package:frontendmobile/core/utils/error_banner.dart';
import 'package:frontendmobile/core/widgets/alertmessage/app_snacker.dart';
import 'package:frontendmobile/core/widgets/shimmer/app_list_shimmer.dart';
import 'package:frontendmobile/features/inventory/supplier/presentation/screens/supplier_detail_screen.dart';
import 'package:frontendmobile/features/inventory/supplier/presentation/widgets/supplier_form_screen.dart';
import '../providers/supplier_provider.dart';
import '../widgets/supplier_tile.dart';
import 'package:collection/collection.dart';

class SuppliersScreen extends ConsumerStatefulWidget {
  const SuppliersScreen({super.key});

  @override
  ConsumerState<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends ConsumerState<SuppliersScreen> {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  final _searchCtrl = TextEditingController();
  String _query = '';

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
  ///
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
    final c = SupplierColors.of(context);
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
      backgroundColor: c.background,

      //////////////////////////////////////////////////////////////////////////
      /// AppBar
      //////////////////////////////////////////////////////////////////////////
      appBar: AppBar(
        backgroundColor: c.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Suppliers',
          style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w600),
        ),
      ),
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.isCreating ? null : _openCreate,
        backgroundColor: c.accent,
        foregroundColor: c.onAccent,
        elevation: 0,
        icon: const Icon(Icons.add),
        label: const Text('Add supplier'),
      ),
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      body: Column(
        children: [
          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          if (state.error != null)
            ErrorBanner(message: state.error!, onDismiss: notifier.clearError),
          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
            child: TextField(
              controller: _searchCtrl,
              style: TextStyle(color: c.textPrimary, fontSize: 15),

              //////////////////////////////////////////////////////////////////
              ///  searching
              //////////////////////////////////////////////////////////////////
              decoration: InputDecoration(
                hintText: 'Search by name, phone, email',
                hintStyle: TextStyle(color: c.textTertiary, fontSize: 15),
                prefixIcon: Icon(Icons.search, color: c.textTertiary, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close,
                          color: c.textTertiary,
                          size: 18,
                        ),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ////////////////////
                ///
                ///////////////////
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: c.border),
                ),
                ///////////////////
                ///
                ///////////////////
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: c.border),
                ),
                //////////////////
                ///
                /////////////////
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: c.accent, width: 1.4),
                ),
                filled: true,
                fillColor: c.surfaceMuted,
              ),
              ////////////////
              ///
              ///////////////
              onChanged: (v) => setState(() => _query = v),
            ),

            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
          ),
          Expanded(
            child: state.isLoading && state.suppliers.isEmpty
                ? const AppListShimmer(itemCount: 6)
                : filtered.isEmpty
                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                ? Center(
                    child: Text(
                      _query.isNotEmpty
                          ? 'No suppliers match "$_query".'
                          : 'No suppliers yet.',
                      style: TextStyle(fontSize: 14, color: c.textSecondary),
                    ),
                  )
                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                : RefreshIndicator(
                    color: c.accent,
                    onRefresh: notifier.loadAll,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: filtered.length,

                      itemBuilder: (_, i) {
                        final s = filtered[i];
                        ////////////////////////////////////////////////////////
                        ///
                        ////////////////////////////////////////////////////////
                        return SupplierTile(
                          supplier: s,
                          isWorking: state.loadingIds.contains(s.supplierId),
                          borderColor: c.border,
                          onTap: () => _openDetails(s.supplierId),
                          onEdit: () => _openEdit(s.supplierId),
                          onDelete: () => _confirmDelete(s.supplierId, s.name),
                        );

                        ////////////////////////////////////////////////////////
                        ///
                        ////////////////////////////////////////////////////////
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
