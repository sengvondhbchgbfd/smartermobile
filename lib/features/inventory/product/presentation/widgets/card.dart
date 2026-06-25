import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final Widget child;
  final Color cardBg;
  final Color borderColor;
  final bool isDark;
  final EdgeInsetsGeometry padding;

  const DetailCard({
    required this.child,
    required this.cardBg,
    required this.borderColor,
    required this.isDark,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}