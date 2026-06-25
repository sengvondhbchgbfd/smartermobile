import 'package:flutter/material.dart';

class PlaceholderThumb extends StatelessWidget {
  final Color bg;
  final Color sub;
  const PlaceholderThumb({super.key, required this.bg, required this.sub});

  @override
  Widget build(BuildContext context) => Container(
    color: bg,
    child: Icon(Icons.inventory_2_outlined, color: sub, size: 22),
  );
}

class StockBadge extends StatelessWidget {
  final int qty;
  final bool low;
  const StockBadge({super.key, required this.qty, required this.low});

  @override
  Widget build(BuildContext context) {
    final bg = low
        ? Theme.of(context).colorScheme.error.withOpacity(0.12)
        : const Color(0xFF30D158).withOpacity(0.12);
    final fg = low
        ? Theme.of(context).colorScheme.error
        : const Color(0xFF30D158);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Stock: $qty',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

class ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const ActionBtn({
    super.key,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: color, size: 18),
    ),
  );
}
