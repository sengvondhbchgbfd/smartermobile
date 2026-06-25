import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';
import '../../domain/entities/stock_movement_entity.dart';

typedef VariantRecord = ({ProductEntity product, ProductVariantEntity variant});

// ---------------------------------------------------------------------------
// Movement Tile
// ---------------------------------------------------------------------------

class StockMovementTile extends StatelessWidget {
  final StockMovementEntity movement;
  final String variantLabel;
  final VoidCallback onDelete;

  const StockMovementTile({
    required this.movement,
    required this.variantLabel,
    required this.onDelete,
    super.key,
  });

  // ✅ Bug 1 fix: removed misplaced initState — StatelessWidget has no lifecycle

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isIn = movement.qtyIn > 0;
    final qty = isIn ? movement.qtyIn : movement.qtyOut;
    final accentColor = isIn ? const Color(0xFF22C55E) : colors.error;
    final accentBg = isIn
        ? const Color(0xFF22C55E).withOpacity(0.10)
        : colors.error.withOpacity(0.10);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outlineVariant.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accentBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isIn ? Icons.south_rounded : Icons.north_rounded,
                color: accentColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    variantLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (movement.movementType != null) ...[
                        _TypeChip(label: movement.movementType!),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        _formatDate(movement.date),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIn ? '+' : '−'}$qty',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'bal ${movement.balanceQuantity}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

class _TypeChip extends StatelessWidget {
  final String label;
  const _TypeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label[0].toUpperCase() + label.substring(1),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colors.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Form Dialog
// ---------------------------------------------------------------------------

class StockMovementFormDialog extends StatefulWidget {
  final List<VariantRecord> variants;
  final int? preselectedVariantId;

  const StockMovementFormDialog({
    required this.variants,
    this.preselectedVariantId,
    super.key,
  });

  @override
  State<StockMovementFormDialog> createState() =>
      _StockMovementFormDialogState();
}

class _StockMovementFormDialogState extends State<StockMovementFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _qtyCtrl = TextEditingController();

  VariantRecord? _selected;
  String _direction = 'in';
  String _movementType = 'purchase';
  DateTime _date = DateTime.now();

  // ✅ Bug 2 fix: no duplicates, no stock_in/stock_out mixed in
  static const _movementTypes = [
    'purchase',
    'sale',
    'return',
    'adjustment',
    'transfer',
    'damage',
  ];

  @override
  void initState() {
    super.initState();
    // ✅ Bug 1 fix: initState now correctly inside State class
    if (widget.preselectedVariantId != null) {
      _selected = widget.variants
          .where((r) => r.variant.variantId == widget.preselectedVariantId)
          .firstOrNull;
    }
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selected == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a variant.')));
      return;
    }
    final qty = int.parse(_qtyCtrl.text.trim());
    Navigator.of(context).pop({
      'variant_id': _selected!.variant.variantId,
      'product_id': _selected!
          .product
          .productId, // ✅ Bug 3: verify matches your ProductEntity field
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final currentStock = _selected?.variant.stockQuantity;

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
                      const _FieldLabel('Variant'),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<VariantRecord>(
                        value: _selected,
                        isExpanded: true,
                        decoration: _inputDeco(colors),
                        hint: const Text('Select variant'),
                        items: widget.variants.map((r) {
                          final label = r.variant.sku != null
                              ? '${r.product.name} — ${r.variant.sku}'
                              : r.product.name;
                          return DropdownMenuItem(
                            value: r,
                            child: Text(
                              '$label  (${r.variant.stockQuantity} in stock)',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => _selected = v),
                        validator: (v) =>
                            v == null ? 'Please select a variant' : null,
                      ),
                      const SizedBox(height: 16),

                      const _FieldLabel('Direction'),
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

                      const _FieldLabel('Movement type'),
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
                          const Expanded(child: _FieldLabel('Quantity')),
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

                      const _FieldLabel('Date'),
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

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
}
