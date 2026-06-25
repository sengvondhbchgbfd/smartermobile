import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/utils/emty_state.dart';
import 'package:frontendmobile/core/widgets/alertmessage/app_snacker.dart';
import 'package:frontendmobile/core/widgets/alertmessage/dialog_helper.dart';
import 'package:frontendmobile/core/widgets/shimmer/app_list_shimmer.dart';
import 'package:frontendmobile/features/inventory/customer/presentation/screens/customer_detail_screen.dart';
import 'package:frontendmobile/features/inventory/customer/presentation/widgets/customer_create_page.dart';
import 'package:frontendmobile/features/inventory/customer/presentation/widgets/customer_tile.dart';
import '../../../../../core/utils/error_banner.dart';
import '../providers/customer_provider.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});
  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(customerNotifierProvider.notifier).loadAll(),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////////////
  // ── Create ─────────────────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////
  Future<void> _openCreate() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const CustomerCreatePage()),
    );
    if (result == null || !mounted) return;
    final ok = await ref
        .read(customerNotifierProvider.notifier)
        .create(
          name: result['name'],
          phone: result['phone'],
          email: result['email'],
          avatar: result['avatar'],
        );
    if (!mounted) return;
    AppSnackBar.show(
      context,
      message: ok
          ? 'Customer created successfully.'
          : 'Failed to create customer.',
      type: ok ? SnackType.success : SnackType.error,
    );
  }
  //////////////////////////////////////////////////////////////////////////////
  // ── Edit ───────────────────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _openEdit(int id) async {
    final customer = ref
        .read(customerNotifierProvider)
        .customers
        .firstWhere((c) => c.customerId == id);
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => CustomerCreatePage(existing: customer)),
    );
    if (result == null || !mounted) return;
    final ok = await ref
        .read(customerNotifierProvider.notifier)
        .update(
          customerId: id,
          name: result['name'],
          phone: result['phone'],
          email: result['email'],
          avatar: result['avatar'],
        );
    if (!mounted) return;
    AppSnackBar.show(
      context,
      message: ok
          ? 'Customer updated successfully.'
          : 'Failed to update customer.',
      type: ok ? SnackType.success : SnackType.error,
    );
  }
  //////////////////////////////////////////////////////////////////////////////
  // ── Delete ─────────────────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _confirmDelete(int id, String name) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Delete Customer',
      message:
          'Are you sure you want to delete "$name"?\nThis cannot be undone.',
      confirmLabel: 'Delete',
      isDanger: true,
    );

    if (confirmed != true || !mounted) return;
    final ok = await ref.read(customerNotifierProvider.notifier).delete(id);
    if (!mounted) return;
    AppSnackBar.show(
      context,
      message: ok ? 'Customer "$name" deleted.' : 'Failed to delete customer.',
      type: ok ? SnackType.success : SnackType.error,
    );
  }
  //////////////////////////////////////////////////////////////////////////////
  // ── Build ──────────────────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {


    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5F5F4);
    final cardBg = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE0DED8);
    final searchBg = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFEFEFED);
    final subText = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6B6B6B);




    final state = ref.watch(customerNotifierProvider);
    final notifier = ref.read(customerNotifierProvider.notifier);

    final filtered = state.customers
        .where(
          (c) =>
              _query.isEmpty ||
              c.name.toLowerCase().contains(_query.toLowerCase()) ||
              (c.phone?.contains(_query) ?? false) ||
              (c.email?.toLowerCase().contains(_query.toLowerCase()) ?? false),
        )
        .toList();

    return Scaffold(
      backgroundColor: bg,

      //////////////////////////////////////////////////////////////////////////
      // ── AppBar ─────────────────────────────────────────────────────────────
      //////////////////////////////////////////////////////////////////////////
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Customers',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(height: 0.5, thickness: 0.5, color: borderColor),
        ),
      ),

      //////////////////////////////////////////////////////////////////////////
      // ── FAB ────────────────────────────────────────────────────────────────
      //////////////////////////////////////////////////////////////////////////
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreate,
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Customer',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),

      body: Column(
        children: [
          //////////////////////////////////////////////////////////////////////
          // ── Error banner ───────────────────────────────────────────────────
          //////////////////////////////////////////////////////////////////////
          if (state.error != null)
            ErrorBanner(message: state.error!, onDismiss: notifier.clearError),

          //////////////////////////////////////////////////////////////////////
          // ── Search bar ─────────────────────────────────────────────────────
          //////////////////////////////////////////////////////////////////////
          Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                color: searchBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 0.5),
              ),
              child: TextField(
                controller: _searchCtrl,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search by name, phone, email…',
                  hintStyle: TextStyle(fontSize: 14, color: subText),
                  prefixIcon: const Icon(Icons.search_rounded, size: 18),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 16),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
          ),
          Divider(height: 0.5, thickness: 0.5, color: borderColor),

          //////////////////////////////////////////////////////////////////////
          // ── List ───────────────────────────────────────────────────────────
          //////////////////////////////////////////////////////////////////////
          Expanded(
            child: state.isLoading
                ? const AppListShimmer(itemCount: 6)
                : filtered.isEmpty
                ? EmptyState(
                    icon: Icons.people_outline_rounded,
                    title: 'No customers yet',
                    message: 'Add your first customer to get started.',
                    actionLabel: 'Add Customer',
                    onAction: _openCreate,
                  )
                : RefreshIndicator(
                    onRefresh: notifier.loadAll,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
                      itemCount: filtered.length + 1,
                      itemBuilder: (_, i) {
                        if (i == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              '${filtered.length} customer${filtered.length == 1 ? '' : 's'}',
                              style: TextStyle(fontSize: 12, color: subText),
                            ),
                          );
                        }
                        final c = filtered[i - 1];
                        final isItemLoading = state.loadingIds.contains(
                          c.customerId,
                        );
                        return CustomerTile(
                          customer: c,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          onTap: isItemLoading ? null : () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => CustomerDetailScreen(
                                      customerId: c.customerId,
                                    ),
                                  ),
                                ),
                          onEdit: isItemLoading ? null : () => _openEdit(c.customerId),
                         onDelete: isItemLoading ? null : () => _confirmDelete(c.customerId, c.name),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
