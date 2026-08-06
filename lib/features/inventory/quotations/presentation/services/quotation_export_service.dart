import 'dart:typed_data';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/khmer_text_widget.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotation_asset_loader.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotation_description_cell_builder.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotation_header_builder.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotation_image_export.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotation_info_block_builder.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotation_items_table_builder.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotation_signature_footer_builder.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotation_totals_note_terms_builder.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../domain/entities/quotation_entity.dart';
import '../../domain/entities/quotation_item_entity.dart';

class QuotationExportService {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  final _dateFmt = DateFormat('dd-MM-yyyy');
  final _qtyFmt = NumberFormat('#,###');
  final _currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  final _assets = QuotationAssetLoader();
  Future<Uint8List> buildPdf({
    required QuotationEntity quotation,
    required List<QuotationItemEntity> items,
    String khmerLine = 'ដួងឈីវ បោះពុម្ភពណ៍ធម្មជាតិស្តង់ដារជប៉ុន',
    String chineseLine = '棉美新日式彩色印刷有限公司',
    String englishName = 'DUONG CHHIV JAPAN STANDARD COLOR PRINTING',
    String companyAddress =
        'Betong Str, Phum Thmey, Sangkat Dangkao, Khan Dangkao, Phnom Penh.',
    String companyPhones =
        'H/P: 012 333 167 / 011 670 008, 069 374 777   Tel : 855-23-995 047',
    String companyEmail = 'doungchhivprintting@gmail.com',
    String infoCallLine =
        '-For more information please Call 069 374 777/ 097 7512 785',
    String customerTel = '',
    String documentNo = '',
    String managerName = '',
    Uint8List? sealImageBytes,
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
  }) async {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    await _assets.ensureLoaded(sealBytes: sealImageBytes);
    final header = await QuotationHeaderBuilder.build(
      khmerLine: khmerLine,
      chineseLine: chineseLine,
      englishName: englishName,
      logoBytes: _assets.logoBytes,
    );
    final infoBlock = await QuotationInfoBlockBuilder.build(
      quotation,
      customerTel,
      _dateFmt.format,
    );
    final itemsTable = await QuotationItemsTableBuilder.build(
      items,
      descriptionCellBuilder: QuotationDescriptionCellBuilder.build,
      qtyFmt: (n) => _qtyFmt.format(n),
      currencyFmt: (n) => _currency.format(n),
    );
    final note = await QuotationTotalsNoteTermsBuilder.buildNote(quotation);
    final paymentTerms =
        await QuotationTotalsNoteTermsBuilder.buildPaymentTerms(quotation);

    final doc = pw.Document(
      theme: pw.ThemeData.withFont(
        base: pw.Font.helvetica(),
        bold: pw.Font.helveticaBold(),
        italic: pw.Font.helveticaOblique(),
        fontFallback: [_assets.khmerFont!, _assets.cjkFont!],
      ),
    );
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final documentNumberWidget = await KhmerTextRenderer.autoText(
      'លេខ$documentNo${'.' * (documentNo.isEmpty ? 14 : 13)}',
      fontSize: 10,
      color: PdfColors.blue800,
    );

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.fromLTRB(28, 24, 28, 0),
          buildBackground: (context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Stack(
              children: [
                pw.Container(color: PdfColors.white),
                if (_assets.letterheadWatermarkBytes != null)
                  pw.Center(
                    child: pw.Image(
                      pw.MemoryImage(_assets.letterheadWatermarkBytes!),
                      width: 320,
                      height: 320,
                    ),
                  ),
              ],
            ),
          ),
        ),

        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        footer: (context) => QuotationSignatureFooterBuilder.buildFooterBar(
          companyAddress: companyAddress,
          companyPhones: companyPhones,
          companyEmail: companyEmail,
        ),

        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        build: (context) => [
          header,
          pw.SizedBox(height: 6),

          //////////////////////////
          //
          documentNumberWidget,
          ////////////////////////
          //
          ///////////////////////
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Text(
              'Quotation',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 14),

          ////////////////////////
          //
          ///////////////////////
          infoBlock,
          pw.SizedBox(height: 14),
          ////////////////////////
          //
          ///////////////////////
          itemsTable,
          QuotationTotalsNoteTermsBuilder.buildTotalRow(
            quotation,
            (n) => _currency.format(n),
          ),

          ////////////////////////
          //
          ///////////////////////
          pw.SizedBox(height: 16),
          note,
          pw.SizedBox(height: 10),
          paymentTerms,
          pw.SizedBox(height: 14),
          pw.Text(infoCallLine, style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 20),
          QuotationSignatureFooterBuilder.buildSignatureBlock(
            managerName,
            _assets.sealWatermarkBytes,
          ),
          pw.SizedBox(height: 24),
        ],

        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
      ),
    );

    return doc.save();
  }

  Future<({Uint8List pdf, Uint8List jpg})> buildPdfAndJpg({
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    required QuotationEntity quotation,
    required List<QuotationItemEntity> items,
    String khmerLine = 'ជួងឈិវ បោះពុម្ពពណ៌ធម្មជាតិស្តង់ដារជប៉ុន',
    String chineseLine = '棉美新日式彩色印刷有限公司',
    String englishName = 'DUONG CHHIV JAPAN STANDARD COLOR PRINTING',
    String companyAddress =
        'Betong Str, Phum Thmey, Sangkat Dangkao, Khan Dangkao, Phnom Penh.',
    String companyPhones =
        'H/P: 012 333 167 / 011 670 008, 069 374 777   Tel : 855-23-995 047',
    String companyEmail = 'doungchhivprintting@gmail.com',
    String infoCallLine =
        '-For more information please Call 069 374 777/ 097 7512 785',
    String customerTel = '',
    String documentNo = '',
    String managerName = '',
    Uint8List? sealImageBytes,
    double jpgDpi = 200,
    bool jpgAsPaperSheet = true,
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
  }) async {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final pdfBytes = await buildPdf(
      quotation: quotation,
      items: items,
      khmerLine: khmerLine,
      chineseLine: chineseLine,
      englishName: englishName,
      companyAddress: companyAddress,
      companyPhones: companyPhones,
      companyEmail: companyEmail,
      infoCallLine: infoCallLine,
      customerTel: customerTel,
      documentNo: documentNo,
      managerName: managerName,
      sealImageBytes: sealImageBytes,
    );

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final jpgBytes = await QuotationImageExport.pdfToJpg(
      pdfBytes,
      dpi: jpgDpi,
      asPaperSheet: jpgAsPaperSheet,
    );
    return (pdf: pdfBytes, jpg: jpgBytes);
  }

  Future<Uint8List> pdfToPng(Uint8List pdfBytes, {double dpi = 200}) =>
      QuotationImageExport.pdfToPng(pdfBytes, dpi: dpi);
  Future<Uint8List> pdfToJpg(
    Uint8List pdfBytes, {
    double dpi = 200,
    int quality = 90,
    bool asPaperSheet = true,
  }) => QuotationImageExport.pdfToJpg(
    pdfBytes,
    dpi: dpi,
    quality: quality,
    asPaperSheet: asPaperSheet,
  );
}
