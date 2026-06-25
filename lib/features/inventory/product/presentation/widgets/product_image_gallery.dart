import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';
import 'package:frontendmobile/features/inventory/product/presentation/widgets/themes/product_color.dart';

class ProductImageGallery extends StatelessWidget {
  final List<ProductImageEntity> images;
  final void Function(int imageId) onSetPrimary;
  final void Function(int imageId) onDelete;
  final VoidCallback onAdd;

  const ProductImageGallery({
    required this.images,
    required this.onSetPrimary,
    required this.onDelete,
    required this.onAdd,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final borderColor = ProductColor.border(context);
    final searchBg = ProductColor.searchBg(context);
    final subText = ProductColor.sub(context);

    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ...images.map(
            (img) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: searchBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: img.isPrimary ? colors.primary : borderColor,
                        width: img.isPrimary ? 2 : 0.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: img.imageUrl != null
                          ? Image.network(
                              img.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.broken_image_outlined,
                                color: subText,
                              ),
                            )
                          : Icon(
                              Icons.image_not_supported_outlined,
                              color: subText,
                            ),
                    ),
                  ),

                  // Primary badge
                  if (img.isPrimary)
                    Positioned(
                      top: 5,
                      left: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'PRIMARY',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: colors.onPrimary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),

                  // Menu button
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTapDown: (details) => _showMenu(
                        context,
                        details.globalPosition,
                        img,
                        colors,
                      ),
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Add button
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: borderColor,
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: colors.primary,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu(
    BuildContext context,
    Offset position,
    ProductImageEntity img,
    ColorScheme colors,
  ) {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: [
        if (!img.isPrimary)
          const PopupMenuItem(
            value: 'primary',
            child: Row(
              children: [
                Icon(Icons.star_outline, size: 18),
                SizedBox(width: 10),
                Text('Set as primary'),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 18, color: colors.error),
              const SizedBox(width: 10),
              Text('Delete', style: TextStyle(color: colors.error)),
            ],
          ),
        ),
      ],
    ).then((v) {
      if (v == 'primary') onSetPrimary(img.imageId);
      if (v == 'delete') onDelete(img.imageId);
    });
  }
}
