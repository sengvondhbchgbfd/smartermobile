import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/inventory/categories/domain/entities/category_entity.dart';
import 'package:frontendmobile/features/inventory/categories/presentation/providers/category_provider.dart';
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';
import 'package:frontendmobile/features/inventory/stock_movements/presentation/widgets/field_label.dart';

typedef VariantRecord = ({ProductEntity product, ProductVariantEntity variant});

class StockMovementFormDialog extends ConsumerStatefulWidget {
  final List<VariantRecord> variants;
  final int? preselectedProductId;
  final int? preselectedVariantId;

  const StockMovementFormDialog({
    required this.variants,
    this.preselectedProductId,
    this.preselectedVariantId,
    super.key,
  });

  @override
  ConsumerState<StockMovementFormDialog> createState() =>
      _StockMovementFormDialogState();
}

class _StockMovementFormDialogState
    extends ConsumerState<StockMovementFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _qtyCtrl = TextEditingController();

  static const _uncategorized = 'uncategorized';

  String? _selectedCategoryKey;
  ProductEntity? _selectedProduct;
  VariantRecord? _selected;
  String _direction = 'in';
  String _movementType = 'purchase';
  DateTime _date = DateTime.now();

  static const _movementTypes = [
    'purchase',
    'sale',
    'return',
    'adjustment',
    'transfer',
    'damage',
  ];

  // ── Category / Product / Variant cascading helpers ──────────────────

  String _categoryKeyOf(VariantRecord r) =>
      r.product.categoryId?.toString() ?? _uncategorized;

  String _categoryLabel(String key, List<CategoryEntity> categories) {
    if (key == _uncategorized) return 'Uncategorized';
    final id = int.tryParse(key);
    final match = categories.where((c) => c.categoryId == id).firstOrNull;
    return match?.categoryName ?? 'Category #$key';
  }

  List<String> get _categoryKeys {
    final keys = widget.variants.map(_categoryKeyOf).toSet().toList();
    final categories = ref.read(categoryNotifierProvider).categories;
    keys.sort((a, b) {
      if (a == _uncategorized) return 1;
      if (b == _uncategorized) return -1;
      return _categoryLabel(
        a,
        categories,
      ).compareTo(_categoryLabel(b, categories));
    });
    return keys;
  }

  List<ProductEntity> get _productsInSelectedCategory {
    if (_selectedCategoryKey == null) return const [];
    final seen = <int>{};
    final products = <ProductEntity>[];
    for (final r in widget.variants) {
      if (_categoryKeyOf(r) != _selectedCategoryKey) continue;
      if (seen.add(r.product.productId)) products.add(r.product);
    }
    products.sort((a, b) => a.name.compareTo(b.name));
    return products;
  }

  List<VariantRecord> get _variantsForSelectedProduct {
    if (_selectedProduct == null) return const [];
    return widget.variants
        .where((r) => r.product.productId == _selectedProduct!.productId)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(categoryNotifierProvider.notifier).loadAll();
    });

    if (widget.preselectedVariantId != null) {
      final match = widget.variants.where((r) {
        final variantMatches =
            r.variant.variantId == widget.preselectedVariantId;
        if (widget.preselectedProductId != null) {
          return variantMatches &&
              r.product.productId == widget.preselectedProductId;
        }
        return variantMatches;
      }).firstOrNull;
      if (match != null) {
        _selectedCategoryKey = _categoryKeyOf(match);
        _selectedProduct = match.product;
        _selected = match;
      }
    }
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final qty = int.parse(_qtyCtrl.text.trim());
    Navigator.of(context).pop({
      'variant_id': _selected!.variant.variantId,
      'product_id': _selected!.product.productId,
      'qty_in': _direction == 'in' ? qty : 0,
      'qty_out': _direction == 'out' ? qty : 0,
      'movement_type': _movementType,
      'date': _date,
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  bool get _isLocked =>
      widget.preselectedVariantId != null && _selected != null;

  Widget _lockedVariantSummary(
    ColorScheme colors,
    List<CategoryEntity> categories,
  ) {
    final r = _selected!;
    final categoryLabel = _categoryLabel(_categoryKeyOf(r), categories);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.inventory_2_outlined, size: 20, color: colors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.product.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  '${r.variant.sku ?? 'Variant #${r.variant.variantId}'} · $categoryLabel',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${r.variant.stockQuantity} in stock',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final currentStock = _selected?.variant.stockQuantity;
    final categories = ref.watch(categoryNotifierProvider).categories;

    return Dialog(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'New Stock Movement',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
            Divider(
              height: 20,
              indent: 24,
              endIndent: 24,
              color: colors.outlineVariant,
            ),

            // Form body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_isLocked) ...[
                        const FieldLabel('Variant'),
                        const SizedBox(height: 6),
                        _lockedVariantSummary(colors, categories),
                        const SizedBox(height: 16),
                      ] else ...[
                        const FieldLabel('Category'),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _selectedCategoryKey,
                          isExpanded: true,
                          decoration: _inputDeco(colors),
                          hint: const Text('Select category'),
                          items: _categoryKeys
                              .map(
                                (key) => DropdownMenuItem(
                                  value: key,
                                  child: Text(_categoryLabel(key, categories)),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() {
                            _selectedCategoryKey = v;
                            _selectedProduct = null;
                            _selected = null;
                          }),
                          validator: (v) =>
                              v == null ? 'Please select a category' : null,
                        ),
                        const SizedBox(height: 16),

                        const FieldLabel('Product'),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<ProductEntity>(
                          value: _selectedProduct,
                          isExpanded: true,
                          decoration: _inputDeco(colors),
                          hint: Text(
                            _selectedCategoryKey == null
                                ? 'Select a category first'
                                : 'Select product',
                          ),
                          items: _selectedCategoryKey == null
                              ? null
                              : _productsInSelectedCategory
                                    .map(
                                      (p) => DropdownMenuItem(
                                        value: p,
                                        child: Text(
                                          p.name,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                          onChanged: _selectedCategoryKey == null
                              ? null
                              : (v) => setState(() {
                                  _selectedProduct = v;
                                  _selected = null;
                                }),
                          validator: (v) =>
                              v == null ? 'Please select a product' : null,
                        ),
                        const SizedBox(height: 16),

                        const FieldLabel('Variant'),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<VariantRecord>(
                          value: _selected,
                          isExpanded: true,
                          decoration: _inputDeco(colors),
                          hint: Text(
                            _selectedProduct == null
                                ? 'Select a product first'
                                : 'Select variant',
                          ),
                          items: _selectedProduct == null
                              ? null
                              : _variantsForSelectedProduct.map((r) {
                                  final label =
                                      r.variant.sku ??
                                      'Variant #${r.variant.variantId}';
                                  return DropdownMenuItem(
                                    value: r,
                                    child: Text(
                                      '$label  (${r.variant.stockQuantity} in stock)',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                          onChanged: _selectedProduct == null
                              ? null
                              : (v) => setState(() => _selected = v),
                          validator: (v) =>
                              v == null ? 'Please select a variant' : null,
                        ),
                        const SizedBox(height: 16),
                      ],

                      const FieldLabel('Direction'),
                      const SizedBox(height: 6),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'in',
                            label: Text('Stock In'),
                            icon: Icon(Icons.south_rounded, size: 16),
                          ),
                          ButtonSegment(
                            value: 'out',
                            label: Text('Stock Out'),
                            icon: Icon(Icons.north_rounded, size: 16),
                          ),
                        ],
                        selected: {_direction},
                        onSelectionChanged: (s) =>
                            setState(() => _direction = s.first),
                        style: ButtonStyle(
                          visualDensity: VisualDensity.compact,
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const FieldLabel('Movement type'),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _movementType,
                        decoration: _inputDeco(colors),
                        items: _movementTypes
                            .map(
                              (t) => DropdownMenuItem(
                                value: t,
                                child: Text(
                                  t[0].toUpperCase() + t.substring(1),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _movementType = v ?? 'purchase'),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          const Expanded(child: FieldLabel('Quantity')),
                          if (currentStock != null)
                            Text(
                              'Current: $currentStock',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _qtyCtrl,
                        decoration: _inputDeco(colors).copyWith(
                          hintText: '0',
                          prefixIcon: Icon(
                            _direction == 'in'
                                ? Icons.add_rounded
                                : Icons.remove_rounded,
                            size: 18,
                            color: _direction == 'in'
                                ? const Color(0xFF22C55E)
                                : colors.error,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Quantity is required';
                          }
                          final n = int.tryParse(v.trim());
                          if (n == null || n <= 0) {
                            return 'Enter a valid positive number';
                          }
                          if (_direction == 'out' &&
                              currentStock != null &&
                              n > currentStock) {
                            return 'Exceeds available stock ($currentStock)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      const FieldLabel('Date'),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: colors.outline),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: colors.onSurfaceVariant,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${_date.year}-'
                                '${_date.month.toString().padLeft(2, '0')}-'
                                '${_date.day.toString().padLeft(2, '0')}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Actions
            Divider(height: 1, color: colors.outlineVariant),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Record Movement'),
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

  InputDecoration _inputDeco(ColorScheme colors) => InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: colors.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: colors.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: colors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: colors.error),
    ),
    filled: true,
    fillColor: colors.surfaceContainerLow,
  );
}
