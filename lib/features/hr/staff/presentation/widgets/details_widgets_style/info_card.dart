import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final Color surface;
  final Color border;
  final Color muted;
  final String title;
  final List<Widget> rows;
  const InfoCard({
    super.key,
    required this.surface,
    required this.border,
    required this.muted,
    required this.title,
    required this.rows,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: muted,
            ),
          ),
          const SizedBox(height: 10),
          ...rows,
        ],
      ),
    );
  }
}
