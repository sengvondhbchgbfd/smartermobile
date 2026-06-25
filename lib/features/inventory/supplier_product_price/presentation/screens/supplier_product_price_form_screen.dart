import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/supplier_product_price_entity.dart';
import '../providers/supplier_product_price_provider.dart';

class SupplierProductPriceFormScreen extends ConsumerStatefulWidget {
  final SupplierProductPriceEntity? existing;
  final int? defaultSupplierId;
  final int? defaultVariantId;
  final Map<int, String> supplierNames;
  final Map<int, String> variantLabels;

  const SupplierProductPriceFormScreen({
    super.key,
    this.existing,
    this.defaultSupplierId,
    this.defaultVariantId,
    this.supplierNames = const {},
    this.variantLabels = const {},
  });

  bool get isEditing => existing != null;

  @override
  ConsumerState<SupplierProductPriceFormScreen> createState() =>
      _SupplierProductPriceFormScreenState();
}

class _SupplierProductPriceFormScreenState
    extends ConsumerState<SupplierProductPriceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _unitPriceController;
  late final TextEditingController _noteController;

  int? _supplierId;
  int? _variantId;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _supplierId = e?.supplierId ?? widget.defaultSupplierId;

    _variantId = e?.variantId ?? widget.defaultVariantId;

    _unitPriceController = TextEditingController(
      text: e?.unitPrice.toString() ?? '',
    );
    _noteController = TextEditingController(text: e?.note ?? '');
  }

  @override
  void dispose() {
    _unitPriceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_supplierId == null || _variantId == null) return;

    final notifier = ref.read(supplierProductPriceNotifierProvider.notifier);
    final unitPrice = double.parse(_unitPriceController.text);
    final note = _noteController.text.isEmpty ? null : _noteController.text;

    final success = widget.isEditing
        ? await notifier.update(
            priceId: widget.existing!.priceId,
            unitPrice: unitPrice,
            note: note,
          )
        : await notifier.create(
            supplierId: _supplierId!,
            variantId: _variantId!,
            unitPrice: unitPrice,
            note: note,
          );

    if (success && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supplierProductPriceNotifierProvider);
    final isBusy = widget.isEditing
        ? state.loadingIds.contains(widget.existing!.priceId)
        : state.isCreating;

    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5F5F4);
    final cardBg = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE0DED8);
    final searchBg = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFEFEFED);
    final subText = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6B6B6B);

    InputDecoration deco(String label, {IconData? icon}) => InputDecoration(
      labelText: label,
      prefixIcon: icon == null ? null : Icon(icon, size: 19, color: subText),
      filled: true,
      fillColor: searchBg,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.error, width: 1.2),
      ),
    );

    Widget readOnlyField({required IconData icon, required String label}) =>
        Container(
          decoration: BoxDecoration(
            color: searchBg,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 19, color: subText),
              const SizedBox(width: 10),
              Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
              Icon(Icons.lock_outline, size: 16, color: subText),
            ],
          ),
        );

    Widget card({required Widget child}) => Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );

    Widget sectionLabel(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 10),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: subText,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        title: Text(
          widget.isEditing ? 'Edit Price' : 'New Supplier Price',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            // ── Supplier ───────────────────────────────────────────────
            sectionLabel('Supplier'),
            card(
              child: widget.isEditing
                  ? readOnlyField(
                      icon: Icons.store_outlined,
                      label:
                          widget.supplierNames[_supplierId] ??
                          'Supplier #$_supplierId',
                    )
                  : DropdownButtonFormField<int>(
                      value: _supplierId,
                      onChanged: (v) => setState(() => _supplierId = v),
                      decoration: deco(
                        'Select supplier',
                        icon: Icons.store_outlined,
                      ),
                      isExpanded: true,
                      items: widget.supplierNames.entries
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(e.value),
                            ),
                          )
                          .toList(),
                      validator: (v) => v == null ? 'Select a supplier' : null,
                    ),
            ),

            // ── Variant ────────────────────────────────────────────────
            sectionLabel('Product Variant'),
            card(
              child: widget.isEditing
                  ? readOnlyField(
                      icon: Icons.tune_outlined,
                      label: (widget.existing!.sku?.isNotEmpty ?? false)
                          ? '${widget.existing!.productName} · ${widget.existing!.sku}'
                          : widget.existing!.productName,
                    )
                  :
                    ////////////////////////////////////////////////////////////
                    ///
                    ////////////////////////////////////////////////////////////
                    DropdownButtonFormField<int>(
                      value: _variantId,
                      onChanged: (v) => setState(() => _variantId = v),
                      decoration: deco(
                        'Select variant',
                        icon: Icons.tune_outlined,
                      ),
                      isExpanded: true,
                      items: widget.variantLabels.entries
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(
                                e.value,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      validator: (v) => v == null ? 'Select a variant' : null,
                    ),
              ///////////////////////////////////////////////////////////
              ///
              //////////////////////////////////////////////////////////
            ),

            // ── Price ──────────────────────────────────────────────────
            sectionLabel('Unit price'),
            card(
              child: TextFormField(
                controller: _unitPriceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: deco('Price', icon: Icons.attach_money_outlined),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  final parsed = double.tryParse(v);
                  if (parsed == null || parsed < 0) return 'Invalid number';
                  return null;
                },
              ),
            ),

            // ── Note ───────────────────────────────────────────────────
            sectionLabel('Note (optional)'),
            card(
              child: TextFormField(
                controller: _noteController,
                maxLength: 255,
                maxLines: 3,
                decoration: deco('e.g. bulk price, minimum order 100 units'),
              ),
            ),

            if (state.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  state.error!,
                  style: TextStyle(color: colors.error, fontSize: 13),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: SizedBox(
          height: 52,
          child: FilledButton(
            onPressed: isBusy ? null : _submit,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: isBusy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    widget.isEditing ? 'Save changes' : 'Create price',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
