import 'package:pdf/widgets.dart' as pw;
import '../../domain/entities/quotation_entity.dart';
import 'khmer_text_widget.dart';

class QuotationInfoBlockBuilder {
  static Future<pw.Widget> build(
    QuotationEntity q,
    String customerTel,
    DateFormatterFn dateFmt,
  ) async {
    Future<pw.Widget> row(String label, String value) async {
      final valueWidget = await KhmerTextRenderer.autoText(
        value,
        fontSize: 10,
        maxWidth: 380,
      );
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 4),
        child: pw.Row(
          children: [
            pw.SizedBox(
              width: 60,
              child: pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
            ),
            pw.Text(': ', style: const pw.TextStyle(fontSize: 10)),
            valueWidget,
          ],
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        await row('Date', dateFmt(q.quotationDate)),
        await row('To', q.customerName ?? ''),
        await row('Tell', customerTel),
        await row('Ref', q.refNumber),
        if ((q.staffName ?? '').isNotEmpty)
          await row('Prepared by', q.staffName!),
      ],
    );
  }
}

typedef DateFormatterFn = String Function(DateTime date);
