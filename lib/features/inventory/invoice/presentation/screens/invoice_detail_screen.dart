import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/screens/invoice_pdf_preview_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/utils/confirm_delete_dialog.dart';
import 'package:frontendmobile/features/inventory/customer/presentation/providers/customer_provider.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/providers/invoice_providers.dart';
import 'package:frontendmobile/features/inventory/product/presentation/providers/product_provider.dart';
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/custom_size_dialog.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/print_size_sheet.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/invoice_pdf_builder.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/invoice_summary_card.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/attachments_section.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class InvoiceDetailScreen extends ConsumerStatefulWidget {
  final int invoiceId;
  const InvoiceDetailScreen({required this.invoiceId, super.key});
  @override
  ConsumerState<InvoiceDetailScreen> createState() =>
      _InvoiceDetailScreenState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _InvoiceDetailScreenState extends ConsumerState<InvoiceDetailScreen> {
  bool _isUploadingAttachment = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(productNotifierProvider.notifier).loadAll();
      ref.read(customerNotifierProvider.notifier).loadAll();
    });
  }

  /////////////////////////////////////////////////////////////////////
  // Attachments
  /////////////////////////////////////////////////////////////////////

  Future<void> _addAttachment(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.single.path == null) return;

    setState(() => _isUploadingAttachment = true);

    final file = File(result.files.single.path!);
    final ok = await ref
        .read(invoiceNotifierProvider.notifier)
        .addAttachment(
          invoiceId: widget.invoiceId,
          file: file,
          fileType: result.files.single.extension,
        );

    if (!mounted) return;
    setState(() => _isUploadingAttachment = false);
    _snack(context, ok ? 'Attachment added.' : 'Failed to add attachment.');
  }

  //////////////////////////////////////////////////////////////////////////
  ///
  /////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////
  ///
  /////////////////////////////////////////////////////////////////////////
  void _snack(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isDark ? Pallets.surfaceElevated : Pallets.blurpleDim,
        content: Text(
          message,
          style: TextStyle(
            color: isDark ? Pallets.textPrimaryDark : Pallets.onAccent,
          ),
        ),
      ),
    );
  }

  /////////////////////////////////////////////////////////////////////
  // Print
  /////////////////////////////////////////////////////////////////////

  void _openPrintOptions({
    required dynamic invoice,
    required String Function(int) variantLabel,
    required String customerName,
  }) {
    showPrintSizeSheet(
      context,
      promptCustomSize: () => showCustomSizeDialog(context),
      onFormatChosen: (format) => _printInvoice(
        invoice: invoice,
        variantLabel: variantLabel,
        customerName: customerName,
        format: format,
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _printInvoice({
    required dynamic invoice,
    required String Function(int) variantLabel,
    required String customerName,
    required PdfPageFormat format,
  }) async {
    final fontData = await rootBundle.load(
      'assets/fonts/KhmerOSbattambang.ttf',
    );
    final khmerFontBytes = fontData.buffer.asUint8List();

    final cjkFontData = await rootBundle.load(
      'assets/fonts/NotoSansSC-Bold.ttf',
    );
    final cjkFontBytes = cjkFontData.buffer.asUint8List();

    final logoBytes = await rootBundle
        .load('assets/images/duong_chhiv_logo.png')
        .then((d) => d.buffer.asUint8List());

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InvoicePdfPreviewScreen(
          invoiceName: 'Invoice #${invoice.invoiceId}',
          initialFormat: format,
          buildPdf: (fmt) => InvoicePdfBuilder.build(
            invoice,
            variantLabel,
            customerName,
            fmt,
            logoBytes: logoBytes,
            logoIncludesText: false,
            khmerFontBytes: khmerFontBytes,
            cjkFontBytes: cjkFontBytes,
          ),
        ),
      ),
    );
  }

  /////////////////////////////////////////////////////////////////////
  // Build
  /////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceNotifierProvider);
    final invoice = state.invoices
        .where((i) => i.invoiceId == widget.invoiceId)
        .firstOrNull;
    final productState = ref.watch(productNotifierProvider);
    final customers = ref.watch(customerNotifierProvider).customers;

    ///////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isDark
        ? Pallets.backgroundDark
        : Pallets.backgroundLight;
    final Color textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final Color textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final Color accent = Pallets.blurple;
    ///////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////
    final Map<int, ({String productName, ProductVariantEntity variant})>
    variantMap = {
      for (final p in productState.products)
        for (final v in p.variants)
          v.variantId: (productName: p.name, variant: v),
    };

    ///////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////

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

    ///////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////

    String customerName(int? customerId) {
      if (customerId == null) return 'Walk-in customer';
      final c = customers.where((c) => c.customerId == customerId).firstOrNull;
      return c?.name ?? 'Customer #$customerId';
    }

    ///////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////

    if (invoice == null) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          foregroundColor: textPrimary,
          title: const Text('Invoice'),
        ),
        body: Center(
          child: Text(
            'Invoice not found.',
            style: TextStyle(color: textSecondary),
          ),
        ),
      );
    }

    ///////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////

    final custName = customerName(invoice.customerId);

    ///////////////////////////////////////////////////////
    ///
    //////////////////////////////////////////////////////
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        foregroundColor: textPrimary,
        title: Text('Invoice #${invoice.invoiceId}'),
        actions: [
          IconButton(
            tooltip: 'Print',
            icon: const Icon(Icons.print_outlined),
            onPressed: () => _openPrintOptions(
              invoice: invoice,
              variantLabel: variantLabel,
              customerName: custName,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InvoiceSummaryCard(
            invoice: invoice,
            productsLoading:
                productState.isLoading && productState.products.isEmpty,
            variantLabel: variantLabel,
            customerName: custName,
          ),

          const SizedBox(height: 12),

          ///////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: () => _openPrintOptions(
                invoice: invoice,
                variantLabel: variantLabel,
                customerName: custName,
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: accent,
                side: BorderSide(color: accent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.print_outlined, size: 18),
              label: const Text('Print invoice'),
            ),
          ),

          const SizedBox(height: 20),

          ///////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////
          AttachmentsSection(
            attachments: invoice.attachments,
            isUploading: _isUploadingAttachment,
            onAdd: () => _addAttachment(context),
            onDelete: (id) => _deleteAttachment(context, id),
          ),
        ],
      ),
    );
  }
}
