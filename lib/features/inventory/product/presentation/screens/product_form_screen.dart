import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/product/presentation/widgets/card.dart';
import 'package:frontendmobile/features/inventory/product/presentation/widgets/section_header.dart'
    show SectionHeader;
import '../../domain/entities/product_entity.dart';
import '../../../categories/domain/entities/category_entity.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductEntity? existing;
  final List<CategoryEntity> categories;
  const ProductFormScreen({this.existing, required this.categories, super.key});
  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}
////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _ProductFormScreenState extends State<ProductFormScreen> {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final List<CategoryEntity> _categories;
  int? _categoryId;
  bool _isSubmitting = false;
  bool get _isEdit => widget.existing != null;
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();

    final seenIds = <int>{};
    _categories = widget.categories
        .where((c) => seenIds.add(c.categoryId))
        .toList();

    final p = widget.existing;
    _nameCtrl = TextEditingController(text: p?.name);
    _descCtrl = TextEditingController(text: p?.description);

    final initialCategoryId = p?.categoryId;
    _categoryId =
        (initialCategoryId != null &&
            _categories.any((c) => c.categoryId == initialCategoryId))
        ? initialCategoryId
        : null;
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 80));
    if (!mounted) return;

    Navigator.of(context).pop({
      'name': _nameCtrl.text.trim(),
      'category_id': _categoryId,
      'description': _descCtrl.text.trim().isEmpty
          ? null
          : _descCtrl.text.trim(),
    });
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5F5F4);
    final borderColor = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE0DED8);
    final searchBg = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFEFEFED);
    final subText = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6B6B6B);

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    InputDecoration deco(
      String label, {
      String? hint,
      String? prefix,
      IconData? icon,
    }) => InputDecoration(
      labelText: label,
      hintText: hint,
      prefixText: prefix,
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

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          _isEdit ? 'Edit product' : 'New product',
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
            ////////////////////////////////////////////////////////////////////
            // ── Basics ───────────────────────────────────────────────────
            ////////////////////////////////////////////////////////////////////
            SectionHeader(
              icon: Icons.tune_outlined,
              text: 'Basic',
              subText: subText,
            ),
            DetailCard(
              cardBg: bg,
              borderColor: borderColor,
              isDark: isDark,

              child: Column(
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: deco('Product name', icon: Icons.label_outline),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Enter a product name'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<int?>(
                    initialValue: _categoryId,
                    decoration: deco('Category', icon: Icons.sell_outlined),
                    hint: const Text('No category'),
                    borderRadius: BorderRadius.circular(12),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('No category'),
                      ),
                      ..._categories.map(
                        (c) => DropdownMenuItem<int?>(
                          value: c.categoryId,
                          child: Text(c.categoryName),
                        ),
                      ),
                    ],
                    onChanged: (v) => setState(() => _categoryId = v),
                  ),
                ],
              ),
            ),

            ////////////////////////////////////////////////////////////////////
            // ── Description ───────────────────────────────────────────────
            ////////////////////////////////////////////////////////////////////
            SectionHeader(
              icon: Icons.tune_outlined,
              text: 'Description',
              subText: subText,
            ),
            DetailCard(
              cardBg: bg,
              borderColor: borderColor,
              isDark: isDark,
              child: TextFormField(
                controller: _descCtrl,
                decoration: deco(
                  'Description (optional)',
                  hint: 'Notes, materials, usage…',
                ).copyWith(alignLabelWithHint: true),
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),

            ////////////////////////////////////////////////////////////////////
            // ── Variants hint ─────────────────────────────────────────────
            ////////////////////////////////////////////////////////////////////
            SectionHeader(
              icon: Icons.tune_outlined,
              text: 'Pricing & stock',
              subText: subText,
            ),
            Container(
              decoration: BoxDecoration(
                color: colors.primaryContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.25),
                ),
              ),
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: colors.primary, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _isEdit
                          ? 'Manage price, stock, and specs via the Variants tab.'
                          : 'After creating the product, add variants to set price, stock, and specs.',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.primary,
                        height: 1.4,
                      ),
                    ),
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
                    _isEdit ? 'Save changes' : 'Create product',
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
