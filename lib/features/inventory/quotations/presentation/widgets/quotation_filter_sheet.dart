import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontendmobile/core/themes/app_pallets.dart';

import '../../domain/entities/quotation_enums.dart';
import '../providers/quotation_filter_provider.dart';

Future<void> showQuotationFilterSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => const _QuotationFilterSheet(),
  );
}

class _QuotationFilterSheet extends ConsumerWidget {
  const _QuotationFilterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filter = ref.watch(quotationFilterNotifierProvider);
    final notifier = ref.read(quotationFilterNotifierProvider.notifier);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: isDark ? Pallets.surfaceOverlay : Pallets.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Pallets.textMuted.withOpacity(0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Quotations',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color:
                      isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight,
                ),
              ),
              TextButton(
                onPressed: () {
                  notifier.reset();
                  Navigator.pop(context);
                },
                child: const Text('Clear all'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusChip(
                label: 'All',
                selected: filter.status == null,
                color: Pallets.textMuted,
                onTap: () => notifier.setStatus(null),
              ),
              for (final s in QuotationStatus.values)
                _StatusChip(
                  label: s.label,
                  selected: filter.status == s,
                  color: s.color,
                  onTap: () => notifier.setStatus(s),
                ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallets.blurple,
                foregroundColor: Pallets.onAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.15) : Colors.transparent,
          border: Border.all(
            color: selected ? color : Pallets.borderDark,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? color : Pallets.textMuted,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
