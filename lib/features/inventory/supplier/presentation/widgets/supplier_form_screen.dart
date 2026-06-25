import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/supplier_color.dart';
import 'package:frontendmobile/features/inventory/supplier/domain/entities/supplier.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/supplier_provider.dart';

class SupplierFormScreen extends ConsumerStatefulWidget {
  final SupplierEntity? existing;
  const SupplierFormScreen({this.existing, super.key});

  @override
  ConsumerState<SupplierFormScreen> createState() => _SupplierFormScreenState();
}

class _SupplierFormScreenState extends ConsumerState<SupplierFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _contactPersonCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _phone2Ctrl; // ✅ add
  late final TextEditingController _emailCtrl;
  late final TextEditingController _addressCtrl;
  File? _avatar;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name);
    _contactPersonCtrl = TextEditingController(
      text: widget.existing?.contactPerson,
    );
    _phoneCtrl = TextEditingController(text: widget.existing?.phone);
    _phone2Ctrl = TextEditingController(text: widget.existing?.phone2); // ✅
    _emailCtrl = TextEditingController(text: widget.existing?.email);
    _addressCtrl = TextEditingController(text: widget.existing?.address);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _contactPersonCtrl.dispose();
    _phoneCtrl.dispose();
    _phone2Ctrl.dispose(); // ✅
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) setState(() => _avatar = File(picked.path));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(supplierNotifierProvider.notifier);

    String? _nullIfEmpty(String s) => s.trim().isEmpty ? null : s.trim();

    final contactPerson = _nullIfEmpty(_contactPersonCtrl.text);
    final phone = _nullIfEmpty(_phoneCtrl.text);
    final phone2 = _nullIfEmpty(_phone2Ctrl.text); // ✅
    final email = _nullIfEmpty(_emailCtrl.text);
    final address = _nullIfEmpty(_addressCtrl.text);

    final bool success;
    if (_isEdit) {
      success = await notifier.update(
        supplierId: widget.existing!.supplierId,
        name: _nameCtrl.text.trim(),
        contactPerson: contactPerson,
        phone: phone,
        phone2: phone2, // ✅
        email: email,
        address: address,
        avatar: _avatar,
      );
    } else {
      success = await notifier.create(
        name: _nameCtrl.text.trim(),
        contactPerson: contactPerson,
        phone: phone,
        phone2: phone2, // ✅
        email: email,
        address: address,
        avatar: _avatar,
      );
    }

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEdit ? 'Supplier updated.' : 'Supplier created.'),
        ),
      );
      Navigator.of(context).pop();
    } else {
      final err =
          ref.read(supplierNotifierProvider).error ?? 'An error occurred';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  InputDecoration _decoration(SupplierColors c, String label) =>
      InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: c.textSecondary),
        filled: true,
        fillColor: c.surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.accent, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.danger),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final c = SupplierColors.of(context);
    final state = ref.watch(supplierNotifierProvider);
    final isProcessing =
        state.isCreating ||
        (_isEdit && state.loadingIds.contains(widget.existing!.supplierId));

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _isEdit ? 'Edit supplier' : 'New supplier',
          style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w600),
        ),
        actions: [
          if (isProcessing)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: c.accent,
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _save,
              child: Text(
                'Save',
                style: TextStyle(color: c.accent, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            children: [
              // ── Avatar ─────────────────────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: isProcessing ? null : _pickAvatar,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: c.accentMuted,
                        backgroundImage: _avatar != null
                            ? FileImage(_avatar!)
                            : (widget.existing?.avatarUrl != null
                                  ? NetworkImage(widget.existing!.avatarUrl!)
                                        as ImageProvider
                                  : null),
                        child:
                            (_avatar == null &&
                                widget.existing?.avatarUrl == null)
                            ? Icon(
                                Icons.camera_alt_outlined,
                                size: 28,
                                color: c.accent,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: c.accent,
                            border: Border.all(color: c.background, width: 2),
                          ),
                          child: Icon(Icons.edit, size: 14, color: c.onAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // ── Name ───────────────────────────────────────────────────
              TextFormField(
                controller: _nameCtrl,
                enabled: !isProcessing,
                style: TextStyle(color: c.textPrimary),
                decoration: _decoration(c, 'Name'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),

              // ── Contact person ─────────────────────────────────────────
              TextFormField(
                controller: _contactPersonCtrl,
                enabled: !isProcessing,
                style: TextStyle(color: c.textPrimary),
                decoration: _decoration(c, 'Contact person (optional)'),
              ),
              const SizedBox(height: 16),

              // ── Phone ──────────────────────────────────────────────────
              TextFormField(
                controller: _phoneCtrl,
                enabled: !isProcessing,
                style: TextStyle(color: c.textPrimary),
                decoration: _decoration(c, 'Phone (optional)'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // ── Phone 2 ────────────────────────────────────────────────
              TextFormField(
                controller: _phone2Ctrl, // ✅
                enabled: !isProcessing,
                style: TextStyle(color: c.textPrimary),
                decoration: _decoration(c, 'Phone 2 (optional)'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // ── Email ──────────────────────────────────────────────────
              TextFormField(
                controller: _emailCtrl,
                enabled: !isProcessing,
                style: TextStyle(color: c.textPrimary),
                decoration: _decoration(c, 'Email (optional)'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // ── Address ────────────────────────────────────────────────
              TextFormField(
                controller: _addressCtrl,
                enabled: !isProcessing,
                style: TextStyle(color: c.textPrimary),
                decoration: _decoration(c, 'Address (optional)'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
