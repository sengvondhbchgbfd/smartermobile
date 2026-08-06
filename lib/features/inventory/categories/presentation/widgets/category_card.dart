import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import '../../domain/entities/category_entity.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final Color cardBg;
  final Color borderColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap;
  final VoidCallback? onOptions;
  final bool isLoading;

  const CategoryCard({
    required this.category,
    required this.cardBg,
    required this.borderColor,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
    this.onOptions,
    this.isLoading = false, // ← default false
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subText = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;

    // ── Loading overlay state ──────────────────────────────────────────────
    if (isLoading) {
      return Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Shimmer.fromColors(
          baseColor: isDark ? Pallets.borderDark : Colors.grey.shade300,
          highlightColor: isDark
              ? Pallets.surfaceElevated
              : Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: Container(color: Colors.white)),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: borderColor, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 13,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ── Normal card ────────────────────────────────────────────────────────
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Image ───────────────────────────────────────────────────────
            Expanded(
              child: category.imageUrl != null
                  ? Image.network(
                      category.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _placeholder(isDark, subText),
                    )
                  : _placeholder(isDark, subText),
            ),

            // ── Footer ──────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: borderColor, width: 0.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      category.categoryName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: onOptions,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(Icons.more_vert, size: 18, color: subText),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(bool isDark, Color subText) => Container(
    color: isDark ? Pallets.surfaceCard : Pallets.surfaceLight,
    child: Icon(Icons.category_outlined, size: 36, color: subText),
  );
}
