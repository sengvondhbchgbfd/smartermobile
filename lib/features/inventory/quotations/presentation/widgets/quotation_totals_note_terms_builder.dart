import 'package:pdf/widgets.dart' as pw;
import '../../domain/entities/quotation_entity.dart';
import 'quotation_items_table_builder.dart';
import 'khmer_text_widget.dart';

class QuotationTotalsNoteTermsBuilder {
  static pw.Widget buildTotalRow(
    QuotationEntity q,
    String Function(num) currencyFmt,
  ) {
    return pw.Table(
      border: const pw.TableBorder(
        left: pw.BorderSide(width: 0.7),
        right: pw.BorderSide(width: 0.7),
        bottom: pw.BorderSide(width: 0.7),
      ),
      columnWidths: {
        0: const pw.FlexColumnWidth(7.4),
        1: const pw.FlexColumnWidth(1.3),
      },
      children: [
        pw.TableRow(
          children: [
            QuotationItemsTableBuilder.cell(
              'Total',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
              align: pw.Alignment.center,
            ),
            QuotationItemsTableBuilder.cell(
              currencyFmt(q.totalAmount),
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
              align: pw.Alignment.centerRight,
            ),
          ],
        ),
      ],
    );
  }

  static Future<pw.Widget> buildNote(QuotationEntity q) async {
    final days = q.productionDays;
    return pw.Text(
      'Note: Final Printing & Production is $days days on working day after agreeing on artwork design.',
      style: const pw.TextStyle(fontSize: 10),
    );
  }

  static Future<pw.Widget> buildPaymentTerms(QuotationEntity q) async {
    final terms = q.paymentTerms ?? '';
    final matches = RegExp(
      r'(\d{1,3})\s*%',
    ).allMatches(terms).map((m) => m.group(1)).toList();

    pw.Widget checkboxLine(String pct, String label) => pw.Row(
      children: [
        pw.Container(
          width: 10,
          height: 10,
          decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.8)),
        ),
        pw.SizedBox(width: 6),
        pw.Text('$pct%', style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(width: 10),
        pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
      ],
    );

    pw.Widget termsBody;
    if (matches.length >= 2) {
      termsBody = pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          checkboxLine(matches[0]!, 'In advance'),
          pw.SizedBox(height: 3),
          checkboxLine(matches[1]!, 'At delivery day'),
        ],
      );
    } else if (terms.isNotEmpty) {
      termsBody = await KhmerTextRenderer.autoText(
        terms,
        fontSize: 10,
        maxWidth: 480,
      );
    } else {
      termsBody = pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          checkboxLine('50', 'In advance'),
          pw.SizedBox(height: 3),
          checkboxLine('50', 'At delivery day'),
        ],
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Term of Payment:', style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 4),
        termsBody,
      ],
    );
  }
}
