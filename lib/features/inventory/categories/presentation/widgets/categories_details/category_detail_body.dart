import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/categories/domain/entities/category_entity.dart';
import 'package:frontendmobile/features/inventory/categories/presentation/widgets/categories_details/category_hero_image.dart';
import 'package:frontendmobile/features/inventory/categories/presentation/widgets/categories_details/category_info_cart.dart';
import 'package:frontendmobile/features/inventory/categories/presentation/widgets/categories_details/category_meta_card.dart';

class CategoryDetailBody extends StatelessWidget {
  final CategoryEntity category;
  final Color bg;
  final Color cardBg;
  final Color borderColor;
  final Color subText;
  final bool isDark;

  const CategoryDetailBody({
    super.key,
    required this.category,
    required this.bg,
    required this.cardBg,
    required this.borderColor,
    required this.subText,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero image ─────────────────────────────────────────────────────
          HeroImage(category: category, isDark: isDark, subText: subText),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Title row ───────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.categoryName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF3B82F6).withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF3B82F6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Info card ───────────────────────────────────────────────
                InfoCard(
                  cardBg: cardBg,
                  borderColor: borderColor,
                  subText: subText,
                  category: category,
                ),

                const SizedBox(height: 16),

                // ── Metadata card ───────────────────────────────────────────
                MetaCard(
                  cardBg: cardBg,
                  borderColor: borderColor,
                  subText: subText,
                  category: category,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
