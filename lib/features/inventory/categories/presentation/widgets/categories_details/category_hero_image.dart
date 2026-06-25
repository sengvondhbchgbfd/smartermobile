import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/categories/domain/entities/category_entity.dart';

class HeroImage extends StatelessWidget {
  final CategoryEntity category;
  final bool isDark;
  final Color subText;

  const HeroImage({
    super.key,
    required this.category,
    required this.isDark,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    if (category.imageUrl != null) {
      return SizedBox(
        width: double.infinity,
        height: 220,
        child: Image.network(
          category.imageUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) => progress == null
              ? child
              : Container(
                  height: 220,
                  color: isDark
                      ? const Color(0xFF2C2C2E)
                      : const Color(0xFFEFEFED),
                  child: const Center(child: CircularProgressIndicator()),
                ),
          errorBuilder: (_, __, ___) => _placeholder(isDark, subText),
        ),
      );
    }
    return _placeholder(isDark, subText);
  }

  Widget _placeholder(bool isDark, Color subText) => Container(
    width: double.infinity,
    height: 220,
    color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFEFEFED),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.category_outlined, size: 48, color: subText),
        const SizedBox(height: 8),
        Text('No image', style: TextStyle(fontSize: 13, color: subText)),
      ],
    ),
  );
}
