import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/utils/confirm_delete_dialog.dart';
import 'package:frontendmobile/core/utils/emty_state.dart' show EmptyState;
import 'package:frontendmobile/core/utils/error_banner.dart';
import 'package:frontendmobile/features/inventory/customer/presentation/providers/customer_provider.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/providers/invoice_providers.dart';
import 'package:frontendmobile/features/inventory/product/presentation/providers/product_provider.dart';
import '../widgets/invoice_widgets.dart';
import 'invoice_detail_screen.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class InvoicesScreen extends ConsumerStatefulWidget {
  const InvoicesScreen({super.key});

  @override
  ConsumerState<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends ConsumerState<InvoicesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(invoiceNotifierProvider.notifier).loadAll();
      ref.read(customerNotifierProvider.notifier).loadAll();
      // ✅ loadAll() must also load variants so InvoiceFormDialog can list them
      ref.read(productNotifierProvider.notifier).loadAll();
    });
  }

  /////////////////////////////////////////////////////////////////////
  // Actions
  /////////////////////////////////////////////////////////////////////

  Future<void> _openCreate() async {
    final productState = ref.read(productNotifierProvider);
    final customers = ref.read(customerNotifierProvider).customers;

    // ✅ Flatten variants from nested products — ProductState has no top-level variants list
    final variants = productState.products.expand((p) => p.variants).toList();
    if (variants.isEmpty) {
      _snack('Add a product variant first.');
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) =>
          InvoiceFormDialog(variants: variants, customers: customers),
    );
    if (result == null || !mounted) return;
    final ok = await ref
        .read(invoiceNotifierProvider.notifier)
        .create(
          customerId: result['customer_id'],
          staffId: result['staff_id'],
          totalAmount: result['total_amount'],
          discount: result['discount'],
          tax: result['tax'],
          paymentType: result['payment_type'],
          items: result['items'],
        );
    if (mounted) {
      _snack(ok ? 'Invoice created.' : 'Failed to create invoice.');
      if (ok) {
        // Stock changed on the backend — refresh variants to get updated stock
        ref.read(productNotifierProvider.notifier).loadAll();
      }
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _confirmDelete(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDeleteDialog(
        title: 'Delete Invoice',
        message:
            'Are you sure you want to delete invoice #$id? This cannot be undone.',
      ),
    );
    if (confirmed != true || !mounted) return;

    final ok = await ref.read(invoiceNotifierProvider.notifier).delete(id);
    if (mounted) _snack(ok ? 'Invoice deleted.' : 'Failed to delete invoice.');
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /////////////////////////////////////////////////////////////////////
  // Build
  /////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceNotifierProvider);
    final notifier = ref.read(invoiceNotifierProvider.notifier);
    final customers = ref.watch(customerNotifierProvider).customers;
    final productState = ref.watch(productNotifierProvider);

    String customerName(int? customerId) {
      if (customerId == null) return 'Walk-in customer';
      final c = customers.where((c) => c.customerId == customerId).firstOrNull;
      return c?.name ?? 'Customer #$customerId';
    }

    // ✅ Disable FAB while variants (not just products) are still loading
    final bool isButtonDisabled = state.isLoading || productState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: state.isLoading
                ? null
                : () {
                    notifier.loadAll();
                    ref.read(productNotifierProvider.notifier).loadAll();
                    ref.read(customerNotifierProvider.notifier).loadAll();
                  },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isButtonDisabled ? null : _openCreate,
        icon: productState.isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.grey,
                ),
              )
            : const Icon(Icons.add),
        label: Text(productState.isLoading ? 'Loading...' : 'New Invoice'),
      ),
      body: Column(
        children: [
          if (state.error != null)
            ErrorBanner(message: state.error!, onDismiss: notifier.clearError),
          if (productState.error != null)
            ErrorBanner(
              message: 'Products Error: ${productState.error!}',
              onDismiss: () {},
            ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.invoices.isEmpty
                ? EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'No invoices yet',
                    message: 'Create your first invoice to start selling.',
                    actionLabel: productState.isLoading
                        ? 'Syncing...'
                        : 'New Invoice',
                    onAction: isButtonDisabled ? () {} : _openCreate,
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await notifier.loadAll();
                      await ref
                          .read(productNotifierProvider.notifier)
                          .loadAll();
                      await ref
                          .read(customerNotifierProvider.notifier)
                          .loadAll();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100, top: 4),
                      itemCount: state.invoices.length,
                      itemBuilder: (_, i) {
                        final inv = state.invoices[i];
                        return InvoiceTile(
                          invoice: inv,
                          customerName: customerName(inv.customerId),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  InvoiceDetailScreen(invoiceId: inv.invoiceId),
                            ),
                          ),
                          onDelete: () => _confirmDelete(inv.invoiceId),
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
