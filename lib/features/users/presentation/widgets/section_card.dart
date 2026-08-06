import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final Color cardBg;
  final Color border;
  final Color textPrimary;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    required this.cardBg,
    required this.border,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: cardBg,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Pallets.blurple),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...children
            .expand((w) => [w, Divider(color: border.withOpacity(0.5))])
            .toList()
          ..removeLast(),
      ],
    ),
  );
}
