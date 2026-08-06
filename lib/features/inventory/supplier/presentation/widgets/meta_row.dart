


import 'package:flutter/material.dart';

class MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const MetaRow({super.key, 
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.5, color: color),
          ),
        ),
      ],
    );
  }
}
