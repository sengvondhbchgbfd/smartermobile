import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onDelete;
  const ActionButtons({
    super.key,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(
          Icons.delete_outline_rounded,
          size: 18,
          color: Pallets.error,
        ),
        label: const Text(
          'Delete',
          style: TextStyle(color: Pallets.error),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 13),
          side: const BorderSide(color: Pallets.error, width: 0.7),
        ),
        onPressed: onDelete,
      ),
    );
  }
}