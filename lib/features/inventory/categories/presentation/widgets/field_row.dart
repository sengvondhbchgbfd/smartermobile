import 'package:flutter/material.dart';

class FieldRow extends StatelessWidget {
  final String label;
  final Widget child;
  final bool showDivider;

  const FieldRow({
    super.key,
    required this.label,
    required this.child,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE0DED8);
    final labelColor = isDark
        ? const Color(0xFF8E8E93)
        : const Color(0xFF6B6B6B);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: labelColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 0.5, thickness: 0.5, color: borderColor),
      ],
    );
  }
}
