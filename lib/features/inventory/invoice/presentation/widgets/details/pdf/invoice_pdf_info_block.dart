import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/pdf/invoice_pdf_text_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePdfInfoBlock {
  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////
  static String khmerDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    return 'ថ្ងៃទី $day ខែ $month ឆ្នាំ ${d.year}';
  }
  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////

  static dynamic _tryGet(dynamic obj, String field) {
    try {
      switch (field) {
        case 'customerAddress':
          return obj.customerAddress;
        default:
          return null;
      }
    } catch (_) {
      return null;
    }
  }

  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////
  static Future<pw.Widget> build(
    dynamic invoice,
    String customerName,
    bool hasKhmerFont,
  ) async {
    String safe(dynamic v) => (v ?? '').toString();
    final customerAddress = safe(_tryGet(invoice, 'customerAddress'));

    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////
    final custLabel = await InvoicePdfTextHelper.bilingualLabel(
      'ឈ្មោះអតិថិជន',
      "Customer's Name",
      hasKhmerFont: hasKhmerFont,
    );
    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////
    final addrLabel = await InvoicePdfTextHelper.bilingualLabel(
      'អាស័យដ្ឋាន',
      'Address',
      hasKhmerFont: hasKhmerFont,
    );
    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////
    final custValue = await InvoicePdfTextHelper.autoText(
      customerName,
      fontSize: 10,
      weight: pw.FontWeight.bold,
      hasKhmerFont: hasKhmerFont,
    );
    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////
    final addrValue = await InvoicePdfTextHelper.autoText(
      customerAddress,
      fontSize: 9,
      hasKhmerFont: hasKhmerFont,
    );
    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////
    final dateLine = await InvoicePdfTextHelper.autoText(
      khmerDate(invoice.createdAt),
      fontSize: 9,
      weight: pw.FontWeight.bold,
      hasKhmerFont: hasKhmerFont,
    );
    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////

    pw.Widget underlinedValue(pw.Widget value) => pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey500, width: 0.6),
        ),
      ),
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: value,
    );
    //////////////////////////////////////////////
    ///
    /////////////////////////////////////////////

    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blue900, width: 0.7),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          //////////////////////////////////////////////
          ///
          /////////////////////////////////////////////
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              custLabel,
              pw.SizedBox(width: 6),
              pw.Text(':', style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(width: 6),
              pw.Expanded(child: underlinedValue(custValue)),
              pw.SizedBox(width: 14),
              pw.Text(
                'N°: ',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red,
                ),
              ),
              pw.Text(
                invoice.invoiceId.toString().padLeft(6, '0'),
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red,
                ),
              ),
            ],
          ),

          //////////////////////////////////////////////
          ///
          /////////////////////////////////////////////
          pw.SizedBox(height: 8),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              addrLabel,
              pw.SizedBox(width: 6),
              pw.Text(':', style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(width: 6),
              pw.Expanded(child: underlinedValue(addrValue)),
              pw.SizedBox(width: 14),
              dateLine,
            ],
          ),
          //////////////////////////////////////////////
          ///
          /////////////////////////////////////////////
        ],
      ),
    );
  }
}
