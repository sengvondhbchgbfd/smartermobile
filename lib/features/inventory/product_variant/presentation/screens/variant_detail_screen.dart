import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/widgets/alertmessage/app_snacker.dart';
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';
import 'package:frontendmobile/features/inventory/product/presentation/widgets/card.dart';
import 'package:frontendmobile/features/inventory/product/presentation/widgets/detail_widgets/circle_icon_button.dart';
import 'package:frontendmobile/features/inventory/product/presentation/widgets/detail_widgets/flexible_image_gallery.dart';
import 'package:frontendmobile/features/inventory/product/presentation/widgets/section_header.dart'
    show SectionHeader;
import 'package:frontendmobile/features/inventory/stock_movements/presentation/screens/stock_movements_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/product_variant_provider.dart';
import 'variant_form_screen.dart';

class VariantDetailScreen extends ConsumerWidget {
  final int productId;
  final int variantId;

  const VariantDetailScreen({
    required this.productId,
    required this.variantId,
    super.key,
  });

  Future<void> _openEdit(
    BuildContext context,
    WidgetRef ref,
    ProductVariantEntity variant,
  ) async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) =>
            VariantFormScreen(productId: productId, existing: variant),
      ),
    );
    if (result == null || !context.mounted) return;
    final ok = await ref
        .read(productVariantNotifierProvider.notifier)
        .update(
          productId: productId,
          variantId: variantId,
          sku: result['sku'],
          specs: result['specs'],
          price: result['price'],
          stockQuantity: result['stock_quantity'],
        );
    if (!context.mounted) return;
    AppSnackBar.show(
      context,
      message: ok ? 'Variant updated.' : 'Failed to update variant.',
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
        .read(productVariantNotifierProvider.notifier)
        .addImage(
          productId: productId,
          variantId: variantId,
          image: File(picked.path),
        );
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
        .read(productVariantNotifierProvider.notifier)
        .setPrimaryImage(
          productId: productId,
          variantId: variantId,
          imageId: imageId,
        );
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
        content: const Text('Remove this image from the variant?'),
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
        .read(productVariantNotifierProvider.notifier)
        .deleteImage(
          productId: productId,
          variantId: variantId,
          imageId: imageId,
        );
    if (!context.mounted) return;
    if (!ok) {
      AppSnackBar.show(
        context,
        message: 'Failed to delete image.',
        type: SnackType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productVariantNotifierProvider);
    final variant = state.variants
        .where((v) => v.variantId == variantId)
        .firstOrNull;

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5F5F4);
    final cardBg = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE0DED8);
    final subText = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6B6B6B);

    if (variant == null) {
      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(title: const Text('Variant'), backgroundColor: bg),
        body: Center(
          child: state.isLoading
              ? const CircularProgressIndicator()
              : Text('Variant not found.', style: TextStyle(color: subText)),
        ),
      );
    }

    final isWorking = state.loadingIds.contains(variant.variantId);
    final lowStock = variant.stockQuantity <= 5;

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: 300,
            backgroundColor: cardBg,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              variant.sku ?? 'Variant #$variantId',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            leading: CircleIconButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.of(context).pop(),
            ),
            actions: [
              if (isWorking)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CircleIconButton(
                    icon: Icons.edit_outlined,
                    onTap: () => _openEdit(context, ref, variant),
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: FlexibleImageGallery(
                images: variant.images,
                cardBg: cardBg,
                onSetPrimary: (id) => _setPrimary(context, ref, id),
                onDelete: (id) => _deleteImage(context, ref, id),
                onAdd: () => _addImage(context, ref),
              ),
            ),
          ),

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
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // drag handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: borderColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),

                    // ── Price & Stock ──────────────────────────────────────
                    SectionHeader(
                      icon: Icons.payments_outlined,
                      text: 'Pricing & stock',
                      subText: subText,
                    ),
                    DetailCard(
                      cardBg: cardBg,
                      borderColor: borderColor,
                      isDark: isDark,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Price',
                                style: TextStyle(color: subText, fontSize: 14),
                              ),
                              Text(
                                '\$${variant.price.toStringAsFixed(2)}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.primary,
                                ),
                              ),
                            ],
                          ),
                          Divider(height: 24, color: borderColor),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Stock quantity',
                                style: TextStyle(color: subText, fontSize: 14),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: lowStock
                                      ? colors.errorContainer
                                      : colors.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${variant.stockQuantity}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: lowStock
                                        ? colors.onErrorContainer
                                        : colors.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── SKU ───────────────────────────────────────────────
                    if (variant.sku != null) ...[
                      SectionHeader(
                        icon: Icons.qr_code_outlined,
                        text: 'SKU',
                        subText: subText,
                      ),
                      DetailCard(
                        cardBg: cardBg,
                        borderColor: borderColor,
                        isDark: isDark,
                        child: Row(
                          children: [
                            Icon(
                              Icons.qr_code_outlined,
                              size: 16,
                              color: subText,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              variant.sku!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // ── Specs ─────────────────────────────────────────────
                    if (variant.specs.isNotEmpty) ...[
                      SectionHeader(
                        icon: Icons.tune_outlined,
                        text: 'Specifications',
                        subText: subText,
                      ),
                      DetailCard(
                        cardBg: cardBg,
                        borderColor: borderColor,
                        isDark: isDark,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: variant.specs.entries
                              .map(
                                (e) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.primaryContainer,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${e.key}: ${e.value}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: colors.onPrimaryContainer,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],

                    // ── Stock Movements ───────────────────────────────────────────
                    SectionHeader(
                      icon: Icons.swap_vert_outlined,
                      text: 'Stock movements',
                      subText: subText,
                    ),
                    DetailCard(
                      cardBg: cardBg,
                      borderColor: borderColor,
                      isDark: isDark,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.history_outlined, color: subText),
                        title: const Text('View movement history'),
                        subtitle: Text(
                          'Track stock in/out for this variant',
                          style: TextStyle(color: subText, fontSize: 12),
                        ),
                        trailing: Icon(
                          Icons.chevron_right_rounded,
                          color: subText,
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                StockMovementsScreen(variantId: variantId),
                                
                          ),
                        ),
                      ),
                    ),
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
