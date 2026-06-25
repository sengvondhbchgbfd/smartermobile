import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';

class VariantFormScreen extends StatefulWidget {
  final int productId;
  final ProductVariantEntity? existing;
  const VariantFormScreen({required this.productId, this.existing, super.key});
  @override
  State<VariantFormScreen> createState() => _VariantFormScreenState();
}

class _VariantFormScreenState extends State<VariantFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _skuCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _stockCtrl;

  // specs: list of key/value pairs
  final List<_SpecEntry> _specs = [];
  bool _isSubmitting = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final v = widget.existing;
    _skuCtrl = TextEditingController(text: v?.sku);
    _priceCtrl = TextEditingController(text: v?.price.toString());
    _stockCtrl = TextEditingController(text: v?.stockQuantity.toString());

    if (v != null) {
      _specs.addAll(
        v.specs.entries.map(
          (e) => _SpecEntry(
            key: TextEditingController(text: e.key),
            value: TextEditingController(text: e.value.toString()),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _skuCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    for (final s in _specs) {
      s.key.dispose();
      s.value.dispose();
    }
    super.dispose();
  }

  void _addSpec() => setState(
    () => _specs.add(
      _SpecEntry(key: TextEditingController(), value: TextEditingController()),
    ),
  );

  void _removeSpec(int i) {
    setState(() {
      _specs[i].key.dispose();
      _specs[i].value.dispose();
      _specs.removeAt(i);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 80));
    if (!mounted) return;

    final specs = <String, dynamic>{
      for (final s in _specs)
        if (s.key.text.trim().isNotEmpty)
          s.key.text.trim(): s.value.text.trim(),
    };

    Navigator.of(context).pop({
      'sku': _skuCtrl.text.trim().isEmpty ? null : _skuCtrl.text.trim(),
      'specs': specs,
      'price': double.parse(_priceCtrl.text.trim()),
      'stock_quantity': int.parse(_stockCtrl.text.trim()),
    });
  }

  @override
  Widget build(BuildContext context) {
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

    InputDecoration deco(String label, {String? hint, String? prefix}) =>
        InputDecoration(
          labelText: label,
          hintText: hint,
          prefixText: prefix,
          filled: true,
          fillColor: searchBg,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
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

    Widget sectionLabel(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 22, 4, 10),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: subText,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.7,
        ),
      ),
    );

    Widget card({required Widget child}) => Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          _isEdit ? 'Edit variant' : 'New variant',
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
            // ── SKU ───────────────────────────────────────────────────────
            sectionLabel('Identifier'),
            card(
              child: TextFormField(
                controller: _skuCtrl,
                decoration: deco('SKU (optional)', hint: 'e.g. SHIRT-RED-XL'),
              ),
            ),

            // ── Price & Stock ─────────────────────────────────────────────
            sectionLabel('Pricing & stock'),
            card(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceCtrl,
                      decoration: deco('Price', prefix: '\$ '),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (double.tryParse(v.trim()) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stockCtrl,
                      decoration: deco('Stock qty'),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (int.tryParse(v.trim()) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ── Specs ─────────────────────────────────────────────────────
            sectionLabel('Specifications'),
            card(
              child: Column(
                children: [
                  if (_specs.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'No specs yet. Add key/value pairs like color: red.',
                        style: TextStyle(color: subText, fontSize: 13),
                      ),
                    ),
                  ..._specs.asMap().entries.map((entry) {
                    final i = entry.key;
                    final s = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: s.key,
                              decoration: deco('Key', hint: 'color'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: s.value,
                              decoration: deco('Value', hint: 'red'),
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            onPressed: () => _removeSpec(i),
                            icon: Icon(
                              Icons.remove_circle_outline,
                              color: colors.error,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  TextButton.icon(
                    onPressed: _addSpec,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add spec'),
                  ),
                ],
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
            onPressed: _isSubmitting ? null : _submit,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    _isEdit ? 'Save changes' : 'Create variant',
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

class _SpecEntry {
  final TextEditingController key;
  final TextEditingController value;
  _SpecEntry({required this.key, required this.value});
}
