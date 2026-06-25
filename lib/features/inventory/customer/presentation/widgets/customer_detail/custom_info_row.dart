import 'package:flutter/material.dart';

class InfoRow {
  final IconData icon;
  final String label, value;
  const InfoRow({required this.icon, required this.label, required this.value});
}

class InfoCard extends StatelessWidget {
  final Color cardBg, borderColor;
  final List<InfoRow> rows;
  const InfoCard({
    super.key,
    required this.cardBg,
    required this.borderColor,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final row = e.value;
          final isLast = e.key == rows.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                child: Row(
                  children: [
                    Icon(row.icon, size: 17, color: const Color(0xFF6B6B6B)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row.label,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B6B6B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(row.value, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(height: 0.5, thickness: 0.5, color: borderColor),
            ],
          );
        }).toList(),
      ),
    ),
  );
}
