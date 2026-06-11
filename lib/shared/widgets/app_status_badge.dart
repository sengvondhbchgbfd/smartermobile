import 'package:flutter/material.dart';

enum AppStatusType { success, warning, error, info }

class AppStatusBadge extends StatelessWidget {
  final String label;
  final AppStatusType type;

  const AppStatusBadge({super.key, required this.label, required this.type});

  Color _getColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    switch (type) {
      case AppStatusType.success:
        return scheme.primary;
      case AppStatusType.warning:
        return scheme.tertiary;
      case AppStatusType.error:
        return scheme.error;
      case AppStatusType.info:
        return scheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(context);
    final bg = color.withOpacity(0.12);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
