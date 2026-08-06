import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/categories/domain/entities/category_entity.dart';
import 'package:frontendmobile/features/inventory/categories/presentation/widgets/categories_details/category_row.dart';

class InfoCard extends StatelessWidget {
  final Color cardBg;
  final Color borderColor;
  final Color subText;
  final CategoryEntity category;

  const InfoCard({
    super.key,
    required this.cardBg,
    required this.borderColor,
    required this.subText,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Column(
        children: [
          DetailRow(
            label: 'Name',
            value: category.categoryName,
            subText: subText,
            borderColor: borderColor,
          ),
        ],
      ),
    );
  }
}
