import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/pdf/invoice_pdf_text_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
class InvoicePdfItemsTable {
  static Future<pw.Widget> build(
    dynamic invoice,
    String Function(int) variantLabel,
    int minRows,
    bool hasKhmerFont,
  ) async {
    const cellStyle = pw.TextStyle(fontSize: 9);

    Future<pw.Widget> headerCell(
      String kh,
      String en, {
      pw.CrossAxisAlignment align = pw.CrossAxisAlignment.center,
      pw.TextAlign textAlign = pw.TextAlign.center,
    }) async {
      final khWidget = await InvoicePdfTextHelper.autoText(
        kh,
        fontSize: 8.5,
        weight: pw.FontWeight.bold,
        color: PdfColors.white,
        hasKhmerFont: hasKhmerFont,
      );
      return pw.Container(
        color: PdfColors.blue900,
        padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        child: pw.Column(
          mainAxisSize: pw.MainAxisSize.min,
          crossAxisAlignment: align,
          children: [
            khWidget,
            pw.Text(
              en,
              style: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              textAlign: textAlign,
            ),
          ],
        ),
      );
    }

    pw.Widget cell(String text, {pw.TextAlign align = pw.TextAlign.left}) =>
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: pw.Text(text, style: cellStyle, textAlign: align),
        );

    Future<pw.Widget> descriptionCell(String text) async {
      final w = await InvoicePdfTextHelper.autoText(
        text,
        fontSize: 9,
        hasKhmerFont: hasKhmerFont,
      );
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: w,
      );
    }

    final items = (invoice.items as List).toList();
    final rowCount = items.length < minRows ? minRows : items.length;

    final rows = <pw.TableRow>[
      pw.TableRow(
        children: [
          await headerCell('ល.រ', 'No.'),
          await headerCell(
            'រាយឈ្មោះទំនិញ',
            'Description',
            align: pw.CrossAxisAlignment.start,
            textAlign: pw.TextAlign.left,
          ),
          await headerCell('បរិមាណ', 'Quantity'),
          await headerCell('ថ្លៃរាយ', 'Unit Price'),
          await headerCell('សរុបទឹកប្រាក់', 'Amount'),
        ],
      ),
    ];

    pw.BoxDecoration rowLine() => const pw.BoxDecoration(
      border: pw.Border(
        bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.4),
      ),
    );

    for (var i = 0; i < rowCount; i++) {
      if (i < items.length) {
        final item = items[i];
        final qty = item.quantity ?? 0;
        final unitPrice = (item.unitPrice ?? 0.0) as double;
        final lineTotal = (item.totalPrice ?? 0.0) as double;

        // Inventory items resolve their name via variantId; custom /
        // quotation-origin items (no product/variant link) fall back to
        // whatever name was stored directly on the item.
        final String descText;
        if (item.variantId != null) {
          descText = variantLabel(item.variantId as int);
        } else {
          final name = item.itemName ?? 'Item';
          descText = item.size != null ? '$name (${item.size})' : name;
        }
        final descWidget = await descriptionCell(descText);

        rows.add(
          pw.TableRow(
            decoration: rowLine(),
            children: [
              cell('${i + 1}', align: pw.TextAlign.center),
              descWidget,
              cell('$qty', align: pw.TextAlign.center),
              cell(
                '\$${unitPrice.toStringAsFixed(2)}',
                align: pw.TextAlign.right,
              ),
              cell(
                '\$${lineTotal.toStringAsFixed(2)}',
                align: pw.TextAlign.right,
              ),
            ],
          ),
        );
      } else {
        rows.add(
          pw.TableRow(
            decoration: rowLine(),
            children: [
              cell('${i + 1}', align: pw.TextAlign.center),
              cell(''),
              cell(''),
              cell(''),
              cell(''),
            ],
          ),
        );
      }
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.4),
      columnWidths: const {
        0: pw.FlexColumnWidth(0.6),
        1: pw.FlexColumnWidth(3.5),
        2: pw.FlexColumnWidth(1),
        3: pw.FlexColumnWidth(1.4),
        4: pw.FlexColumnWidth(1.4),
      },
      children: rows,
    );
  }

  /// Plain "label : $amount" row used for the Subtotal / Discount / Tax
  /// lines that sit above the bold [totalRow].
  static Future<pw.Widget> _summaryLine(
    String khmer,
    String english,
    double amount,
    bool hasKhmerFont,
  ) async {
    final label = await InvoicePdfTextHelper.bilingualLabel(
      khmer,
      english,
      khFontSize: 9,
      enFontSize: 8,
      color: PdfColors.black,
      bold: false,
      hasKhmerFont: hasKhmerFont,
    );
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          left: pw.BorderSide(color: PdfColors.grey400, width: 0.4),
          right: pw.BorderSide(color: PdfColors.grey400, width: 0.4),
        ),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Container(
              alignment: pw.Alignment.centerRight,
              padding: const pw.EdgeInsets.symmetric(
                vertical: 3,
                horizontal: 8,
              ),
              child: label,
            ),
          ),
          pw.Container(
            width: 100,
            alignment: pw.Alignment.centerRight,
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            child: pw.Text(
              '\$${amount.toStringAsFixed(2)}',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }

  /// Subtotal / Discount / Tax breakdown shown above the total. Rows for
  /// discount and tax are only added when they're non-zero.
  static Future<pw.Widget> summaryBreakdown(
    double subtotal,
    double discount,
    double tax,
    bool hasKhmerFont,
  ) async {
    final children = <pw.Widget>[
      await _summaryLine('សរុបរង', 'Subtotal', subtotal, hasKhmerFont),
    ];
    if (discount != 0) {
      children.add(
        await _summaryLine('បញ្ចុះតម្លៃ', 'Discount', -discount, hasKhmerFont),
      );
    }
    if (tax != 0) {
      children.add(await _summaryLine('ពន្ធ', 'Tax', tax, hasKhmerFont));
    }
    return pw.Column(children: children);
  }

  static Future<pw.Widget> totalRow(double total, bool hasKhmerFont) async {
    final label = await InvoicePdfTextHelper.bilingualLabel(
      'សរុប',
      'Total',
      khFontSize: 10,
      enFontSize: 9,
      color: PdfColors.black,
      hasKhmerFont: hasKhmerFont,
    );

    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          left: pw.BorderSide(color: PdfColors.grey400, width: 0.4),
          right: pw.BorderSide(color: PdfColors.grey400, width: 0.4),
          bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.4),
        ),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Container(
              alignment: pw.Alignment.centerRight,
              padding: const pw.EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 8,
              ),
              child: label,
            ),
          ),
          pw.Container(
            width: 100,
            color: PdfColors.grey300,
            alignment: pw.Alignment.centerRight,
            padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: pw.Text(
              '\$${total.toStringAsFixed(2)}',
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
