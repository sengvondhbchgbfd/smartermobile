import 'dart:io';
import 'package:excel/excel.dart' as ex;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:frontendmobile/features/inventory/quotations/presentation/services/text_to_image.dart';
import 'package:frontendmobile/features/inventory/stock_movements/domain/entities/stock_movement_report_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class StockReportExport {
  // ══════════════════════════════════════════════════════════════════
  // Shared helpers
  // ══════════════════════════════════════════════════════════════════

  static String _money(double v) => '\$${v.toStringAsFixed(2)}';

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const _monthsFull = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static String _formatPeriod(String raw) {
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw; // fall back if it isn't a parseable date
    return '${_months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  static String _formatFullDate(DateTime d) =>
      '${_monthsFull[d.month - 1]} ${d.day}, ${d.year}';

  /// Builds a human-readable title reflecting the *specific* date filter
  /// that was applied — e.g. "August 2026", "Jul 1 – Jul 7, 2026", "2026" —
  /// instead of just the generic period type ("month", "week", ...).
  /// Falls back to a capitalized period name when no anchor dates are set.
  static String periodFilterTitle(
    String period,
    DateTime? start,
    DateTime? end,
  ) {
    switch (period) {
      case 'day':
        if (start != null) return _formatFullDate(start);
        return 'Day';
      case 'week':
        if (start != null && end != null) {
          // end is exclusive (bumped by 1 day when the range was picked),
          // so the last *included* day is end minus one day.
          final inclusiveEnd = end.subtract(const Duration(days: 1));
          if (_isSameDay(start, inclusiveEnd)) return _formatFullDate(start);
          return '${_formatFullDate(start)} – ${_formatFullDate(inclusiveEnd)}';
        }
        if (start != null) return _formatFullDate(start);
        return 'Week';
      case 'month':
        if (start != null)
          return '${_monthsFull[start.month - 1]} ${start.year}';
        return 'Month';
      case 'year':
        if (start != null) return '${start.year}';
        return 'Year';
      default:
        return 'All Time';
    }
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Makes a title safe to embed in a filename.
  static String _fileSafeTitle(String title) =>
      title.replaceAll(RegExp(r'[^\w\-]+'), '_');

  static Future<File> _writeAndShare(
    List<int> bytes,
    String filename,
    String subject,
  ) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file.path)], subject: subject);
    return file;
  }

  static const List<int> _contextFlex = [10, 15, 16, 9, 12];
  static const List<int> _stageFlex = [5, 6, 7];
  // Trailing standalone column (Net Value) — same width as a stage "Total" cell.
  static const int _netValueFlex = 7;

  // static int get _contextFlexSum => _contextFlex.reduce((a, b) => a + b);
  // static int get _stageFlexSum => _stageFlex.reduce((a, b) => a + b);

  // ══════════════════════════════════════════════════════════════════
  // Excel export
  // ══════════════════════════════════════════════════════════════════

  static Future<void> exportExcel(
    StockMovementReportEntity report,
    String period, {
    DateTime? start,
    DateTime? end,
  }) async {
    final title = periodFilterTitle(period, start, end);

    final wb = ex.Excel.createExcel();
    final sheet = wb['Stock Report'];
    wb.delete('Sheet1');

    // ---- Row 0 (above the grouped header): the specific filter title ----
    sheet
        .cell(ex.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
        .value = ex.TextCellValue(
      'Stock Movement Report - $title',
    );
    sheet.merge(
      ex.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
      ex.CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0),
    );

    const stageNames = ['Beginning', 'In', 'Out', 'Balance'];
    var col = _contextFlex.length;
    for (final stage in stageNames) {
      sheet
          .cell(ex.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
          .value = ex.TextCellValue(
        stage,
      );
      sheet.merge(
        ex.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
        ex.CellIndex.indexByColumnRow(columnIndex: col + 2, rowIndex: 0),
      );
      col += 3;
    }

    // Trailing standalone header: Net Value (spans both header rows, like a
    // single context column — it isn't a Qty/Price/Total triple).
    sheet
        .cell(ex.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
        .value = ex.TextCellValue(
      'Net Value',
    );
    sheet.merge(
      ex.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
      ex.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 1),
    );

    const contextNames = [
      'Period',
      'Product',
      'Description',
      'SKU',
      'Category',
    ];

    // ---- Row 1: sub headers ----
    final subHeaders = [
      ...contextNames,
      'Qty',
      'Price',
      'Total',
      'Qty',
      'Price',
      'Total',
      'Qty',
      'Price',
      'Total',
      'Qty',
      'Price',
      'Total',
      '', // blank sub-header under merged "Net Value"
    ];
    sheet.appendRow(subHeaders.map((h) => ex.TextCellValue(h)).toList());

    for (final b in report.buckets) {
      final beginTotal = (b.openingBalance != null && b.price != null)
          ? b.openingBalance! * b.price!
          : null;
      // Prefer the backend-computed closing stock value; fall back to a
      // local calc so older API responses (missing the new field) still work.
      final endTotal =
          b.closingStockValue ??
          ((b.closingBalance != null && b.price != null)
              ? b.closingBalance! * b.price!
              : null);

      sheet.appendRow([
        ex.TextCellValue(_formatPeriod(b.periodLabel)),
        ex.TextCellValue(b.productName ?? ''),
        ex.TextCellValue(b.productDescription ?? ''),
        ex.TextCellValue(b.variantSku ?? ''),
        ex.TextCellValue(b.categoryName ?? ''),
        // Beginning
        b.openingBalance != null
            ? ex.IntCellValue(b.openingBalance!)
            : ex.TextCellValue('-'),
        b.price != null ? ex.DoubleCellValue(b.price!) : ex.TextCellValue('-'),
        beginTotal != null
            ? ex.DoubleCellValue(beginTotal)
            : ex.TextCellValue('-'),
        // In
        ex.IntCellValue(b.qtyIn),
        b.price != null ? ex.DoubleCellValue(b.price!) : ex.TextCellValue('-'),
        ex.DoubleCellValue(b.valueIn),
        // Out
        ex.IntCellValue(b.qtyOut),
        b.price != null ? ex.DoubleCellValue(b.price!) : ex.TextCellValue('-'),
        ex.DoubleCellValue(b.valueOut),
        // Balance / End — this IS the closing stock value column
        b.closingBalance != null
            ? ex.IntCellValue(b.closingBalance!)
            : ex.TextCellValue('-'),
        b.price != null ? ex.DoubleCellValue(b.price!) : ex.TextCellValue('-'),
        endTotal != null ? ex.DoubleCellValue(endTotal) : ex.TextCellValue('-'),
        // Trailing: per-row Net Value (flow metric, distinct from the
        // Balance/End Total above it, which is a point-in-time stock value)
        ex.DoubleCellValue(b.netValue),
      ]);
    }

    sheet.appendRow([]);
    sheet.appendRow([
      ex.TextCellValue('TOTAL'),
      ex.TextCellValue(''),
      ex.TextCellValue(''),
      ex.TextCellValue(''),
      ex.TextCellValue(''), // Product..Category
      ex.TextCellValue(''),
      ex.TextCellValue(''),
      ex.TextCellValue(''), // Beginning Qty/Price/Total
      ex.IntCellValue(report.totalQtyIn),
      ex.TextCellValue(''),
      ex.DoubleCellValue(report.totalValueIn), // In
      ex.IntCellValue(report.totalQtyOut),
      ex.TextCellValue(''),
      ex.DoubleCellValue(report.totalValueOut), // Out
      ex.TextCellValue(''),
      ex.TextCellValue(''),
      // Balance/End Total = sum of closing stock values across all rows,
      // matching the per-row "closing stock value" column directly above it
      report.totalClosingStockValue != null
          ? ex.DoubleCellValue(report.totalClosingStockValue!)
          : ex.TextCellValue('-'),
      // Trailing Net Value total — matches the per-row Net Value column
      ex.DoubleCellValue(report.totalNetValue),
    ]);

    final bytes = wb.encode()!;
    await _writeAndShare(
      bytes,
      'stock_report_${_fileSafeTitle(title)}.xlsx',
      'Stock Report - $title',
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // PDF export — Khmer text rasterized to images (pdf fonts lack glyphs).
  // ══════════════════════════════════════════════════════════════════

  static bool _hasKhmer(String text) {
    return text.runes.any((r) => r >= 0x1780 && r <= 0x17FF);
  }

  static Future<pw.Widget> _cell(
    String text, {
    double fontSize = 8,
    pw.FontWeight weight = pw.FontWeight.normal,
    double maxWidth = 140,
  }) async {
    if (text.isEmpty) {
      return pw.Text('-', style: const pw.TextStyle(fontSize: 8));
    }
    if (!_hasKhmer(text)) {
      return pw.Text(
        text,
        style: pw.TextStyle(fontSize: fontSize, fontWeight: weight),
      );
    }

    final (bytes, w, h) = await TextToImage.renderSized(
      text,
      fontSize: fontSize * 2.2,
      fontWeight: weight == pw.FontWeight.bold
          ? FontWeight.w700
          : FontWeight.normal,
      maxWidth: maxWidth * 2.2,
      pixelRatio: 3.0,
    );

    return pw.Image(
      pw.MemoryImage(bytes),
      width: w / 2.2,
      height: h / 2.2,
      fit: pw.BoxFit.fitWidth,
    );
  }

  static Future<List<_BucketCells>> _prepareRows(
    List<StockMovementReportBucket> buckets,
  ) async {
    final rows = <_BucketCells>[];
    for (final b in buckets) {
      final beginTotal = (b.openingBalance != null && b.price != null)
          ? b.openingBalance! * b.price!
          : null;
      final endTotal =
          b.closingStockValue ??
          ((b.closingBalance != null && b.price != null)
              ? b.closingBalance! * b.price!
              : null);
      final priceStr = b.price != null ? _money(b.price!) : '-';

      rows.add(
        _BucketCells(
          period: _formatPeriod(b.periodLabel),
          product: await _cell(
            b.productName ?? '-',
            weight: pw.FontWeight.bold,
          ),
          description: await _cell(b.productDescription ?? '-'),
          sku: await _cell(b.variantSku ?? '-'),
          category: await _cell(b.categoryName ?? '-'),
          beginQty: b.openingBalance?.toString() ?? '-',
          beginPrice: priceStr,
          beginTotal: beginTotal != null ? _money(beginTotal) : '-',
          inQty: '${b.qtyIn}',
          inPrice: priceStr,
          inTotal: _money(b.valueIn),
          outQty: '${b.qtyOut}',
          outPrice: priceStr,
          outTotal: _money(b.valueOut),
          endQty: b.closingBalance?.toString() ?? '-',
          endPrice: priceStr,
          endTotal: endTotal != null ? _money(endTotal) : '-',
          netValue: _money(b.netValue),
        ),
      );
    }
    return rows;
  }

  static pw.Widget _summaryBox(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  /// [title] is the specific date-filter title (e.g. "August 2026"), not
  /// the raw period type — so the header reflects exactly what was filtered.
  static pw.Widget _buildHeader(String title) {
    return pw.Header(
      level: 0,
      child: pw.Text(
        'Stock Movement Report - $title',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _buildSummaryRow(StockMovementReportEntity report) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _summaryBox('Qty In', '${report.totalQtyIn}'),
        _summaryBox('Qty Out', '${report.totalQtyOut}'),
        _summaryBox('Net Value', _money(report.totalNetValue)),
        _summaryBox(
          'Closing Stock Value',
          report.totalClosingStockValue != null
              ? _money(report.totalClosingStockValue!)
              : '-',
        ),
      ],
    );
  }

  // ---- grouped header: built with pw.Table (not Row/Expanded) ----
  //
  // pw.Expanded/Row+stretch need a BOUNDED height from their parent to
  // divide space, but MultiPage flows content with unbounded height —
  // that mismatch is what threw "Page height (Infinity) exceeds...".
  // pw.Table only needs bounded WIDTH (the page width, always bounded),
  // so building the header as a Table sidesteps the problem entirely,
  // and guarantees pixel-perfect alignment with the data table since
  // both share the exact same column-width map.

  static Map<int, pw.TableColumnWidth> _columnWidthsMap() {
    final widths = <int>[..._contextFlex];
    for (var i = 0; i < 4; i++) {
      widths.addAll(_stageFlex);
    }
    widths.add(_netValueFlex); // trailing Net Value column
    return {
      for (var i = 0; i < widths.length; i++)
        i: pw.FlexColumnWidth(widths[i].toDouble()),
    };
  }

  static pw.Widget _headerCell(
    String text, {
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
    bool bold = true,
    double fontSize = 9,
    PdfColor? bg,
  }) {
    const line = pw.BorderSide(color: PdfColors.grey600, width: 0.4);
    return pw.Container(
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 2),
      decoration: pw.BoxDecoration(
        color: bg,
        border: pw.Border(
          top: top ? line : pw.BorderSide.none,
          bottom: bottom ? line : pw.BorderSide.none,
          left: left ? line : pw.BorderSide.none,
          right: right ? line : pw.BorderSide.none,
        ),
      ),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: fontSize,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Table _buildGroupedHeader() {
    const contextNames = [
      'Period',
      'Product',
      'Description',
      'SKU',
      'Category',
    ];
    const stageNames = ['Beginning', 'In', 'Out', 'Balance or End'];
    final row1 = <pw.Widget>[
      for (final name in contextNames)
        _headerCell(name, bottom: false, bg: PdfColors.grey300),
    ];
    for (final stage in stageNames) {
      row1.addAll([
        _headerCell('', right: false, bg: PdfColors.grey300),
        _headerCell(stage, left: false, right: false, bg: PdfColors.grey300),
        _headerCell('', left: false, bg: PdfColors.grey300),
      ]);
    }
    // Trailing standalone header — spans both header rows like the
    // context columns (it's a single value, not a Qty/Price/Total triple).
    row1.add(_headerCell('Net Value', bottom: false, bg: PdfColors.grey300));

    final row2 = <pw.Widget>[
      for (final _ in contextNames) _headerCell('', top: false),
    ];
    for (final _ in stageNames) {
      row2.addAll([
        _headerCell('Qty', fontSize: 8),
        _headerCell('Price', fontSize: 8),
        _headerCell('Total', fontSize: 8),
      ]);
    }
    row2.add(_headerCell('', top: false));

    return pw.Table(
      columnWidths: _columnWidthsMap(),
      children: [
        pw.TableRow(children: row1),
        pw.TableRow(children: row2),
      ],
    );
  }

  static pw.TableRow _buildDataRow(_BucketCells r) {
    final cells = [
      pw.Text(r.period, style: const pw.TextStyle(fontSize: 7)),
      r.product,
      r.description,
      r.sku,
      r.category,
      pw.Text(r.beginQty, style: const pw.TextStyle(fontSize: 7)),
      pw.Text(r.beginPrice, style: const pw.TextStyle(fontSize: 7)),
      pw.Text(r.beginTotal, style: const pw.TextStyle(fontSize: 7)),
      pw.Text(r.inQty, style: const pw.TextStyle(fontSize: 7)),
      pw.Text(r.inPrice, style: const pw.TextStyle(fontSize: 7)),
      pw.Text(r.inTotal, style: const pw.TextStyle(fontSize: 7)),
      pw.Text(r.outQty, style: const pw.TextStyle(fontSize: 7)),
      pw.Text(r.outPrice, style: const pw.TextStyle(fontSize: 7)),
      pw.Text(r.outTotal, style: const pw.TextStyle(fontSize: 7)),
      pw.Text(r.endQty, style: const pw.TextStyle(fontSize: 7)),
      pw.Text(r.endPrice, style: const pw.TextStyle(fontSize: 7)),
      pw.Text(r.endTotal, style: const pw.TextStyle(fontSize: 7)),
      pw.Text(r.netValue, style: const pw.TextStyle(fontSize: 7)),
    ];
    return pw.TableRow(
      children: cells
          .map((c) => pw.Padding(padding: const pw.EdgeInsets.all(3), child: c))
          .toList(),
    );
  }

  static Future<void> exportPdf(
    StockMovementReportEntity report,
    String period, {
    DateTime? start,
    DateTime? end,
  }) async {
    final title = periodFilterTitle(period, start, end);

    final rows = await _prepareRows(report.buckets);
    final regularData = await rootBundle.load(
      'assets/fonts/Roboto-Regular.ttf',
    );
    final boldData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');

    final doc = pw.Document(
      theme: pw.ThemeData.withFont(
        base: pw.Font.ttf(regularData),
        bold: pw.Font.ttf(boldData),
      ),
    );
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => [
          _buildHeader(title),
          pw.SizedBox(height: 12),
          _buildSummaryRow(report),
          pw.SizedBox(height: 16),
          _buildGroupedHeader(),
          pw.Table(
            columnWidths: _columnWidthsMap(),
            border: pw.TableBorder(
              left: const pw.BorderSide(color: PdfColors.grey300, width: 0.4),
              right: const pw.BorderSide(color: PdfColors.grey300, width: 0.4),
              bottom: const pw.BorderSide(color: PdfColors.grey300, width: 0.4),
              horizontalInside: const pw.BorderSide(
                color: PdfColors.grey300,
                width: 0.4,
              ),
              verticalInside: const pw.BorderSide(
                color: PdfColors.grey300,
                width: 0.4,
              ),
            ),
            children: rows.map(_buildDataRow).toList(),
          ),
        ],
      ),
    );
    final bytes = await doc.save();
    await _writeAndShare(
      bytes,
      'stock_report_${_fileSafeTitle(title)}.pdf',
      'Stock Report - $title',
    );
  }
}

class _BucketCells {
  final String period;
  final pw.Widget product;
  final pw.Widget description;
  final pw.Widget sku;
  final pw.Widget category;
  final String beginQty;
  final String beginPrice;
  final String beginTotal;
  final String inQty;
  final String inPrice;
  final String inTotal;
  final String outQty;
  final String outPrice;
  final String outTotal;
  final String endQty;
  final String endPrice;
  final String endTotal;
  final String netValue;

  _BucketCells({
    required this.period,
    required this.product,
    required this.description,
    required this.sku,
    required this.category,
    required this.beginQty,
    required this.beginPrice,
    required this.beginTotal,
    required this.inQty,
    required this.inPrice,
    required this.inTotal,
    required this.outQty,
    required this.outPrice,
    required this.outTotal,
    required this.endQty,
    required this.endPrice,
    required this.endTotal,
    required this.netValue,
  });
}
