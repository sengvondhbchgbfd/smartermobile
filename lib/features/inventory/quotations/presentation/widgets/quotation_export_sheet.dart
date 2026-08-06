import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'package:frontendmobile/features/company/presentation/providers/company_provider.dart';
import 'package:frontendmobile/features/inventory/customer/presentation/providers/customer_provider.dart';
import '../../domain/entities/quotation_entity.dart';
import '../../domain/entities/quotation_item_entity.dart';
import '../providers/quotation_export_provider.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

Future<void> showQuotationExportSheet(
  BuildContext context,
  WidgetRef ref, {
  required QuotationEntity quotation,
  required List<QuotationItemEntity> items,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _QuotationExportSheet(quotation: quotation, items: items),
  );
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _QuotationExportSheet extends ConsumerStatefulWidget {
  final QuotationEntity quotation;
  final List<QuotationItemEntity> items;
  const _QuotationExportSheet({required this.quotation, required this.items});
  @override
  ConsumerState<_QuotationExportSheet> createState() =>
      _QuotationExportSheetState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _QuotationExportSheetState extends ConsumerState<_QuotationExportSheet> {
  bool _busy = false;
  String? _busyLabel;
  bool _ready = false;

  ////////////////////////////////////////////////////////////////////////////////
  /// INITAILIZATE DATA
  ////////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final companyState = ref.read(companyProvider).valueOrNull;
      if (companyState?.company == null) {
        final userInfo = await ref.read(currentUserInfoProvider.future);
        if (userInfo != null) {
          await ref
              .read(companyProvider.notifier)
              .fetchCompany(userInfo.companyId);
        }
      }
      final customerState = ref.read(customerNotifierProvider);
      if (customerState.customers.isEmpty) {
        await ref.read(customerNotifierProvider.notifier).loadAll();
      }
      if (mounted) setState(() => _ready = true);
    });
  }

  ////////////////////////////////////////////////////////////////////////////////
  ///  GET RESOLVE CUSTOMER NAME AND PHONE
  ////////////////////////////////////////////////////////////////////////////////

  ({String name, String phone}) _resolveCustomerInfo() {
    final q = widget.quotation;
    String name = q.customerName ?? '';
    String phone = q.customerPhone ?? '';

    if (name.isEmpty || phone.isEmpty) {
      final customers = ref.read(customerNotifierProvider).customers;
      for (final c in customers) {
        if (c.customerId == q.customerId) {
          if (name.isEmpty) name = c.name;
          if (phone.isEmpty) phone = c.phone ?? '';
          break;
        }
      }
    }
    return (name: name, phone: phone);
  }

  ////////////////////////////////////////////////////////////////////////////////
  /// WRITE TEMPFILE
  ////////////////////////////////////////////////////////////////////////////////

  Future<File> _writeTempFile(String name, List<int> bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  ////////////////////////////////////////////////////////////////////////////////
  ///  DOWNLOADING FILE
  ////////////////////////////////////////////////////////////////////////////////

  Future<Uint8List?> _downloadBytes(String? url) async {
    if (url == null || url.isEmpty) return null;
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) return response.bodyBytes;
    } catch (_) {}
    return null;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // CHARE PDG FILE
  ////////////////////////////////////////////////////////////////////////////////

  Future<void> _sharePdf() async {
    setState(() {
      _busy = true;
      _busyLabel = 'Generating PDF...';
    });
    try {
      final service = ref.read(quotationExportServiceProvider);
      final company = ref.read(companyProvider).valueOrNull?.company;
      final sealBytes = await _downloadBytes(company?.logoUrl);
      final customerInfo = _resolveCustomerInfo();

      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////

      final bytes = await service.buildPdf(
        quotation: widget.quotation,
        items: widget.items,
        englishName:
            company?.companyName ?? 'DUONG CHHIV JAPAN STANDARD COLOR PRINTING',
        companyAddress: company?.address ?? '',
        companyEmail: company?.email ?? '',
        companyPhones: company?.phone ?? '',
        customerTel: customerInfo.phone,
        sealImageBytes: sealBytes,
      );
      final file = await _writeTempFile(
        'Quotation_${widget.quotation.refNumber}.pdf',
        bytes,
      );
      if (mounted) Navigator.of(context).pop();
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Quotation ${widget.quotation.refNumber}');
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  ////////////////////////////////////////////////////////////////////////////////
  ///  SHERE IMAGE
  ////////////////////////////////////////////////////////////////////////////////

  Future<void> _sharePng() async {
    setState(() {
      _busy = true;
      _busyLabel = 'Generating image...';
    });
    try {
      final service = ref.read(quotationExportServiceProvider);
      final company = ref.read(companyProvider).valueOrNull?.company;
      final sealBytes = await _downloadBytes(company?.logoUrl);
      final customerInfo = _resolveCustomerInfo();
      final pdfBytes = await service.buildPdf(
        quotation: widget.quotation,
        items: widget.items,
        englishName:
            company?.companyName ?? 'DUONG CHHIV JAPAN STANDARD COLOR PRINTING',
        companyAddress: company?.address ?? '',
        companyEmail: company?.email ?? '',
        companyPhones: company?.phone ?? '',
        customerTel: customerInfo.phone,
        sealImageBytes: sealBytes,
      );

      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////

      final pngBytes = await service.pdfToPng(pdfBytes);
      final file = await _writeTempFile(
        'Quotation_${widget.quotation.refNumber}.png',
        pngBytes,
      );
      if (mounted) Navigator.of(context).pop();
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Quotation ${widget.quotation.refNumber}');
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  /// ERROR
  //////////////////////////////////////////////////////////////////////////////

  void _showError(Object e) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Failed to export: $e')));
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
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    if (_busy) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? Pallets.surfaceCard : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text(_busyLabel ?? 'Working...'),
          ],
        ),
      );
    }
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    if (!_ready) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? Pallets.surfaceCard : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Loading customer & company info...'),
          ],
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        decoration: BoxDecoration(
          color: isDark ? Pallets.surfaceCard : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Pallets.textMuted.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
            Text(
              'Send to client',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? Pallets.textPrimaryDark
                    : Pallets.textPrimaryLight,
              ),
            ),
            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
            const SizedBox(height: 16),
            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
            ListTile(
              leading: const Icon(
                Icons.picture_as_pdf_outlined,
                color: Colors.red,
              ),
              title: const Text('Share as PDF'),
              subtitle: const Text('Full document, best for printing / email'),
              onTap: _sharePdf,
            ),

            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
            ListTile(
              leading: const Icon(Icons.image_outlined, color: Colors.blue),
              title: const Text('Share as Image (PNG)'),
              subtitle: const Text('Quick preview image, good for chat apps'),
              onTap: _sharePng,
            ),
          ],
        ),
      ),
    );
  }
}
