import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/inventory/stock_movements/presentation/providers/stock_movement_report_provider.dart';
import 'package:frontendmobile/features/inventory/stock_movements/presentation/providers/stock_movement_report_state.dart';

const List<String> kReportMonths = [
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

String reportRangeLabel(DateTime? start, DateTime? end) {
  String fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  if (start != null && end != null) return '${fmt(start)}  →  ${fmt(end)}';
  if (start != null) return 'From ${fmt(start)}';
  if (end != null) return 'Until ${fmt(end)}';
  return 'Select date range';
}

class ReportPeriodPicker extends StatelessWidget {
  const ReportPeriodPicker({
    super.key,
    required this.state,
    required this.notifier,
    required this.card,
    required this.border,
    required this.sub,
    required this.textPrimary,
  });

  final StockMovementReportState state;
  final StockMovementReportNotifier notifier;

  final Color card;
  final Color border;
  final Color sub;
  final Color textPrimary;

  //////////////////////////////////////////////////////////////////////////
  // Used for 'day' and 'week' periods — pick an exact date range.
  //////////////////////////////////////////////////////////////////////////
  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 1),
      initialDateRange: (state.start != null && state.end != null)
          ? DateTimeRange(start: state.start!, end: state.end!)
          : null,
    );
    if (picked == null) return;
    notifier.setDateRange(
      start: picked.start,
      // backend end_date is exclusive — bump by 1 day so the picked last
      // day is fully included.
      end: picked.end.add(const Duration(days: 1)),
    );
  }

  //////////////////////////////////////////////////////////////////////////
  // Used for 'month' period — pick any past or present month/year.
  //////////////////////////////////////////////////////////////////////////
  Future<void> _pickMonth(BuildContext context, DateTime current) async {
    int y = current.year;
    int m = current.month;
    final result = await showDialog<DateTime>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Select Month'),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: m,
                items: List.generate(12, (i) => i + 1)
                    .map(
                      (v) => DropdownMenuItem(
                        value: v,
                        child: Text(kReportMonths[v - 1]),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setLocal(() => m = v!),
              ),
              const SizedBox(width: 12),
              DropdownButton<int>(
                value: y,
                items: List.generate(11, (i) => DateTime.now().year - 9 + i)
                    .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                    .toList(),
                onChanged: (v) => setLocal(() => y = v!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, DateTime(y, m, 1)),
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
    if (result != null) await notifier.setMonth(result);
  }

  //////////////////////////////////////////////////////////////////////////
  // Used for 'year' period — pick any past or present year.
  //////////////////////////////////////////////////////////////////////////
  Future<void> _pickYear(BuildContext context, int current) async {
    int y = current;
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Select Year'),
          content: DropdownButton<int>(
            value: y,
            items: List.generate(11, (i) => DateTime.now().year - 9 + i)
                .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                .toList(),
            onChanged: (v) => setLocal(() => y = v!),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, y),
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
    if (result != null) await notifier.setYear(result);
  }

  //////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    switch (state.period) {
      case 'month':
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _pickMonth(context, state.start ?? DateTime.now()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: border, width: 0.6),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_view_month_rounded,
                    size: 16,
                    color: Pallets.blurple,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state.start != null
                        ? '${kReportMonths[state.start!.month - 1]} ${state.start!.year}'
                        : 'Select month',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      case 'year':
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () =>
                _pickYear(context, state.start?.year ?? DateTime.now().year),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: border, width: 0.6),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.event_note_rounded,
                    size: 16,
                    color: Pallets.blurple,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state.start != null
                        ? '${state.start!.year}'
                        : 'Select year',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      case 'day':
      case 'week':
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => _pickDateRange(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: border, width: 0.6),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 16,
                          color: state.hasCustomRange ? Pallets.blurple : sub,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            reportRangeLabel(state.start, state.end),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: state.hasCustomRange ? textPrimary : sub,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (state.hasCustomRange) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.close_rounded, size: 18, color: sub),
                  onPressed: () => notifier.clearDateRange(),
                  tooltip: 'Clear range',
                ),
              ],
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
