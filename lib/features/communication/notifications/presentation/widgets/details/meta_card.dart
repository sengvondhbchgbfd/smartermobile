import 'package:flutter/material.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/details/meta_row.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/palette.dart';

class MetaCard extends StatelessWidget {
  const MetaCard({super.key, required this.rows});

  final List<MetaRow> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = Palette.of(isDark);

    return Container(
      decoration: BoxDecoration(
        color: p.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: p.border, width: 0.5),
      ),
      child: Column(
        children: List.generate(rows.length, (index) {
          final isLast = index == rows.length - 1;

          return Column(
            children: [
              rows[index],
              if (!isLast) Divider(height: 1, thickness: 0.5, color: p.border),
            ],
          );
        }),
      ),
    );
  }
}
