import 'package:flutter/material.dart';

class SectionLabel extends StatelessWidget {
  final String label;
  final Color subText;
  const SectionLabel({super.key, required this.label, required this.subText});

  @override
  Widget build(BuildContext context) => Text(
    label.toUpperCase(),
    style: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: subText,
      letterSpacing: 0.6,
    ),
  );
}