import 'package:flutter/material.dart';

class AppActionButtons extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onPrimary;
  final IconData? primaryIcon;
  final String? primaryTooltip;
  final VoidCallback? onAdjustments;

  const AppActionButtons({
    super.key,
    this.onEdit,
    this.onDelete,
    this.onPrimary,
    this.primaryIcon,
    this.primaryTooltip,
    this.onAdjustments,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onPrimary != null)
          IconButton(
            tooltip: primaryTooltip ?? "Action",
            onPressed: onPrimary,
            icon: Icon(primaryIcon ?? Icons.check, color: colors.primary),
          ),

        if (onEdit != null)
          IconButton(
            tooltip: 'Edit',
            onPressed: onEdit,
            icon: Icon(Icons.edit_outlined, color: colors.secondary),
          ),

        if (onDelete != null)
          IconButton(
            tooltip: 'Delete',
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline, color: colors.error),
          ),

        if (onAdjustments != null)
          IconButton(
            tooltip: "Adjust",
            onPressed: onAdjustments,
            icon: const Icon(Icons.tune_outlined, size: 16),
          ),
      ],
    );
  }
}
