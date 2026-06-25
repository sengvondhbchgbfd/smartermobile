import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/customer/domain/entities/customer_entity.dart';
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/repositories/invoice_repository.dart'
    show InvoiceItemInput;

// ---------------------------------------------------------------------------
// Invoice tile
// ---------------------------------------------------------------------------

class InvoiceTile extends StatelessWidget {
  final InvoiceEntity invoice;
  final String customerName;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const InvoiceTile({
    required this.invoice,
    required this.customerName,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: colors.primaryContainer,
          child: Icon(
            Icons.receipt_long_outlined,
            color: colors.onPrimaryContainer,
            size: 20,
          ),
        ),
        title: Text(
          'Invoice #${invoice.invoiceId}',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(customerName, style: theme.textTheme.bodySmall),
            Text(
              '${invoice.items.length} item${invoice.items.length == 1 ? '' : 's'}   •   ${invoice.paymentType}',
              style: theme.textTheme.bodySmall?.copyWith(color: colors.outline),
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              // ✅ totalAmount is non-nullable in detail screen usage — safe to use directly
              // but guard here in case entity declares it nullable
              '\$${(invoice.totalAmount ?? 0).toStringAsFixed(2)}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: colors.error, size: 20),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Draft item — holds a variant + quantity
// ---------------------------------------------------------------------------

class _DraftItem {
  final ProductVariantEntity variant;
  int quantity;

  _DraftItem({required this.variant, this.quantity = 1});

  double get total => (variant.price ?? 0) * quantity;
}

// ---------------------------------------------------------------------------
// Create invoice dialog
// ---------------------------------------------------------------------------

class InvoiceFormDialog extends StatefulWidget {
  final List<ProductVariantEntity> variants; // ✅ variants, not products
  final List<CustomerEntity> customers;

  const InvoiceFormDialog({
    required this.variants,
    required this.customers,
    super.key,
  });

  @override
  State<InvoiceFormDialog> createState() => _InvoiceFormDialogState();
}

class _InvoiceFormDialogState extends State<InvoiceFormDialog> {
  int? _customerId;
  String _paymentType = 'cash';
  final _discountCtrl = TextEditingController(text: '0');
  final _taxCtrl = TextEditingController(text: '0');
  final List<_DraftItem> _items = [];

  @override
  void dispose() {
    _discountCtrl.dispose();
    _taxCtrl.dispose();
    super.dispose();
  }

  double get _subtotal => _items.fold(0, (sum, i) => sum + i.total);
  double get _discount => double.tryParse(_discountCtrl.text) ?? 0;
  double get _tax => double.tryParse(_taxCtrl.text) ?? 0;
  double get _total => _subtotal - _discount + _tax;

  void _addVariant() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          // ✅ Correctly maps over widget.variants with proper .toList()
          children: widget.variants.map((v) {
            return ListTile(
              title: Text(
                v.sku?.isNotEmpty == true ? v.sku! : 'Variant #${v.variantId}',
              ),
              subtitle: Text(
                '\$${v.price?.toStringAsFixed(2) ?? '0.00'}  •  Stock: ${v.stockQuantity ?? 0}',
              ),
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  final existing = _items
                      .where((i) => i.variant.variantId == v.variantId)
                      .firstOrNull;
                  if (existing != null) {
                    existing.quantity++;
                  } else {
                    _items.add(_DraftItem(variant: v));
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _submit() {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one product.')),
      );
      return;
    }

    Navigator.of(context).pop({
      'customer_id': _customerId,
      'payment_type': _paymentType,
      'discount': _discount,
      'tax': _tax,
      'total_amount': _total,
      // ✅ Uses variant fields — no more i.product references
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AlertDialog(
      title: const Text('New Invoice'),
      content: SizedBox(
        width: 450,
        child: SingleChildScrollView(
          // ✅ prevents overflow on small screens
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Customer
              DropdownButtonFormField<int?>(
                value: _customerId,
                decoration: const InputDecoration(
                  labelText: 'Customer (optional)',
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Walk-in customer'),
                  ),
                  ...widget.customers.map(
                    (c) => DropdownMenuItem(
                      value: c.customerId,
                      child: Text(c.name),
                    ),
                  ),
                ],
                onChanged: (v) => setState(() => _customerId = v),
              ),
              const SizedBox(height: 12),

              // Payment type
              DropdownButtonFormField<String>(
                value: _paymentType,
                decoration: const InputDecoration(labelText: 'Payment Type'),
                items: const [
                  DropdownMenuItem(value: 'cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'card', child: Text('Card')),
                  DropdownMenuItem(
                    value: 'transfer',
                    child: Text('Bank Transfer'),
                  ),
                ],
                onChanged: (v) => setState(() => _paymentType = v ?? 'cash'),
              ),
              const SizedBox(height: 16),

              // Items header
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Items',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              if (_items.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'No items added yet.',
                    style: TextStyle(color: colors.outline),
                  ),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _items.length,
                    itemBuilder: (_, i) {
                      final item = _items[i];
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        // ✅ Uses variant fields throughout
                        title: Text(
                          item.variant.sku?.isNotEmpty == true
                              ? item.variant.sku!
                              : 'Variant #${item.variant.variantId}',
                        ),
                        subtitle: Text(
                          '\$${item.variant.price?.toStringAsFixed(2) ?? '0.00'} × ${item.quantity} = \$${item.total.toStringAsFixed(2)}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                size: 20,
                              ),
                              onPressed: () => setState(() {
                                if (item.quantity > 1) {
                                  item.quantity--;
                                } else {
                                  _items.removeAt(i);
                                }
                              }),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle_outline,
                                size: 20,
                              ),
                              onPressed: () => setState(() => item.quantity++),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              OutlinedButton.icon(
                onPressed: _addVariant, // ✅ renamed from _addProduct
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
              ),
              const SizedBox(height: 16),

              // Discount / Tax
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _discountCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Discount',
                        prefixText: '\$ ',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _taxCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Tax',
                        prefixText: '\$ ',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Totals
              _totalRow('Subtotal', _subtotal, theme),
              _totalRow('Discount', -_discount, theme),
              _totalRow('Tax', _tax, theme),
              const SizedBox(height: 4),
              _totalRow('Total', _total, theme, bold: true),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Create Invoice')),
      ],
    );
  }

  Widget _totalRow(
    String label,
    double value,
    ThemeData theme, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: bold
                ? theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                : theme.textTheme.bodyMedium,
          ),
          Text(
            '${value < 0 ? '-' : ''}\$${value.abs().toStringAsFixed(2)}',
            style: bold
                ? theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                : theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
