
import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/categories/domain/entities/category_entity.dart';
import 'package:frontendmobile/features/inventory/categories/presentation/widgets/categories_details/category_row.dart';

class MetaCard extends StatelessWidget {
  final Color cardBg;
  final Color borderColor;
  final Color subText;
  final CategoryEntity category;

  const MetaCard({super.key, 
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'Metadata',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: subText,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Divider(height: 0.5, thickness: 0.5, color: borderColor),
          DetailRow(
            label: 'Has Image',
            value: category.imageUrl != null ? 'Yes' : 'No',
            subText: subText,
            borderColor: borderColor,
          ),
        ],
      ),
    );
  }
}
