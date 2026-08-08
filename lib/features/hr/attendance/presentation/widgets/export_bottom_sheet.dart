import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

enum ExportFormat { csv, pdf }

class ExportRequest {
  const ExportRequest({
    required this.format,
    required this.startDate,
    required this.endDate,
    this.staffId,
  });

  final ExportFormat format;
  final DateTime startDate;
  final DateTime endDate;
  final int? staffId;
}

class ExportBottomSheet extends StatefulWidget {
  const ExportBottomSheet({super.key, required this.onExport});

  final Future<void> Function(ExportRequest) onExport;

  static Future<void> show(
    BuildContext context, {
    required Future<void> Function(ExportRequest) onExport,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? Pallets.surfaceOverlay : Pallets.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ExportBottomSheet(onExport: onExport),
    );
  }

  @override
  State<ExportBottomSheet> createState() => _ExportBottomSheetState();
}

class _ExportBottomSheetState extends State<ExportBottomSheet> {
  ExportFormat _format = ExportFormat.csv;
  DateTime _start = DateTime.now().subtract(const Duration(days: 30));
  DateTime _end = DateTime.now();
  bool _loading = false;

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _start, end: _end),
    );
    if (range == null) return;
    setState(() {
      _start = range.start;
      _end = range.end;
    });
  }

  Future<void> _export() async {
    setState(() => _loading = true);
    try {
      await widget.onExport(
        ExportRequest(format: _format, startDate: _start, endDate: _end),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Pallets.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryText = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final secondaryText = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final borderColor = isDark ? Pallets.borderDark : Pallets.borderLight;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark ? Pallets.borderDark : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text(
            'Export Attendance',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose format and date range',
            style: TextStyle(fontSize: 13, color: secondaryText),
          ),
          const SizedBox(height: 24),

          // ── Format picker ────────────────────────────────────────────────
          Text(
            'FORMAT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: Pallets.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _FormatCard(
                  label: 'CSV',
                  icon: Icons.table_chart_outlined,
                  color: Pallets.success,
                  selected: _format == ExportFormat.csv,
                  onTap: () => setState(() => _format = ExportFormat.csv),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FormatCard(
                  label: 'PDF',
                  icon: Icons.picture_as_pdf_outlined,
                  color: Pallets.error,
                  selected: _format == ExportFormat.pdf,
                  onTap: () => setState(() => _format = ExportFormat.pdf),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Date range ───────────────────────────────────────────────────
          Text(
            'DATE RANGE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: Pallets.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickRange,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.date_range,
                    size: 18,
                    color: Pallets.blurple,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${_fmt(_start)}  →  ${_fmt(_end)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: primaryText,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right, color: secondaryText),
                ],
              ),
            ),
          ),

          const SizedBox(height: 28),

          // ── Export button ────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: Pallets.brandGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _export,
              icon: _loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Pallets.onAccent,
                      ),
                    )
                  : const Icon(Icons.download, size: 18),
              label: Text(
                _loading
                    ? 'Exporting…'
                    : 'Export ${_format.name.toUpperCase()}',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallets.transparent,
                shadowColor: Pallets.transparent,
                foregroundColor: Pallets.onAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatCard extends StatelessWidget {
  const _FormatCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final unselectedBg = isDark ? Pallets.surfaceCard : Pallets.backgroundLight;
    final unselectedBorder = isDark ? Pallets.borderDark : Pallets.borderLight;
    final unselectedText = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.15) : unselectedBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : unselectedBorder,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? color : unselectedText, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? color : unselectedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
