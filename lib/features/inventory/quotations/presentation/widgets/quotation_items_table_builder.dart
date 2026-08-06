import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../domain/entities/quotation_item_entity.dart';
import '../../domain/entities/quotation_price_tier.dart';

class QuotationItemsTableBuilder {
  static List<QuotationPriceTierEntity> _tiersFor(QuotationItemEntity item) {
    final tiers = item.priceTiers;
    if (tiers != null && tiers.isNotEmpty) return tiers;
    return [
      QuotationPriceTierEntity(
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        totalPrice: item.totalPrice,
      ),
    ];
  }

  static pw.Widget _tierColumn(
    List<String> lines, {
    pw.Alignment align = pw.Alignment.center,
    bool bold = false,
  }) {
    return pw.Container(
      alignment: align,
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: align == pw.Alignment.centerRight
            ? pw.CrossAxisAlignment.end
            : pw.CrossAxisAlignment.center,
        children: [
          for (final line in lines)
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 2),
              child: pw.Text(
                line,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
                ),
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget cell(
    String text, {
    pw.TextStyle? style,
    pw.Alignment align = pw.Alignment.centerLeft,
  }) {
    return pw.Container(
      alignment: align,
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: pw.Text(text, style: style ?? const pw.TextStyle(fontSize: 10)),
    );
  }

  static Future<pw.Widget> build(
    List<QuotationItemEntity> items, {
    required Future<pw.Widget> Function(QuotationItemEntity)
    descriptionCellBuilder,
    required String Function(num) qtyFmt,
    required String Function(num) currencyFmt,
  }) async {
    final headerStyle = pw.TextStyle(
      fontWeight: pw.FontWeight.bold,
      fontSize: 10,
    );
    final border = pw.TableBorder.all(color: PdfColors.black, width: 0.7);

    final itemRows = <pw.TableRow>[];
    for (final entry in items.asMap().entries) {
      final tiers = _tiersFor(entry.value);
      itemRows.add(
        pw.TableRow(
          children: [
            cell('${entry.key + 1}', align: pw.Alignment.center),
            await descriptionCellBuilder(entry.value),
            _tierColumn([
              for (final t in tiers) '${qtyFmt(t.quantity)}${t.unitLabel}',
            ]),
            _tierColumn([for (final t in tiers) currencyFmt(t.unitPrice)]),
            _tierColumn(
              [for (final t in tiers) currencyFmt(t.totalPrice)],
              align: pw.Alignment.centerRight,
              bold: true,
            ),
          ],
        ),
      );
    }

    return pw.Table(
      border: border,
      columnWidths: {
        0: const pw.FlexColumnWidth(0.5),
        1: const pw.FlexColumnWidth(4.5),
        2: const pw.FlexColumnWidth(1.3),
        3: const pw.FlexColumnWidth(1.1),
        4: const pw.FlexColumnWidth(1.3),
      },
      children: [
        pw.TableRow(
          children: [
            cell('N°', style: headerStyle, align: pw.Alignment.center),
            cell('Description', style: headerStyle, align: pw.Alignment.center),
            cell('Quantity', style: headerStyle, align: pw.Alignment.center),
            cell('Unit Price', style: headerStyle, align: pw.Alignment.center),
            cell('Amount', style: headerStyle, align: pw.Alignment.center),
          ],
        ),
        ...itemRows,
      ],
    );
  }
}
