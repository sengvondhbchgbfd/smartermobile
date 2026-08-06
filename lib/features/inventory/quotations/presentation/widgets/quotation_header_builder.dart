import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'khmer_text_widget.dart';

class QuotationHeaderBuilder {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  static Future<pw.Widget> build({
    required String khmerLine,
    required String chineseLine,
    required String englishName,
    required Uint8List? logoBytes,
  }) async {
    final khmerWidget = await KhmerTextRenderer.autoText(
      khmerLine,
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.yellow800,
      maxWidth: 380,
    );
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (logoBytes != null)
          pw.Container(
            width: 80,
            height: 80,
            alignment: pw.Alignment.topLeft,
            child: pw.Image(pw.MemoryImage(logoBytes), fit: pw.BoxFit.contain),
          )
        else
          pw.SizedBox(width: 80),

        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              khmerWidget,
              pw.SizedBox(height: 2),

              pw.Text(
                chineseLine,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red300,
                ),
              ),

              pw.SizedBox(height: 2),

              pw.Text(
                englishName,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
            ],
          ),
        ),

        pw.SizedBox(width: 80),
      ],
    );
  }
}
