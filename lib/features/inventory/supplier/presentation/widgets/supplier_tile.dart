import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/inventory/customer/presentation/widgets/customer_avatar.dart';
import 'package:frontendmobile/features/inventory/supplier/domain/entities/supplier.dart';

import '../../../../../core/widgets/button/action_button.dart';

class SupplierTile extends StatelessWidget {
  final SupplierEntity supplier;
  final VoidCallback onTap;
  final bool isWorking;
  final Color borderColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SupplierTile({
    required this.supplier,
    this.isWorking = false,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    super.key,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surface = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isWorking ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                AppAvatar(name: supplier.name, avatarUrl: supplier.avatarUrl),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplier.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (supplier.phone != null || supplier.email != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          [
                            supplier.phone,
                            supplier.email,
                          ].where((v) => v != null && v.isNotEmpty).join(' · '),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                if (isWorking)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Row(
                    children: [
                      ActionBtn(
                        icon: Icons.edit_outlined,
                        color: Pallets.blurple,
                        borderColor: borderColor,
                        onTap: onEdit,
                      ),
                      const SizedBox(width: 6),
                      ActionBtn(
                        icon: Icons.delete_outline_rounded,
                        color: Pallets.error,
                        borderColor: borderColor,
                        onTap: onDelete,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
