import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
}
