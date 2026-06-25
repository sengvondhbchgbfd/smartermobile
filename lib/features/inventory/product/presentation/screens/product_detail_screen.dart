import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/inventory/product/presentation/screens/product_form_screen.dart';
import 'package:frontendmobile/features/inventory/product/presentation/widgets/detail_widgets/circle_icon_button.dart';
import 'package:frontendmobile/features/inventory/product_variant/presentation/screens/variant_list_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:frontendmobile/core/widgets/alertmessage/app_snacker.dart';
import '../providers/product_provider.dart';
import '../../../categories/presentation/providers/category_provider.dart';
import '../../domain/entities/product_entity.dart';

class ProductDetailScreen extends ConsumerWidget {
  final int productId;
  const ProductDetailScreen({required this.productId, super.key});

  // ── Helpers ──────────────────────────────────────────────────────────────

  Future<void> _openEdit(
    BuildContext context,
    WidgetRef ref,
    ProductEntity product,
  ) async {
    final categories = ref.read(categoryNotifierProvider).categories;
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) =>
            ProductFormScreen(existing: product, categories: categories),
      ),
    );
    if (result == null || !context.mounted) return;
    final ok = await ref
        .read(productNotifierProvider.notifier)
        .updateProduct(
          productId: productId,
          name: result['name'],
          categoryId: result['category_id'],
          description: result['description'],
        );
    if (!context.mounted) return;
    AppSnackBar.show(
      context,
      message: ok
          ? 'Product updated successfully.'
          : 'Failed to update product.',
      type: ok ? SnackType.success : SnackType.error,
    );
  }

  Future<void> _addImage(BuildContext context, WidgetRef ref) async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    final ok = await ref
        .read(productNotifierProvider.notifier)
        .addImage(productId: productId, image: File(picked.path));
    if (!context.mounted) return;
    AppSnackBar.show(
      context,
      message: ok ? 'Image added.' : 'Failed to add image.',
      type: ok ? SnackType.success : SnackType.error,
    );
  }

  Future<void> _setPrimary(
    BuildContext context,
    WidgetRef ref,
    int imageId,
  ) async {
    final ok = await ref
        .read(productNotifierProvider.notifier)
        .setPrimaryImage(productId: productId, imageId: imageId);
    if (!context.mounted) return;
    if (!ok) {
      AppSnackBar.show(
        context,
        message: 'Failed to set primary image.',
        type: SnackType.error,
      );
    }
  }

  Future<void> _deleteImage(
    BuildContext context,
    WidgetRef ref,
    int imageId,
  ) async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete image'),
        content: const Text('Remove this image from the product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final ok = await ref
        .read(productNotifierProvider.notifier)
        .deleteImage(productId: productId, imageId: imageId);
    if (!context.mounted) return;
    if (!ok) {
      AppSnackBar.show(
        context,
        message: 'Failed to delete image.',
        type: SnackType.error,
      );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productNotifierProvider);
    final product = state.products
        .where((p) => p.productId == productId)
        .firstOrNull;

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF111111) : const Color(0xFFF5F4F2);
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFE8E6E1);
    final subText = isDark ? const Color(0xFF888888) : const Color(0xFF888888);

    if (product == null) {
      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          title: const Text('Product'),
          backgroundColor: bg,
          elevation: 0,
        ),
        body: Center(
          child: state.isLoading
              ? const CircularProgressIndicator()
              : Text('Product not found.', style: TextStyle(color: subText)),
        ),
      );
    }

    final isWorking = state.loadingIds.contains(product.productId);
    final hasDescription = product.description?.isNotEmpty ?? false;

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ── Hero ──────────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: 300,
            backgroundColor: cardBg,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleIconButton(
                icon: Icons.arrow_back,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              if (isWorking)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CircleIconButton(
                    icon: Icons.edit_outlined,
                    onTap: () => _openEdit(context, ref, product),
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: _HeroGallery(
                images: product.images,
                isDark: isDark,
                cardBg: cardBg,
                onSetPrimary: (id) => _setPrimary(context, ref, id),
                onDelete: (id) => _deleteImage(context, ref, id),
                onAdd: () => _addImage(context, ref),
              ),
            ),
          ),

          // ── Content sheet ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -22),
              child: Container(
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // drag handle
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: borderColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),

                    // product name
                    Text(
                      product.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),

                    // ── Variants section ──────────────────────────────────
                    _SectionLabel(
                      icon: Icons.tune_outlined,
                      label: 'Variants',
                      subText: subText,
                    ),

                    // manage button
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VariantListScreen(
                            productId: product.productId,
                            productName: product.name,
                          ),
                        ),
                      ),


                      icon: const Icon(Icons.tune_outlined, size: 15),
                      label: const Text('Manage variants'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: borderColor),
                        foregroundColor: colors.primary,
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    

                    // variant cards
                    if (product.variants.isNotEmpty)
                      ...product.variants.map(
                        (v) => _VariantCard(
                          variant: v,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          subText: subText,
                          isDark: isDark,
                          theme: theme,
                          colors: colors,
                        ),
                      )
                    else
                      _EmptyVariants(
                        cardBg: cardBg,
                        borderColor: borderColor,
                        subText: subText,
                      ),

                    // ── Description section ───────────────────────────────
                    if (hasDescription) ...[
                      _SectionLabel(
                        icon: Icons.notes_outlined,
                        label: 'Description',
                        subText: subText,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: borderColor, width: 0.5),
                        ),
                        child: Text(
                          product.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: subText,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero gallery ─────────────────────────────────────────────────────────────

class _HeroGallery extends StatefulWidget {
  final List images;
  final bool isDark;
  final Color cardBg;
  final void Function(int) onSetPrimary;
  final void Function(int) onDelete;
  final VoidCallback onAdd;

  const _HeroGallery({
    required this.images,
    required this.isDark,
    required this.cardBg,
    required this.onSetPrimary,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  State<_HeroGallery> createState() => _HeroGalleryState();
}

class _HeroGalleryState extends State<_HeroGallery> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFE8E6E1);

    return Stack(
      fit: StackFit.expand,
      children: [
        // main image / placeholder
        widget.images.isEmpty
            ? Container(
                color: widget.cardBg,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: widget.isDark
                          ? const Color(0xFF444444)
                          : const Color(0xFFCCCCCC),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No images yet',
                      style: TextStyle(
                        fontSize: 13,
                        color: widget.isDark
                            ? const Color(0xFF555555)
                            : const Color(0xFFBBBBBB),
                      ),
                    ),
                  ],
                ),
              )
            : PageView.builder(
                itemCount: widget.images.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (_, i) {
                  final img = widget.images[i];
                  return img.imageUrl != null
                      ? Image.network(img.imageUrl!, fit: BoxFit.cover)
                      : Container(color: widget.cardBg);
                },
              ),

        // dot indicators
        if (widget.images.length > 1)
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (i) {
                final active = i == _current;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active
                        ? Colors.white
                        : Colors.white.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),

        // thumbnail strip
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 62,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.35)],
              ),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              children: [
                ...widget.images.map(
                  (img) => GestureDetector(
                    onLongPress: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.star_outline),
                                title: const Text('Set as primary'),
                                onTap: () {
                                  Navigator.pop(context);
                                  widget.onSetPrimary(img.imageId);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete_outline),
                                title: const Text('Delete'),
                                onTap: () {
                                  Navigator.pop(context);
                                  widget.onDelete(img.imageId);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: img.isPrimary
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          width: img.isPrimary ? 2 : 1,
                        ),
                        image: img.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(img.imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                  ),
                ),
                // add button
                GestureDetector(
                  onTap: widget.onAdd,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color subText;

  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 15, color: subText),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: subText,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Variant card ──────────────────────────────────────────────────────────────

class _VariantCard extends StatelessWidget {
  final dynamic variant;
  final Color cardBg;
  final Color borderColor;
  final Color subText;
  final bool isDark;
  final ThemeData theme;
  final ColorScheme colors;

  const _VariantCard({
    required this.variant,
    required this.cardBg,
    required this.borderColor,
    required this.subText,
    required this.isDark,
    required this.theme,
    required this.colors,
  });

  // Chip colors — cycle through purple / teal / coral
  static const _chipPalettes = [
    (bg: Color(0xFFEEEDFE), text: Color(0xFF3C3489)), // purple
    (bg: Color(0xFFE1F5EE), text: Color(0xFF0F6E56)), // teal
    (bg: Color(0xFFFAECE7), text: Color(0xFF993C1D)), // coral
    (bg: Color(0xFFFBEAF0), text: Color(0xFF993556)), // pink
  ];

  static const _chipPalettesDark = [
    (bg: Color(0xFF26215C), text: Color(0xFFCECBF6)),
    (bg: Color(0xFF04342C), text: Color(0xFF9FE1CB)),
    (bg: Color(0xFF4A1B0C), text: Color(0xFFF5C4B3)),
    (bg: Color(0xFF4B1528), text: Color(0xFFF4C0D1)),
  ];

  @override
  Widget build(BuildContext context) {
    final isLowStock = variant.stockQuantity <= 5;
    final palettes = isDark ? _chipPalettesDark : _chipPalettes;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SKU
          if (variant.sku != null) ...[
            Row(
              children: [
                Icon(Icons.qr_code_outlined, size: 13, color: subText),
                const SizedBox(width: 5),
                Text(
                  'SKU: ${variant.sku}',
                  style: TextStyle(fontSize: 12, color: subText),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],

          // spec chips
          if (variant.specs.isNotEmpty) ...[
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: variant.specs.entries
                  .toList()
                  .asMap()
                  .entries
                  .map<Widget>((entry) {
                    final idx = entry.key % palettes.length;
                    final palette = palettes[idx];
                    final spec = entry.value;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: palette.bg,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        '${spec.key}: ${spec.value}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: palette.text,
                        ),
                      ),
                    );
                  })
                  .toList(),
            ),
            const SizedBox(height: 10),
          ],

          // price + stock
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(fontSize: 11, color: subText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${variant.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? const Color(0xFFAFA9EC)
                            : const Color(0xFF534AB7),
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isLowStock
                      ? (isDark
                            ? const Color(0xFF501313)
                            : const Color(0xFFFCEBEB))
                      : (isDark
                            ? const Color(0xFF04342C)
                            : const Color(0xFFE1F5EE)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Stock: ${variant.stockQuantity}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isLowStock
                        ? (isDark
                              ? const Color(0xFFF7C1C1)
                              : const Color(0xFFA32D2D))
                        : (isDark
                              ? const Color(0xFF9FE1CB)
                              : const Color(0xFF0F6E56)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyVariants extends StatelessWidget {
  final Color cardBg;
  final Color borderColor;
  final Color subText;

  const _EmptyVariants({
    required this.cardBg,
    required this.borderColor,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Column(
        children: [
          Icon(Icons.add_box_outlined, color: subText, size: 28),
          const SizedBox(height: 8),
          Text(
            'No variants yet',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: subText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add a variant to set price and stock.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: subText),
          ),
        ],
      ),
    );
  }
}
