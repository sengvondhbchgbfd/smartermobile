import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import '../../domain/entities/quotation_item_entity.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

Future<QuotationItemEntity?> showQuotationItemFormSheet(
  BuildContext context, {
  QuotationItemEntity? initial,
  required int nextSortOrder,
}) {
  return showModalBottomSheet<QuotationItemEntity>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>
        _QuotationItemFormSheet(initial: initial, nextSortOrder: nextSortOrder),
  );
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _QuotationItemFormSheet extends StatefulWidget {
  final QuotationItemEntity? initial;
  final int nextSortOrder;

  const _QuotationItemFormSheet({this.initial, required this.nextSortOrder});

  @override
  State<_QuotationItemFormSheet> createState() =>
      _QuotationItemFormSheetState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _QuotationItemFormSheetState extends State<_QuotationItemFormSheet> {
  final _formKey = GlobalKey<FormState>();

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  late final TextEditingController _nameCtrl;
  late final TextEditingController _sizeCtrl;
  late final TextEditingController _pagesCtrl;
  late final TextEditingController _printSideCtrl;
  late final TextEditingController _colorSpecCtrl;
  late final TextEditingController _paperCoverCtrl;
  late final TextEditingController _paperInsideCtrl;
  late final TextEditingController _finishingCtrl;
  late final TextEditingController _languageCtrl;
  late final TextEditingController _quantityCtrl;
  late final TextEditingController _unitPriceCtrl;
  late final TextEditingController _noteCtrl;
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _nameCtrl = TextEditingController(text: i?.itemName ?? '');
    _sizeCtrl = TextEditingController(text: i?.size ?? '');
    _pagesCtrl = TextEditingController(text: i?.pages?.toString() ?? '');
    _printSideCtrl = TextEditingController(text: i?.printSide ?? '');
    _colorSpecCtrl = TextEditingController(text: i?.colorSpec ?? '');
    _paperCoverCtrl = TextEditingController(text: i?.paperCover ?? '');
    _paperInsideCtrl = TextEditingController(text: i?.paperInside ?? '');
    _finishingCtrl = TextEditingController(text: i?.finishing ?? '');
    _languageCtrl = TextEditingController(text: i?.language ?? '');
    _quantityCtrl = TextEditingController(text: i?.quantity.toString() ?? '1');
    _unitPriceCtrl = TextEditingController(text: i?.unitPrice.toString() ?? '');
    _noteCtrl = TextEditingController(text: i?.note ?? '');
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _nameCtrl.dispose();
    _sizeCtrl.dispose();
    _pagesCtrl.dispose();
    _printSideCtrl.dispose();
    _colorSpecCtrl.dispose();
    _paperCoverCtrl.dispose();
    _paperInsideCtrl.dispose();
    _finishingCtrl.dispose();
    _languageCtrl.dispose();
    _quantityCtrl.dispose();
    _unitPriceCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final quantity = int.tryParse(_quantityCtrl.text) ?? 0;
    final unitPrice = double.tryParse(_unitPriceCtrl.text) ?? 0;
    final result = QuotationItemEntity(
      itemId: widget.initial?.itemId ?? 0,
      quotationId: widget.initial?.quotationId ?? 0,
      sortOrder: widget.initial?.sortOrder ?? widget.nextSortOrder,
      itemName: _nameCtrl.text.trim(),
      size: _sizeCtrl.text.trim().isEmpty ? null : _sizeCtrl.text.trim(),
      pages: int.tryParse(_pagesCtrl.text),
      printSide: _printSideCtrl.text.trim().isEmpty
          ? null
          : _printSideCtrl.text.trim(),
      colorSpec: _colorSpecCtrl.text.trim().isEmpty
          ? null
          : _colorSpecCtrl.text.trim(),
      paperCover:
          _paperCoverCtrl.text
              .trim()
              .isEmpty // NEW
          ? null
          : _paperCoverCtrl.text.trim(),
      paperInside: _paperInsideCtrl.text.trim().isEmpty
          ? null
          : _paperInsideCtrl.text.trim(),
      finishing: _finishingCtrl.text.trim().isEmpty
          ? null
          : _finishingCtrl.text.trim(),
      language: _languageCtrl.text.trim().isEmpty
          ? null
          : _languageCtrl.text.trim(),
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: quantity * unitPrice,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
    );
    Navigator.of(context).pop(result);
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.surfaceOverlay : Pallets.surfaceLight;
    final isEditing = widget.initial != null;

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),

      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),

        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Pallets.textMuted.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                Text(
                  isEditing ? 'Edit Item' : 'Add Item',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? Pallets.textPrimaryDark
                        : Pallets.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 16),
                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Item name *'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _sizeCtrl,
                        decoration: const InputDecoration(labelText: 'Size'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _pagesCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Pages'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _printSideCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Print side',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _colorSpecCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Color spec',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _paperCoverCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Paper cover',
                          hintText: 'e.g. Glossy 260g',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ////////////////////////////////////////////////////////////
                    ///
                    ////////////////////////////////////////////////////////////
                    Expanded(
                      child: TextFormField(
                        controller: _paperInsideCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Paper inside',
                          hintText: 'e.g. WF70g',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                TextFormField(
                  controller: _finishingCtrl,
                  decoration: const InputDecoration(labelText: 'Finishing'),
                ),
                const SizedBox(height: 12),

                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                TextFormField(
                  controller: _languageCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Language',
                    hintText: 'e.g. KH, EN',
                  ),
                ),
                const SizedBox(height: 12),
                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _quantityCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantity *',
                        ),
                        validator: (v) {
                          final n = int.tryParse(v ?? '');
                          if (n == null || n <= 0) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ////////////////////////////////////////////////////////////
                    ///
                    ////////////////////////////////////////////////////////////
                    Expanded(
                      child: TextFormField(
                        controller: _unitPriceCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Unit price *',
                        ),
                        validator: (v) {
                          final n = double.tryParse(v ?? '');
                          if (n == null || n < 0) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                TextFormField(
                  controller: _noteCtrl,
                  decoration: const InputDecoration(labelText: 'Note'),
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallets.blurple,
                      foregroundColor: Pallets.onAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submit,
                    child: Text(isEditing ? 'Save Changes' : 'Add Item'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
