import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/widgets/loading/upload_loading_Indicator.dart';
import 'package:frontendmobile/features/inventory/categories/presentation/widgets/field_row.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/category_entity.dart';

class CategoryFormPage extends StatefulWidget {
  final CategoryEntity? existing;
  const CategoryFormPage({this.existing, super.key});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  File? _image;
  bool _uploading = false;
  bool _picking = false;
  int _uploadPercent = 0;
  String? _serverError;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.categoryName);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  // ── Image picker ───────────────────────────────────────────────────────────
  Future<void> _pickImage() async {
    if (_picking || _uploading) return;
    _picking = true;
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked == null) return;

      final bytes = await picked.length();
      if (bytes > 5 * 1024 * 1024) {
        if (mounted) {
          setState(
            () => _serverError =
                'Image exceeds 5MB. Please choose a smaller file.',
          );
        }
        return;
      }

      if (mounted)
        setState(() {
          _uploading = true;
          _uploadPercent = 0;
        });

      for (int i = 1; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 60));
        if (mounted) setState(() => _uploadPercent = i);
      }

      if (mounted) {
        setState(() {
          _uploading = false;
          _image = File(picked.path);
          _serverError = null; // ← clear any previous error on success
        });
      }
    } finally {
      _picking = false; // ← always release
    }
  }

  // ── Submit ─────────────────────────────────────────────────────────────────
  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(
      context,
    ).pop({'category_name': _nameCtrl.text.trim(), 'image': _image});
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final cardBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final borderColor = isDark ? Pallets.borderDark : Pallets.borderLight;
    final subText = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        surfaceTintColor: Pallets.transparent,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _isEdit ? 'Edit Category' : 'New Category',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(height: 0.5, thickness: 0.5, color: borderColor),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Server error ───────────────────────────────────────────────
            if (_serverError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Pallets.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Pallets.error.withOpacity(0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Pallets.error, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _serverError!,
                          style: TextStyle(fontSize: 13, color: Pallets.error),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _serverError = null),
                        child: Icon(
                          Icons.close_rounded,
                          color: Pallets.error,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // ── Image picker ───────────────────────────────────────────────
            GestureDetector(
              onTap: (_uploading || _picking) ? null : _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 0.5),
                  image: (!_uploading && _image != null)
                      ? DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        )
                      : (!_uploading && widget.existing?.imageUrl != null)
                      ? DecorationImage(
                          image: NetworkImage(widget.existing!.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _uploading
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: UploadLoadingIndicator(
                            percentage: _uploadPercent,
                          ),
                        ),
                      )
                    : (_image == null && widget.existing?.imageUrl == null)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Pallets.surfaceElevated
                                  : const Color(0xFFEFEFED),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 28,
                              color: subText,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Tap to upload image',
                            style: TextStyle(
                              fontSize: 14,
                              color: subText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'JPG, PNG up to 5MB',
                            style: TextStyle(fontSize: 12, color: subText),
                          ),
                        ],
                      )
                    : Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit_rounded,
                                  size: 13,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Change',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Fields ─────────────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor, width: 0.5),
              ),
              child: FieldRow(
                label: 'Category Name',
                // showDivider removed — only one field, no divider needed
                child: TextFormField(
                  controller: _nameCtrl,
                  style: TextStyle(fontSize: 14, color: textPrimary),
                  decoration: InputDecoration(
                    hintText: 'e.g. Electronics',
                    hintStyle: TextStyle(color: subText, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              height: 50,
              child: FilledButton(
                onPressed: _uploading ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: Pallets.blurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _isEdit ? 'Save Changes' : 'Create Category',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
