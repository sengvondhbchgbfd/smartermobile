import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/pdf/invoice_pdf_text_helper.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/pdf/number_to_ward.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePdfSummary {
  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////
  static Future<pw.Widget> amountInWordsLine(
    double amount,
    bool hasKhmerFont,
  ) async {
    final label = await InvoicePdfTextHelper.bilingualLabel(
      'ចំនួនទឹកប្រាក់ជាអក្សរ',
      'Amount in text',
      khFontSize: 8.5,
      enFontSize: 8,
      color: PdfColors.black,
      hasKhmerFont: hasKhmerFont,
    );

    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        label,
        pw.SizedBox(width: 6),
        pw.Text(':', style: const pw.TextStyle(fontSize: 9)),
        pw.SizedBox(width: 6),
        pw.Expanded(
          child: pw.Container(
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.6),
              ),
            ),
            padding: const pw.EdgeInsets.only(bottom: 2),
            child: pw.Text(
              NumberToWords.amountToWords(amount),
              style: const pw.TextStyle(fontSize: 9),
            ),
          ),
        ),
      ],
    );
    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////
  }

  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////
  static Future<pw.Widget> signatureBlock(bool hasKhmerFont) async {
    Future<pw.Widget> sig(String khmerLabel, String englishLabel) async {
      final khWidget = await InvoicePdfTextHelper.autoText(
        khmerLabel,
        fontSize: 10,
        weight: pw.FontWeight.bold,
        hasKhmerFont: hasKhmerFont,
      );
      return pw.Expanded(
        child: pw.Column(
          children: [
            khWidget,
            pw.Text(
              englishLabel,
              style: pw.TextStyle(
                fontSize: 9,
                fontStyle: pw.FontStyle.italic,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 18),
            pw.Text(
              'Name: ...........................',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ],
        ),
      );
    }
    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////

    final manager = await sig('ប្រធានគ្រប់គ្រង', 'Manager');
    final preparedBy = await sig('អ្នកចេញវិក័យបត្រ', 'Prepared by');
    final receivedBy = await sig('អ្នកទទួលទំនិញ', 'Received By');
    return pw.Row(children: [manager, preparedBy, receivedBy]);
  }

  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////

  static Future<pw.Widget> footer(
    String khmer,
    String english,
    bool hasKhmerFont,
  ) async {
    final khWidget = await InvoicePdfTextHelper.autoText(
      khmer,
      fontSize: 8,
      weight: pw.FontWeight.bold,
      color: PdfColors.grey800,
      hasKhmerFont: hasKhmerFont,
    );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(height: 1, color: PdfColors.blue900),
        pw.SizedBox(height: 6),
        khWidget,
        pw.SizedBox(height: 2),
        pw.Text(
          english,
          style: pw.TextStyle(
            fontSize: 8,
            fontStyle: pw.FontStyle.italic,
            color: PdfColors.grey700,
          ),
        ),
      ],
    );
  }
}
