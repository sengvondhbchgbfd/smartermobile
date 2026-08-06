import 'package:flutter/material.dart';

class LeaveSummaryCardImport extends StatelessWidget {
  final Map<String, dynamic> summary;
  const LeaveSummaryCardImport({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? const Color(0xFF141418) : Colors.white;
    final border = isDark ? const Color(0xFF232329) : const Color(0xFFE8E8EF);
    final textSecondary = isDark
        ? const Color(0xFF8B8B9A)
        : const Color(0xFF6B6B7A);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          _Stat(
            'Approved',
            summary['approved']?.toString() ?? '0',
            const Color(0xFF22C55E),
            Icons.check_circle_rounded,
            textSecondary,
            border,
          ),
          _Stat(
            'Pending',
            summary['pending']?.toString() ?? '0',
            const Color(0xFFF59E0B),
            Icons.hourglass_top_rounded,
            textSecondary,
            border,
          ),
          _Stat(
            'Rejected',
            summary['rejected']?.toString() ?? '0',
            const Color(0xFFEF4444),
            Icons.cancel_rounded,
            textSecondary,
            border,
          ),
          _Stat(
            'Cancelled',
            summary['cancelled']?.toString() ?? '0',
            const Color(0xFF94A3B8),
            Icons.block_rounded,
            textSecondary,
            border,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  final Color color, textSecondary, border;
  final IconData icon;
  final bool isLast;

  const _Stat(
    this.label,
    this.value,
    this.color,
    this.icon,
    this.textSecondary,
    this.border, {
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 17),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: textSecondary),
                ),
              ],
            ),
          ),
          if (!isLast) Container(width: 1, height: 44, color: border),
        ],
      ),
    );
  }
}
