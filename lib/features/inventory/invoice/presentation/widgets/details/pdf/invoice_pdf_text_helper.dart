import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/pdf/khmer_text.dart';

class InvoicePdfTextHelper {
  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////
  static bool hasKhmer(String s) =>
      s.runes.any((r) => r >= 0x1780 && r <= 0x17FF);

  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////
  static bool hasCjk(String s) => s.runes.any(
    (r) =>
        (r >= 0x4E00 && r <= 0x9FFF) ||
        (r >= 0x3400 && r <= 0x4DBF) ||
        (r >= 0xF900 && r <= 0xFAFF),
  );
  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////

  static Future<pw.Widget> autoText(
    String text, {
    required double fontSize,
    pw.FontWeight weight = pw.FontWeight.normal,
    PdfColor color = PdfColors.black,
    required bool hasKhmerFont,
    bool hasCjkFont = false,
    double? maxWidthPt,
  }) async {
    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////
    final isKhmer = hasKhmerFont && hasKhmer(text);
    final isCjk = hasCjkFont && hasCjk(text);

    if (!isKhmer && !isCjk) {
      return pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: fontSize,
          fontWeight: weight,
          color: color,
        ),
      );
    }

    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////
    return KhmerText.render(
      text,
      fontSize: fontSize,
      bold: weight == pw.FontWeight.bold,
      color: color,
      maxWidthPt: maxWidthPt,
      useCjkFont: isCjk,
    );
  }

  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////
  static Future<pw.Widget> bilingualLabel(
    String khmer,
    String english, {
    double khFontSize = 8.5,
    double enFontSize = 8,
    PdfColor color = PdfColors.blue900,
    bool bold = true,
    required bool hasKhmerFont,
  }) async {
    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////
    final khWidget = await autoText(
      khmer,
      fontSize: khFontSize,
      weight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      color: color,
      hasKhmerFont: hasKhmerFont,
    );
    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////
    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        khWidget,
        pw.Text(
          english,
          style: pw.TextStyle(
            fontSize: enFontSize,
            fontStyle: pw.FontStyle.italic,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////
  }
}
