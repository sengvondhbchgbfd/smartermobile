import 'dart:typed_data';

import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/pdf/invoice_pdf_header.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/pdf/invoice_pdf_info_block.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/pdf/invoice_pdf_item_table.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/pdf/invoice_pdf_summary.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/pdf/khmer_text.dart';

class InvoicePdfBuilder {
  static Future<void> layoutAndPrint({
    ///////////////////////////////////////////////////////
    ///
    ///////////////////////////////////////////////////////
    required dynamic invoice,
    required String Function(int) variantLabel,
    required String customerName,
    required PdfPageFormat format,
    required Future<void> Function({
      required String name,
      required Future<Uint8List> Function(PdfPageFormat) onLayout,
      required PdfPageFormat format,
    })
    ///////////////////////////////////////////////////////
    ///
    ///////////////////////////////////////////////////////
    layout,
    Uint8List? logoBytes,
    Uint8List? khmerFontBytes,
    bool logoIncludesText = false,
    ///////////////////////////////////////////////////////
    ///
    ///////////////////////////////////////////////////////
  }) {
    return layout(
      name: 'invoice_${invoice.invoiceId}',
      onLayout: (fmt) async => build(
        invoice,
        variantLabel,
        customerName,
        fmt,
        logoBytes: logoBytes,
        khmerFontBytes: khmerFontBytes,
        logoIncludesText: logoIncludesText,
      ),
      format: format,
    );
    ///////////////////////////////////////////////////////
    ///
    ///////////////////////////////////////////////////////
  }

  static Future<Uint8List> build(
    dynamic invoice,
    String Function(int) variantLabel,
    String customerName,
    PdfPageFormat format, {
    Uint8List? logoBytes,
    Uint8List? cjkFontBytes,
    Uint8List? khmerFontBytes,
    bool logoIncludesText = false,

    // ---- company header ----
    String companyNameKhmer = 'ជូងឈីវ បោះពុម្ពពណ៌ជាតិស្តង់ដារជប៉ុន',
    String? companyNameChinese = '棉美新日式彩色印刷有限公司',
    String companyNameEnglish = 'DUONG CHHIV JAPAN STANDARD COLOR PRINTING',
    String address =
        'Betong Str, Phum Thmey, Sangkat Dangkao, Khan Dangkao, Phnom Penh.',
    String phone = '012 333 167 / 011 670 008, 069 374 777',
    String? tel = '855-23-995 047',
    String email = 'd.c_printing@yahoo.com',
    // ---- bank details ----
    String bankName = 'ABA Bank',
    String bankAccountNumber = '000 198 851',
    String bankAccountName = 'DUONG SRUN',
    // ---- footer note ----
    String footerNoteKhmer =
        '*** បានលក់ហើយ និងទទួលនិត្យត្រូវចំនួនតាមក្បួនខាងលើក្នុងសភាគ្រឿងវត្ថុមេនា។',
    String footerNoteEnglish =
        '*** Goods once sold cannot be refunded or exchanged. Please check carefully before leaving.',
    int minRows = 10,
  }) async {
    if (khmerFontBytes != null) {
      await KhmerText.ensureRegistered(khmerFontBytes);
    }
    if (cjkFontBytes != null) {
      await KhmerText.ensureCjkRegistered(cjkFontBytes);
    }

    final doc = pw.Document();

    final totalAmount = (invoice.totalAmount ?? 0.0) as double;
    final discount = (invoice.discount ?? 0.0) as double;
    final tax = (invoice.tax ?? 0.0) as double;
    final subtotal = totalAmount + discount - tax;

    final hasKhmerFont = khmerFontBytes != null;
    final hasCjkFont = cjkFontBytes != null;

    // ---- Pre-render every widget that may contain Khmer text. ----

    final header = await InvoicePdfHeader.build(
      companyNameKhmer,
      companyNameChinese,
      companyNameEnglish,
      address,
      phone,
      tel,
      email,
      logoBytes,
      logoIncludesText,
      hasKhmerFont,
      hasCjkFont,
    );
    ///////////////////////////////////////////////////////
    ///
    ///////////////////////////////////////////////////////

    final titleBlock = await InvoicePdfHeader.titleBlock(hasKhmerFont);
    final infoBlock = await InvoicePdfInfoBlock.build(
      invoice,
      customerName,
      hasKhmerFont,
    );
    final itemsTable = await InvoicePdfItemsTable.build(
      invoice,
      variantLabel,
      minRows,
      hasKhmerFont,
    );
    final summaryBreakdown = await InvoicePdfItemsTable.summaryBreakdown(
      subtotal,
      discount,
      tax,
      hasKhmerFont,
    );
    final totalRow = await InvoicePdfItemsTable.totalRow(
      totalAmount,
      hasKhmerFont,
    );
    final amountInWordsLine = await InvoicePdfSummary.amountInWordsLine(
      totalAmount,
      hasKhmerFont,
    );
    final signatureBlock = await InvoicePdfSummary.signatureBlock(hasKhmerFont);
    final footer = await InvoicePdfSummary.footer(
      footerNoteKhmer,
      footerNoteEnglish,
      hasKhmerFont,
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(24),
        build: (ctx) => [
          header,
          pw.SizedBox(height: 8),
          InvoicePdfHeader.doubleDivider(),
          titleBlock,
          pw.SizedBox(height: 8),
          infoBlock,
          pw.SizedBox(height: 10),
          itemsTable,
          summaryBreakdown,
          totalRow,
          pw.SizedBox(height: 8),
          amountInWordsLine,
          pw.SizedBox(height: 4),
          pw.Text(
            '$bankName Account Number: $bankAccountNumber, Account Name: $bankAccountName',
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.SizedBox(height: 14),
          signatureBlock,
          pw.SizedBox(height: 10),
          footer,
        ],
      ),
    );
    return doc.save();
  }
}
