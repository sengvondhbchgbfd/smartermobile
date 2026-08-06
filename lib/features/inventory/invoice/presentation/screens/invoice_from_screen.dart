import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/inventory/customer/domain/entities/customer_entity.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/providers/invoice_providers.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/from_screen/add_variant_sheet.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/from_screen/bottom_action_bar.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/from_screen/create_mode.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/from_screen/draft_item.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/from_screen/manaul_entry_view.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/from_screen/mode_toggle.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/from_screen/payment_type_sheet.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/from_screen/quotation_list_views.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/invoice_theme_color.dart';
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';
import 'package:frontendmobile/features/inventory/quotations/domain/entities/quotation_entity.dart';

class InvoiceFormScreen extends ConsumerStatefulWidget {
  final List<ProductVariantEntity> variants;
  final List<CustomerEntity> customers;

  const InvoiceFormScreen({
    required this.variants,
    required this.customers,
    super.key,
  });

  @override
  ConsumerState<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends ConsumerState<InvoiceFormScreen> {
  CreationMode _mode = CreationMode.manual;

  //////////////////////////////////////////////////////////////////////////////
  // ── Manual entry state ──────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////
  int? _customerId;
  String _paymentType = 'cash';
  final _discountCtrl = TextEditingController(text: '0');
  final _taxCtrl = TextEditingController(text: '0');
  final List<DraftItem> _items = [];

  //////////////////////////////////////////////////////////////////////////////
  // ── Quotation state ─────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  bool _converting = false;
  int? _expandedQuotationId;

  @override
  void dispose() {
    _discountCtrl.dispose();
    _taxCtrl.dispose();
    super.dispose();
  }

  double get _subtotal => _items.fold(0.0, (sum, i) => sum + i.total);
  double get _discount => double.tryParse(_discountCtrl.text) ?? 0;
  double get _tax => double.tryParse(_taxCtrl.text) ?? 0;
  double get _total => _subtotal - _discount + _tax;

  //////////////////////////////////////////////////////////////////////////////
  // ─────────────────────────────────────────────────────────────────────────
  // Manual entry actions
  // ─────────────────────────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _addVariant() async {
    final variant = await showAddVariantSheet(context, widget.variants);
    if (variant == null) return;
    setState(() {
      final existing = _items
          .where((i) => i.variant.variantId == variant.variantId)
          .firstOrNull;
      if (existing != null) {
        existing.quantity++;
      } else {
        _items.add(DraftItem(variant: variant));
      }
    });
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void _submit() {
    final colors = context.invoiceColors;
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: colors.error,
          content: const Text('Add at least one product.'),
        ),
      );
      return;
    }

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    Navigator.of(context).pop({
      'customer_id': _customerId,
      'payment_type': _paymentType,
      'discount': _discount,
      'tax': _tax,
      'total_amount': _total,
      'items': _items
          .map(
            (i) => InvoiceItemInput(
              productId: i.variant.productId,
              variantId: i.variant.variantId,
              quantity: i.quantity,
              unitPrice: i.variant.price,
            ),
          )
          .toList(),
    });
  }

  //////////////////////////////////////////////////////////////////////////////
  // ─────────────────────────────────────────────────────────────────────────
  // Quotation conversion actions
  // ─────────────────────────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _convertQuotation(QuotationEntity quotation) async {
    final colors = context.invoiceColors;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.overlay,
        title: Text(
          'Convert ${quotation.refNumber}?',
          style: TextStyle(color: colors.textPrimary),
        ),
        content: Text(
          'This creates a new invoice with all ${quotation.items.length} '
          'item(s) from this quotation. This cannot be undone.',
          style: TextStyle(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: colors.accent,
              foregroundColor: colors.onAccent,
            ),
            child: const Text('Convert'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final paymentType = await showPaymentTypeSheet(context);
    if (paymentType == null || !mounted) return;

    setState(() => _converting = true);
    try {
      final usecase = await ref.read(createFromQuotationUCProvider.future);
      final result = await usecase(
        quotationId: quotation.quotationId,
        paymentType: paymentType,
      );

      if (!mounted) return;
      await ref
          .read(invoiceNotifierProvider.notifier)
          .refreshInvoiceById(result.invoiceId);
      if (!mounted) return;
      Navigator.of(
        context,
      ).pop({'created_from_quotation': true, 'invoice': result});
    } catch (e) {
      if (!mounted) return;
      setState(() => _converting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: colors.error,
          content: Text('Failed to create invoice from quotation: $e'),
        ),
      );
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final colors = context.invoiceColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: _converting ? null : () => Navigator.of(context).pop(),
        ),
        title: const Text('New Invoice'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: ModeToggle(
                mode: _mode,
                enabled: !_converting,
                onChanged: (m) => setState(() => _mode = m),
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _mode == CreationMode.manual
                    ? KeyedSubtree(
                        key: const ValueKey('manual'),
                        child: _buildManualMode(),
                      )
                    : KeyedSubtree(
                        key: const ValueKey('quotation'),
                        child: _buildQuotationMode(),
                      ),
              ),
            ),
            if (_mode == CreationMode.manual)
              BottomActionBar(total: _total, onSubmit: _submit),
          ],
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Widget _buildManualMode() {
    return ManualEntryView(
      customers: widget.customers,
      customerId: _customerId,
      onCustomerChanged: (v) => setState(() => _customerId = v),
      paymentType: _paymentType,
      onPaymentTypeChanged: (v) => setState(() => _paymentType = v),
      items: _items,
      onAddProduct: _addVariant,
      onIncrement: (i) => setState(() => _items[i].quantity++),
      onDecrementOrRemove: (i) => setState(() {
        if (_items[i].quantity > 1) {
          _items[i].quantity--;
        } else {
          _items.removeAt(i);
        }
      }),
      discountCtrl: _discountCtrl,
      taxCtrl: _taxCtrl,
      onTotalsChanged: () => setState(() {}),
      subtotal: _subtotal,
      discount: _discount,
      tax: _tax,
      total: _total,
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Widget _buildQuotationMode() {
    return QuotationListView(
      expandedQuotationId: _expandedQuotationId,
      converting: _converting,
      onToggleExpanded: (id) => setState(() => _expandedQuotationId = id),
      onConvert: _convertQuotation,
    );
  }
}
