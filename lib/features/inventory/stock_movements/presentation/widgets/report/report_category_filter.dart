import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/inventory/categories/domain/entities/category_entity.dart';
import 'package:frontendmobile/features/inventory/product/presentation/widgets/category_chip.dart'
    show CategoryChip;

class ReportCategoryFilter extends StatelessWidget {
  const ReportCategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelect,
    required this.border,
    required this.sub,
  });

  final List<CategoryEntity> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onSelect;
  final Color border;
  final Color sub;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          CategoryChip(
            label: 'All Categories',
            selected: selectedCategoryId == null,
            onTap: () => onSelect(null),
            selectedColor: Pallets.blurple,
            border: border,
            sub: sub,
          ),
          ...categories.map(
            (c) => Padding(
              padding: const EdgeInsets.only(left: 8),
              child: CategoryChip(
                label: c.categoryName,
                selected: selectedCategoryId == c.categoryId,
                onTap: () => onSelect(
                  selectedCategoryId == c.categoryId ? null : c.categoryId,
                ),
                selectedColor: Pallets.blurple,
                border: border,
                sub: sub,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
