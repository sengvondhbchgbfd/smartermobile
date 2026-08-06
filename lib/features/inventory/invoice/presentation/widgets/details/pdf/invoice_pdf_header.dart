import 'dart:typed_data';

import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/pdf/invoice_pdf_text_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePdfHeader {
  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////
  static pw.Widget doubleDivider() => pw.Column(
    children: [
      pw.Container(height: 1.4, color: PdfColors.blue900),
      pw.SizedBox(height: 2),
      pw.Container(height: 1.4, color: PdfColors.blue900),
    ],
  );
  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////
  static Future<pw.Widget> build(
    String nameKhmer,
    String? nameChinese,
    String nameEnglish,
    String address,
    String phone,
    String? tel,
    String email,
    Uint8List? logoBytes,
    bool logoIncludesText,
    bool hasKhmerFont,
    bool hasCjkFont,
  ) async {
    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////
    final companyKhmerWidget = await InvoicePdfTextHelper.autoText(
      nameKhmer,
      fontSize: 15,
      weight: pw.FontWeight.bold,
      color: PdfColors.orange800,
      hasKhmerFont: hasKhmerFont,
      hasCjkFont: hasCjkFont,
    );

    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////

    pw.Widget? chineseWidget;
    if (nameChinese != null && nameChinese.isNotEmpty) {
      chineseWidget = await InvoicePdfTextHelper.autoText(
        nameChinese,
        fontSize: 13,
        weight: pw.FontWeight.bold,
        color: PdfColors.red,
        hasKhmerFont: hasKhmerFont,
        hasCjkFont: hasCjkFont,
      );
    }

    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////

    pw.Widget labeledLine(String label, String value) => pw.RichText(
      textAlign: pw.TextAlign.center,
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: '$label ',
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
          pw.TextSpan(
            text: value,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.blue900),
          ),
        ],
      ),
    );

    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////

    final textColumn = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Center(child: companyKhmerWidget),
        if (chineseWidget != null) pw.Center(child: chineseWidget),
        pw.Text(
          nameEnglish,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 4),
        labeledLine('ADDRESS', address),
        labeledLine('H/P:', phone),
        if (tel != null) labeledLine('Tel:', tel),
        labeledLine('E-mail:', email),
      ],
    );

    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////

    if (logoIncludesText && logoBytes != null) {
      return pw.Row(
        // crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.center,
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Container(
            height: 140,
            child: pw.Image(pw.MemoryImage(logoBytes), fit: pw.BoxFit.contain),
          ),
          pw.SizedBox(width: 10),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                labeledLine('ADDRESS', address),
                labeledLine('H/P:', phone),
                if (tel != null) labeledLine('Tel:', tel),
                labeledLine('E-mail:', email),
              ],
            ),
          ),
        ],
      );
    }
    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////

    return pw.Center(
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          if (logoBytes != null) ...[
            pw.Container(
              width: 130,
              height: 130,
              child: pw.Image(
                pw.MemoryImage(logoBytes),
                fit: pw.BoxFit.contain,
              ),
            ),
            pw.SizedBox(width: 10),
          ],
          textColumn,
        ],
      ),
    );
  }

  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////

  static Future<pw.Widget> titleBlock(bool hasKhmerFont) async {
    final titleKh = await InvoicePdfTextHelper.autoText(
      'វិក័យប័ត្រ',
      fontSize: 15,
      weight: pw.FontWeight.bold,
      color: PdfColors.blue900,
      hasKhmerFont: hasKhmerFont,
    );
    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////
    return pw.Center(
      child: pw.Column(
        children: [
          titleKh,
          pw.Text(
            'Invoice',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: 12,
              fontStyle: pw.FontStyle.italic,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
        ],
      ),
    );
    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////
  }
}
