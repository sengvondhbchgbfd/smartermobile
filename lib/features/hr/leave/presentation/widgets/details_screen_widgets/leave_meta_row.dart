import 'package:flutter/material.dart';

class MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color textPrimary, textSecondary, border;
  final Color? valueColor;
  final bool isFirst;
  final bool isLast;

  const MetaRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    this.valueColor,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Icon(icon, color: textSecondary, size: 17),
              const SizedBox(width: 10),
              Text(label, style: TextStyle(color: textSecondary, fontSize: 13)),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? textPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 1, color: border, indent: 16, endIndent: 16),
      ],
    );
  }
}
