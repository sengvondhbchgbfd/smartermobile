import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frontendmobile/core/utils/date_formatter.dart';
import 'package:frontendmobile/features/hr/attendance/domain/entities/attendance_entity.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/export_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class AttendanceExportHelper {
  const AttendanceExportHelper._();

  // ── CSV ───────────────────────────────────────────────────────────────────
  static Uint8List toCsv(List<AttendanceEntity> records) {
    final buffer = StringBuffer();

    buffer.writeln(
      'Attendance ID,Staff ID,Staff Name,Date,'
      'Check-In Time,Check-Out Time,'
      'Duration (hrs),Status,'
      'Latitude,Longitude',
    );

    for (final r in records) {
      final duration = _computeDuration(r.checkInTime, r.checkOutTime);
      final status = _status(r.checkInTime, r.checkOutTime);

      buffer.writeln(
        '${r.attendanceId},'
        '${r.staffId ?? ""},'
        '${_csvSafe(r.staffName)},'
        '${r.date ?? ""},'
        '${r.checkInTime ?? ""},'
        '${r.checkOutTime ?? ""},'
        '${duration ?? ""},'
        '$status,'
        '${r.latitude ?? ""},'
        '${r.longitude ?? ""}',
      );
    }

    return Uint8List.fromList(buffer.toString().codeUnits);
  }

  // ── PDF ───────────────────────────────────────────────────────────────────

  /// Builds a formatted PDF from attendance records.
  static Future<Uint8List> toPdf(
    List<AttendanceEntity> records, {
    required String title,
    required String dateRange,
  }) async {
    final doc = pw.Document();

    // Split into pages of 25 rows each
    const rowsPerPage = 25;
    final pages = <List<AttendanceEntity>>[];
    for (var i = 0; i < records.length; i += rowsPerPage) {
      pages.add(records.sublist(i, (i + rowsPerPage).clamp(0, records.length)));
    }
    if (pages.isEmpty) pages.add([]);

    for (var p = 0; p < pages.length; p++) {
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(24),
          build: (ctx) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,

            children: [
              // ── Header ────────────────────────────────────────────────
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        title,
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        dateRange,
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ],
                  ),
                  pw.Text(
                    'Page ${p + 1} of ${pages.length}',
                    style: pw.TextStyle(fontSize: 9, color: PdfColors.grey500),
                  ),
                ],
              ),

              pw.SizedBox(height: 4),
              pw.Divider(color: PdfColors.blueGrey200),
              pw.SizedBox(height: 8),

              // ── Summary row ───────────────────────────────────────────
              if (p == 0) ...[
                pw.Row(
                  children: [
                    _summaryCell('Total Records', '${records.length}'),
                    _summaryCell(
                      'Full Days',
                      '${records.where((r) => r.checkInTime != null && r.checkOutTime != null).length}',
                    ),
                    _summaryCell(
                      'Incomplete',
                      '${records.where((r) => r.checkInTime != null && r.checkOutTime == null).length}',
                    ),
                    _summaryCell(
                      'Absent',
                      '${records.where((r) => r.checkInTime == null).length}',
                    ),
                  ],
                ),
                pw.SizedBox(height: 12),
              ],

              // ── Table ─────────────────────────────────────────────────
              pw.Expanded(
                child: pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.blueGrey100,
                    width: 0.5,
                  ),
                  columnWidths: {
                    0: const pw.FixedColumnWidth(40), // ID
                    1: const pw.FixedColumnWidth(50), // Staff ID
                    2: const pw.FlexColumnWidth(2), // Name
                    3: const pw.FixedColumnWidth(70), // Date
                    4: const pw.FixedColumnWidth(60), // Check In
                    5: const pw.FixedColumnWidth(60), // Check Out
                    6: const pw.FixedColumnWidth(50), // Duration
                    7: const pw.FixedColumnWidth(55), // Status
                  },

                  children: <pw.TableRow>[
                    // Header row
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.blueGrey800,
                      ),
                      children:
                          [
                                'ID',
                                'Staff ID',
                                'Staff Name',
                                'Date',
                                'Check In',
                                'Check Out',
                                'Duration',
                                'Status',
                              ]
                              .map(
                                (h) => pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 5,
                                  ),
                                  child: pw.Text(
                                    h,
                                    style: pw.TextStyle(
                                      color: PdfColors.white,
                                      fontSize: 8,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),

                    ...pages[p].asMap().entries.map<pw.TableRow>((entry) {
                      final i = entry.key;
                      final r = entry.value;
                      final isEven = i % 2 == 0;
                      final status = _status(r.checkInTime, r.checkOutTime);
                      final statusColor = _statusPdfColor(status);
                      final duration = _computeDuration(
                        r.checkInTime,
                        r.checkOutTime,
                      );

                      final cells = <String>[
                        '${r.attendanceId}',
                        '${r.staffId ?? ""}',
                        r.staffName ?? '—',
                        _formatTime(r.checkInTime),
                        _formatTime(r.checkOutTime),
                        duration ?? '—',
                        status,
                      ];

                      return pw.TableRow(
                        decoration: pw.BoxDecoration(
                          color: isEven
                              ? PdfColors.white
                              : PdfColors.blueGrey50,
                        ),
                        children: List<pw.Widget>.generate(cells.length, (
                          index,
                        ) {
                          final isStatus = index == 7;
                          return pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 4,
                            ),
                            child: pw.Text(
                              cells[index], // <-- guaranteed String
                              style: pw.TextStyle(
                                fontSize: 8,
                                color: isStatus ? statusColor : PdfColors.black,
                                fontWeight: isStatus
                                    ? pw.FontWeight.bold
                                    : pw.FontWeight.normal,
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ],
                ),
              ),

              // ── Footer ────────────────────────────────────────────────
              pw.SizedBox(height: 6),
              pw.Text(
                'Generated on ${_today()}',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return doc.save();
  }

  // ── Share / save to device ────────────────────────────────────────────────

  /// Saves [bytes] to a temp file and opens the system share sheet.
  static Future<void> share(
    Uint8List bytes, {
    required ExportFormat format,
    required String filename,
    BuildContext? context,
  }) async {
    final ext = format == ExportFormat.csv ? 'csv' : 'pdf';
    final mimeType = format == ExportFormat.csv
        ? 'text/csv'
        : 'application/pdf';

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename.$ext');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([
      XFile(file.path, mimeType: mimeType),
    ], subject: filename);
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  /// Derive attendance status from backend check_in_time / check_out_time.
  static String _status(String? checkIn, String? checkOut) {
    if (checkIn == null || checkIn.isEmpty) return 'Absent';
    if (checkOut == null || checkOut.isEmpty) return 'Incomplete';
    return 'Present';
  }

  static PdfColor _statusPdfColor(String status) {
    switch (status) {
      case 'Present':
        return PdfColors.green800;
      case 'Incomplete':
        return PdfColors.orange800;
      default:
        return PdfColors.red800;
    }
  }

  /// Parse "HH:mm:ss" → Duration, compute difference, return "Xh Ym".
  static String? _computeDuration(String? checkIn, String? checkOut) {
    if (checkIn == null || checkOut == null) return null;
    final inTime = _parseTimeStr(checkIn);
    final outTime = _parseTimeStr(checkOut);
    if (inTime == null || outTime == null) return null;
    final diff = outTime - inTime;
    if (diff <= 0) return null;
    final hours = diff ~/ 3600;
    final minutes = (diff % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }

  /// Parse "HH:mm" or "HH:mm:ss" → total seconds since midnight.
  static int? _parseTimeStr(String raw) {
    final parts = raw.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final s = parts.length > 2 ? (int.tryParse(parts[2]) ?? 0) : 0;
    if (h == null || m == null) return null;
    return h * 3600 + m * 60 + s;
  }

  /// Format "HH:mm:ss" → "HH:mm" for display.
  static String _formatTime(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    return fmtKhmerTime(raw);
  }

  static String _csvSafe(String? v) {
    if (v == null) return '';
    if (v.contains(',') || v.contains('"') || v.contains('\n')) {
      return '"${v.replaceAll('"', '""')}"';
    }
    return v;
  }

  static String _today() {
    return DateFormatter.fmt(DateTime.now());
  }

  // ── PDF summary cell ──────────────────────────────────────────────────────

  static pw.Widget _summaryCell(String label, String value) {
    return pw.Expanded(
      child: pw.Container(
        margin: const pw.EdgeInsets.only(right: 8),
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          color: PdfColors.blueGrey50,
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              value,
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              label,
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
          ],
        ),
      ),
    );
  }
}
