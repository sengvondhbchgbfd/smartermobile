import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final Widget value;
  final Color subText;

  const InfoRow({
    required this.label,
    required this.value,
    required this.subText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(color: subText),
        ),
        value,
      ],
    );
  }
}