
import 'package:flutter/material.dart';

class ActionRow extends StatelessWidget {
  final VoidCallback onApprove;
  final VoidCallback onReject;
  const ActionRow({super.key, required this.onApprove, required this.onReject});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionBtn(
          label: 'Reject',
          color: const Color(0xFFEF4444),
          onTap: onReject,
        ),
        const SizedBox(width: 8),
        _ActionBtn(
          label: 'Approve',
          color: const Color(0xFF22C55E),
          filled: true,
          onTap: onApprove,
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.color,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: filled ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: filled ? null : Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: filled ? Colors.white : color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
