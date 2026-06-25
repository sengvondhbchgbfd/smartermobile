import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/customer/domain/entities/customer_entity.dart';
import 'package:frontendmobile/core/widgets/button/action_button.dart';
import 'package:frontendmobile/features/inventory/customer/presentation/widgets/customer_avatar.dart';

class CustomerTile extends StatelessWidget {
  final CustomerEntity customer;
  final Color cardBg;
  final Color borderColor;
  final VoidCallback? onTap; // ✅ nullable
  final VoidCallback? onEdit; // ✅ nullable
  final VoidCallback? onDelete; // ✅ nullable
  final bool isWorking; // ✅ renamed from isLoading

  const CustomerTile({
    required this.customer,
    required this.cardBg,
    required this.borderColor,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.isWorking = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1C1C1E);
    final textSecondary = isDark
        ? const Color(0xFF8E8E93)
        : const Color(0xFF6B6B6B);

    final sub = [
      if (customer.phone != null) customer.phone!,
      if (customer.email != null) customer.email!,
    ].join(' · ');

    return InkWell(
      onTap: onTap, // ✅ null disables tap naturally
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              AppAvatar(name: customer.name, avatarUrl: customer.avatarUrl),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        // ✅ theme-aware
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (sub.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        sub,
                        style: theme.textTheme.bodySmall?.copyWith(
                          // ✅ theme-aware
                          color: textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // ✅ Spinner during operation, buttons otherwise
              if (isWorking)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: const Color(0xFF3B82F6),
                  ),
                )
              else
                Row(
                  children: [
                    ActionBtn(
                      icon: Icons.edit_outlined,
                      color: const Color(0xFF3B82F6),
                      borderColor: borderColor,
                      onTap: onEdit,
                    ),
                    const SizedBox(width: 6),
                    ActionBtn(
                      icon: Icons.delete_outline_rounded,
                      color: const Color(0xFFE24B4A),
                      borderColor: borderColor,
                      onTap: onDelete,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
