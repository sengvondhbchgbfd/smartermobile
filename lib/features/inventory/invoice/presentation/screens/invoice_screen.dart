import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/utils/confirm_delete_dialog.dart';
import 'package:frontendmobile/core/utils/error_banner.dart';
import 'package:frontendmobile/features/inventory/customer/presentation/providers/customer_provider.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/providers/invoice_providers.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/screens/invoice_from_screen.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/invoices_list.dart';
import 'package:frontendmobile/features/inventory/product/presentation/providers/product_provider.dart';
import 'invoice_detail_screen.dart';
import '../widgets/invoices_header.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////
class InvoicesScreen extends ConsumerStatefulWidget {
  const InvoicesScreen({super.key});

  @override
  ConsumerState<InvoicesScreen> createState() => _InvoicesScreenState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////
class _InvoicesScreenState extends ConsumerState<InvoicesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(invoiceNotifierProvider.notifier).loadAll();
      ref.read(customerNotifierProvider.notifier).loadAll();
      ref.read(productNotifierProvider.notifier).loadAll();
    });
  }

  /////////////////////////////////////////////////////////////////////
  // Actions
  /////////////////////////////////////////////////////////////////////

  Future<void> _refreshAll() async {
    await ref.read(invoiceNotifierProvider.notifier).loadAll();
    await ref.read(productNotifierProvider.notifier).loadAll();
    await ref.read(customerNotifierProvider.notifier).loadAll();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void _backToDashboard() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _openCreate() async {
    final productState = ref.read(productNotifierProvider);
    final customers = ref.read(customerNotifierProvider).customers;
    final variants = productState.products.expand((p) => p.variants).toList();
    if (variants.isEmpty) {
      _snack('Add a product variant first.');
      return;
    }

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) =>
            InvoiceFormScreen(variants: variants, customers: customers),
        fullscreenDialog: true,
      ),
    );

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void _snack(String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isDark ? Pallets.textPrimaryDark : Pallets.onAccent,
          ),
        ),
        backgroundColor: isDark ? Pallets.surfaceElevated : Pallets.blurpleDim,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      ),
    );
  }

  /////////////////////////////////////////////////////////////////////
  // Build
  /////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    //////////////////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////////////////
    final state = ref.watch(invoiceNotifierProvider);
    final customers = ref.watch(customerNotifierProvider).customers;
    final productState = ref.watch(productNotifierProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color bgColor = isDark
        ? Pallets.backgroundDark
        : Pallets.backgroundLight;
    final Color accent = Pallets.blurple;
    String customerName(int? customerId) {
      if (customerId == null) return 'Walk-in customer';
      final c = customers.where((c) => c.customerId == customerId).firstOrNull;
      return c?.name ?? 'Customer #$customerId';
    }

    final bool isButtonDisabled = state.isLoading || productState.isLoading;
    final int invoiceCount = state.invoices.length;
    final double totalRevenue = state.invoices.fold(
      0.0,
      (sum, i) => sum + (i.totalAmount ?? 0.0),
    );
    //////////////////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////////////////
    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      //////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: Pallets.bannerGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: isButtonDisabled ? null : _openCreate,
          backgroundColor: Colors.transparent,
          foregroundColor: Pallets.onAccent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: productState.isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.add_rounded),
          label: Text(
            productState.isLoading ? 'Loading...' : 'New Invoice',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),

      ///////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////
      body: Column(
        children: [
          /////////////////////////////
          ///
          /////////////////////////////
          InvoicesHeader(
            onClose: _backToDashboard,
            invoiceCount: invoiceCount,
            totalRevenue: totalRevenue,
          ),

          /////////////////////////////
          ///
          /////////////////////////////
          if (state.error != null)
            ErrorBanner(
              message: state.error!,
              onDismiss: ref.read(invoiceNotifierProvider.notifier).clearError,
            ),
          /////////////////////////////
          ///
          /////////////////////////////
          if (productState.error != null)
            ErrorBanner(
              message: 'Products Error: ${productState.error!}',
              onDismiss: () {},
            ),

          /////////////////////////////
          ///
          /////////////////////////////
          Expanded(
            child: InvoicesList(
              isLoading: state.isLoading,
              isProductLoading: productState.isLoading,
              isButtonDisabled: isButtonDisabled,
              invoices: state.invoices,
              customerName: customerName,
              onTapInvoice: (inv) => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => InvoiceDetailScreen(invoiceId: inv.invoiceId),
                ),
              ),
              onDeleteInvoice: _confirmDelete,
              onCreate: _openCreate,
              onRefresh: _refreshAll,
            ),
          ),
        ],
      ),
    );
  }
}
