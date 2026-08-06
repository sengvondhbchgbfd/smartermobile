import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class QuotationSignatureFooterBuilder {
  static pw.Widget buildSignatureBlock(
    String managerName,
    Uint8List? sealWatermarkBytes,
  ) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Stack(
          alignment: pw.Alignment.bottomLeft,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Best Regards,',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text('Manager', style: const pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 50),
                if (managerName.isNotEmpty)
                  pw.Text(
                    managerName,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
              ],
            ),
            if (sealWatermarkBytes != null)
              pw.Positioned(
                left: 50,
                bottom: 6,
                child: pw.Image(
                  pw.MemoryImage(sealWatermarkBytes),
                  width: 70,
                  height: 70,
                ),
              ),
          ],
        ),
        pw.Text(
          "Client's Signature",
          style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
        ),
      ],
    );
  }

  static pw.Widget buildFooterBar({
    required String companyAddress,
    required String companyPhones,
    required String companyEmail,
  }) {
    const baseStyle = pw.TextStyle(fontSize: 7.5, color: PdfColors.black);
    final boldStyle = baseStyle.copyWith(fontWeight: pw.FontWeight.bold);
    final hpTelMatch = RegExp(
      r'H/P:\s*(.*?)\s*Tel\s*:\s*(.*)$',
    ).firstMatch(companyPhones);

    pw.Widget addressLine;
    if (hpTelMatch != null) {
      final hpNumbers = hpTelMatch.group(1)?.trim() ?? '';
      final telNumber = hpTelMatch.group(2)?.trim() ?? '';
      addressLine = pw.RichText(
        textAlign: pw.TextAlign.center,
        text: pw.TextSpan(
          children: [
            pw.TextSpan(text: 'ADDRESS ', style: boldStyle),
            pw.TextSpan(text: '$companyAddress  ', style: baseStyle),
            pw.TextSpan(text: 'H/P: ', style: boldStyle),
            pw.TextSpan(text: '$hpNumbers   ', style: baseStyle),
            pw.TextSpan(text: 'Tel : ', style: boldStyle),
            pw.TextSpan(text: telNumber, style: baseStyle),
          ],
        ),
      );
    } else {
      addressLine = pw.Text(
        'ADDRESS $companyAddress $companyPhones',
        style: baseStyle,
        textAlign: pw.TextAlign.center,
      );
    }

    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(top: 12),
      padding: const pw.EdgeInsets.only(top: 6, bottom: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(width: 0.7, color: PdfColors.black),
        ),
      ),


      
      child: pw.Column(
        children: [
          addressLine,
          pw.SizedBox(height: 2),
          pw.RichText(
            text: pw.TextSpan(
              children: [
                pw.TextSpan(text: 'E-mail: ', style: boldStyle),
                pw.TextSpan(text: companyEmail, style: baseStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
