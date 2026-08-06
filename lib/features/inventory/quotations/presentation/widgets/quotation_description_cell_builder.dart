import 'package:pdf/widgets.dart' as pw;
import '../../domain/entities/quotation_item_entity.dart';
import 'khmer_text_widget.dart';

class QuotationDescriptionCellBuilder {
  static Future<pw.Widget> build(QuotationItemEntity item) async {
    Future<pw.Widget> line(String label, String? value) async {
      if (value == null || value.trim().isEmpty) return pw.SizedBox.shrink();
      final valueWidget = await KhmerTextRenderer.autoText(
        value,
        fontSize: 9.5,
        maxWidth: 260,
      );
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 1),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              '$label: ',
              style: pw.TextStyle(
                fontSize: 9.5,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Expanded(child: valueWidget),
          ],
        ),
      );
    }

    final printSpec = [
      item.printSide,
      item.colorSpec,
    ].whereType<String>().where((s) => s.isNotEmpty).join(' ');
    final paperSpec = [
      item.paperCover,
      item.paperInside,
    ].whereType<String>().where((s) => s.isNotEmpty).join(' / ');

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          await line('Item', item.itemName),
          await line('Size', item.size),
          if (printSpec.isNotEmpty) await line('Print', printSpec),
          if (paperSpec.isNotEmpty) await line('Paper', paperSpec),
          await line('Finishing', item.finishing),
          await line('Language', item.language),
          if ((item.note ?? '').isNotEmpty) await line('Note', item.note),
        ],
      ),
    );
  }
}
