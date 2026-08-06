import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

import '../../domain/entities/supplier_product_price_entity.dart';
import '../providers/supplier_product_price_provider.dart';

class SupplierProductPriceFormScreen extends ConsumerStatefulWidget {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  final SupplierProductPriceEntity? existing;
  final int? defaultSupplierId;
  final int? defaultVariantId;
  final Map<int, String> supplierNames;
  final Map<int, String> variantLabels;

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  const SupplierProductPriceFormScreen({
    super.key,
    this.existing,
    this.defaultSupplierId,
    this.defaultVariantId,
    this.supplierNames = const {},
    this.variantLabels = const {},
  });

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  bool get isEditing => existing != null;
  @override
  ConsumerState<SupplierProductPriceFormScreen> createState() =>
      _SupplierProductPriceFormScreenState();

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
}

class _SupplierProductPriceFormScreenState
    extends ConsumerState<SupplierProductPriceFormScreen> {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _unitPriceController;
  late final TextEditingController _noteController;
  int? _supplierId;
  int? _variantId;

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _unitPriceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _submit() async {
    ////////////////////////////////
    ///
    ///////////////////////////////
    if (!_formKey.currentState!.validate()) return;
    if (_supplierId == null || _variantId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a supplier and variant')),
      );
      return;
    }
    final notifier = ref.read(supplierProductPriceNotifierProvider.notifier);
    final unitPrice = double.parse(_unitPriceController.text);
    final noteText = _noteController.text.trim();
    final note = noteText.isEmpty ? null : noteText;
    final success = widget.isEditing
        ? await notifier.update(
            priceId: widget.existing!.priceId,
            supplierId: _supplierId,
            variantId: _variantId,
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

  ////////////////////////////////
  ///
  ///////////////////////////////
  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final state = ref.watch(supplierProductPriceNotifierProvider);
    final isBusy = widget.isEditing
        ? state.loadingIds.contains(widget.existing!.priceId)
        : state.isCreating;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final cardBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final borderColor = isDark ? Pallets.borderDark : Pallets.borderLight;
    final searchBg = isDark ? Pallets.surfaceElevated : Pallets.borderLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final subText = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

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
        borderSide: const BorderSide(color: Pallets.blurple, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Pallets.error, width: 1.2),
      ),
    );

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    Widget card({required Widget child}) => Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

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
            color: textPrimary,
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
              child: DropdownButtonFormField<int>(
                value: _supplierId,
                onChanged: (v) => setState(() => _supplierId = v),
                decoration: deco('Select supplier', icon: Icons.store_outlined),
                style: TextStyle(color: textPrimary, fontSize: 15),
                isExpanded: true,
                items: widget.supplierNames.entries
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e.key, child: Text(e.value)),
                    )
                    .toList(),
                validator: (v) => v == null ? 'Select a supplier' : null,
              ),
            ),

            // ── Variant ────────────────────────────────────────────────
            sectionLabel('Product Variant'),
            card(
              child: DropdownButtonFormField<int>(
                value: _variantId,
                onChanged: (v) => setState(() => _variantId = v),
                decoration: deco('Select variant', icon: Icons.tune_outlined),
                style: TextStyle(color: textPrimary, fontSize: 15),
                isExpanded: true,
                items: widget.variantLabels.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                validator: (v) => v == null ? 'Select a variant' : null,
              ),
            ),

            // ── Price ──────────────────────────────────────────────────
            sectionLabel('Unit price'),
            card(
              child: TextFormField(
                controller: _unitPriceController,
                style: TextStyle(color: textPrimary, fontSize: 15),
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
                style: TextStyle(color: textPrimary, fontSize: 15),
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
                  style: const TextStyle(color: Pallets.error, fontSize: 13),
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
              backgroundColor: Pallets.blurple,
              foregroundColor: Pallets.onAccent,
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
                      color: Pallets.onAccent,
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
