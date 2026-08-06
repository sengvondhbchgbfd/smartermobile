import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/inventory/supplier/presentation/widgets/meta_row.dart';

class SupplierCard extends StatelessWidget {
  final String name;
  final String? phone;
  final String? email;
  final bool isWorking;
  final Color surface;
  final Color surfaceElevated;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SupplierCard({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.isWorking,
    required this.surface,
    required this.surfaceElevated,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isWorking ? 0.55 : 1,
      child: Material(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: isWorking ? null : onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: border),
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    gradient: Pallets.brandGradient,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (phone != null && phone!.isNotEmpty)
                        MetaRow(
                          icon: Icons.call_outlined,
                          label: phone!,
                          color: textSecondary,
                        ),
                      if (email != null && email!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: MetaRow(
                            icon: Icons.mail_outline_rounded,
                            label: email!,
                            color: textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                // Actions
                if (isWorking)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Pallets.blurple,
                    ),
                  )
                else
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: textSecondary,
                      size: 20,
                    ),
                    color: surfaceElevated,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onSelected: (v) {
                      if (v == 'edit') onEdit();
                      if (v == 'delete') onDelete();
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: textPrimary,
                            ),
                            const SizedBox(width: 10),
                            Text('Edit', style: TextStyle(color: textPrimary)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                              color: Pallets.error,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Delete',
                              style: TextStyle(color: Pallets.error),
                            ),
                          ],
                        ),
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
