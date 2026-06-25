import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontendmobile/core/utils/confirm_delete_dialog.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/providers/invoice_providers.dart';
import 'package:frontendmobile/features/inventory/product/presentation/providers/product_provider.dart';
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';

class InvoiceDetailScreen extends ConsumerStatefulWidget {
  final int invoiceId;

  const InvoiceDetailScreen({required this.invoiceId, super.key});

  @override
  ConsumerState<InvoiceDetailScreen> createState() =>
      _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends ConsumerState<InvoiceDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(productNotifierProvider.notifier).loadAll();
    });
  }

  Future<void> _addAttachment(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);
    final ok = await ref
        .read(invoiceNotifierProvider.notifier)
        .addAttachment(
          invoiceId: widget.invoiceId,
          file: file,
          fileType: result.files.single.extension,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? 'Attachment added.' : 'Failed to add attachment.'),
        ),
      );
    }
  }

  Future<void> _deleteAttachment(BuildContext context, int attachmentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const ConfirmDeleteDialog(
        title: 'Delete Attachment',
        message: 'Remove this attachment from the invoice?',
      ),
    );
    if (confirmed != true) return;

    await ref
        .read(invoiceNotifierProvider.notifier)
        .deleteAttachment(
          invoiceId: widget.invoiceId,
          attachmentId: attachmentId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceNotifierProvider);
    final invoice = state.invoices
        .where((i) => i.invoiceId == widget.invoiceId)
        .firstOrNull;

    final productState = ref.watch(productNotifierProvider);

    // Map<variantId, (productName, variant)> built once per build
    final Map<int, ({String productName, ProductVariantEntity variant})>
    variantMap = {
      for (final p in productState.products)
        for (final v in p.variants)
          v.variantId: (productName: p.name, variant: v),
    };

    if (invoice == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Invoice')),
        body: const Center(child: Text('Invoice not found.')),
      );
    }

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final totalAmount = invoice.totalAmount ?? 0.0;
    final discount = invoice.discount ?? 0.0;
    final tax = invoice.tax ?? 0.0;

    final subtotal = totalAmount + discount - tax;

    String variantLabel(int variantId) {
      final entry = variantMap[variantId];
      if (entry == null) return 'Variant #$variantId';

      final productName = entry.productName;
      final v = entry.variant;

      final specsStr = v.specs.isNotEmpty
          ? v.specs.entries.map((e) => '${e.key}: ${e.value}').join(', ')
          : '';

      final skuPart = v.sku?.isNotEmpty == true ? ' [${v.sku}]' : '';
      final specsPart = specsStr.isNotEmpty ? ' ($specsStr)' : '';

      return '$productName$skuPart$specsPart';
    }

    return Scaffold(
      appBar: AppBar(title: Text('Invoice #${invoice.invoiceId}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Summary card ─────────────────────────────────────────────────
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: colors.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(label: Text(invoice.paymentType.toString())),
                      Text(
                        _formatDate(invoice.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Loading indicator while variants are being fetched
                  if (productState.isLoading && productState.products.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  else
                    ...invoice.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${variantLabel(item.variantId)}  ×${item.quantity}',
                              ),
                            ),
                            // ✅ Guard nullable totalPrice
                            Text(
                              '\$${(item.totalPrice ?? 0.0).toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                      ),
                    ),

                  const Divider(height: 20),

                  // ✅ All values are now non-nullable doubles
                  _row('Subtotal', subtotal, theme),
                  _row('Discount', -discount, theme),
                  _row('Tax', tax, theme),
                  const Divider(height: 20),
                  _row('Total', totalAmount, theme, bold: true),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Attachments ──────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attachments',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton.icon(
                onPressed: () => _addAttachment(context),
                icon: const Icon(Icons.attach_file, size: 18),
                label: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (invoice.attachments.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No attachments yet.',
                style: TextStyle(color: colors.outline),
              ),
            )
          else
            ...invoice.attachments.map(
              (att) => Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: colors.outlineVariant),
                ),
                child: ListTile(
                  leading: Icon(
                    _iconForFileType(att.fileType),
                    color: colors.primary,
                  ),
                  title: Text(att.fileName ?? 'Attachment'),
                  subtitle: Text(att.fileType ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: colors.error),
                    onPressed: () =>
                        _deleteAttachment(context, att.attachmentId),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _row(
    String label,
    double value, // ✅ non-nullable — callers pass resolved locals
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

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  IconData _iconForFileType(String? type) {
    switch (type?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Icons.image_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }
}
