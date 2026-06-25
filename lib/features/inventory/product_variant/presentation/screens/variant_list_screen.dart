import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/utils/confirm_delete_dialog.dart';
import 'package:frontendmobile/core/widgets/alertmessage/app_snacker.dart';
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';
import 'package:frontendmobile/features/inventory/product_variant/presentation/screens/variant_detail_screen.dart';

import '../providers/product_variant_provider.dart';
import 'variant_form_screen.dart';

class VariantListScreen extends ConsumerStatefulWidget {
  final int productId;
  final String productName;

  const VariantListScreen({
    required this.productId,
    required this.productName,
    super.key,
  });

  @override
  ConsumerState<VariantListScreen> createState() => _VariantListScreenState();
}

class _VariantListScreenState extends ConsumerState<VariantListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(productVariantNotifierProvider.notifier)
          .loadAll(widget.productId),
    );
  }

  Future<void> _openCreate() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => VariantFormScreen(productId: widget.productId),
      ),
    );
    if (result == null || !mounted) return;

    final ok = await ref
        .read(productVariantNotifierProvider.notifier)
        .create(
          productId: widget.productId,
          sku: result['sku'],
          specs: result['specs'],
          price: result['price'],
          stockQuantity: result['stock_quantity'],
        );
    if (!mounted) return;
    AppSnackBar.show(
      context,
      message: ok ? 'Variant created.' : 'Failed to create variant.',
      type: ok ? SnackType.success : SnackType.error,
    );
  }

  Future<void> _openEdit(ProductVariantEntity variant) async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) =>
            VariantFormScreen(productId: widget.productId, existing: variant),
      ),
    );
    if (result == null || !mounted) return;

    final ok = await ref
        .read(productVariantNotifierProvider.notifier)
        .update(
          productId: widget.productId,
          variantId: variant.variantId,
          sku: result['sku'],
          specs: result['specs'],
          price: result['price'],
          stockQuantity: result['stock_quantity'],
        );
    if (!mounted) return;
    AppSnackBar.show(
      context,
      message: ok ? 'Variant updated.' : 'Failed to update variant.',
      type: ok ? SnackType.success : SnackType.error,
    );
  }

  Future<void> _confirmDelete(ProductVariantEntity variant) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDeleteDialog(
        title: 'Delete Variant',
        message:
            'Delete this variant? This will also remove its images and stock history.',
      ),
    );
    if (confirmed != true || !mounted) return;

    final ok = await ref
        .read(productVariantNotifierProvider.notifier)
        .delete(widget.productId, variant.variantId);
    if (!mounted) return;
    AppSnackBar.show(
      context,
      message: ok ? 'Variant deleted.' : 'Failed to delete variant.',
      type: ok ? SnackType.success : SnackType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productVariantNotifierProvider);
    final notifier = ref.read(productVariantNotifierProvider.notifier);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5F5F4);
    final cardBg = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE0DED8);
    final subText = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6B6B6B);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.productName,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Text('Variants', style: TextStyle(fontSize: 12, color: subText)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(height: 0.5, thickness: 0.5, color: borderColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_outlined, color: colors.primary),
            onPressed: state.isLoading
                ? null
                : () => notifier.loadAll(widget.productId),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.isCreating ? null : _openCreate,
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Variant',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.variants.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tune_outlined, size: 48, color: subText),
                  const SizedBox(height: 12),
                  Text(
                    'No variants yet.',
                    style: TextStyle(color: subText, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Add a variant to set price and stock.',
                    style: TextStyle(color: subText, fontSize: 13),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () => notifier.loadAll(widget.productId),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                itemCount: state.variants.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final v = state.variants[i];
                  final isWorking = state.loadingIds.contains(v.variantId);
                  final lowStock = v.stockQuantity <= 5;

                  return GestureDetector(
                    onTap: isWorking
                        ? null
                        : () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => VariantDetailScreen(
                                productId: widget.productId,
                                variantId: v.variantId,
                              ),
                            ),
                          ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 0.5),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          // Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 52,
                              height: 52,
                              child: v.primaryImageUrl != null
                                  ? Image.network(
                                      v.primaryImageUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: isDark
                                          ? const Color(0xFF3A3A3C)
                                          : const Color(0xFFEFEFED),
                                      child: Icon(
                                        Icons.tune_outlined,
                                        color: subText,
                                        size: 20,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (v.sku != null)
                                  Text(
                                    v.sku!,
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(color: subText),
                                  ),
                                if (v.specs.isNotEmpty) ...[
                                  const SizedBox(height: 3),
                                  Wrap(
                                    spacing: 4,
                                    children: v.specs.entries
                                        .take(3)
                                        .map(
                                          (e) => Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 7,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: colors.primaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              '${e.key}: ${e.value}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color:
                                                    colors.onPrimaryContainer,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      '\$${v.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: colors.primary,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: lowStock
                                            ? colors.errorContainer
                                            : colors.primaryContainer,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Stock: ${v.stockQuantity}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
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

                          // Actions
                          if (isWorking)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () => _openEdit(v),
                                  child: Icon(
                                    Icons.edit_outlined,
                                    color: colors.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () => _confirmDelete(v),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: colors.error,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
