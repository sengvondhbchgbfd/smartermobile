import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/customer_entity.dart';

class CustomerCreatePage extends StatefulWidget {
  final CustomerEntity? existing;
  const CustomerCreatePage({this.existing, super.key});

  @override
  State<CustomerCreatePage> createState() => _CustomerCreatePageState();
}

class _CustomerCreatePageState extends State<CustomerCreatePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  File? _avatar;
  bool _removeAvatar = false;
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name);
    _phoneCtrl = TextEditingController(text: widget.existing?.phone);
    _emailCtrl = TextEditingController(text: widget.existing?.email);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _avatar = File(picked.path);
        _removeAvatar = false;
      });
    }
  }

  void _clearAvatar() {
    setState(() {
      _avatar = null;
      _removeAvatar = true;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    Navigator.of(context).pop({
      'name': _nameCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      'email': _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      'avatar': _avatar,
      'removeAvatar': _removeAvatar,
    });
  }

  bool get _hasAvatar =>
      _avatar != null || (widget.existing?.avatarUrl != null && !_removeAvatar);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5F5F4);
    final cardBg = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE0DED8);
    final textSecondary = isDark
        ? const Color(0xFFA0A0A5)
        : const Color(0xFF6B6B6B);
    const accent = Color(0xFF3B82F6);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFEFEFED),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
          ),
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
        ),
        title: Text(
          _isEdit ? 'Edit customer' : 'New customer',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton(
              onPressed: _saving ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                disabledBackgroundColor: accent.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save', style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(height: 0.5, thickness: 0.5, color: borderColor),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            // ── Avatar ──────────────────────────────────────────────────────
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _pickAvatar,
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? const Color(0xFF3A3A3C)
                            : const Color(0xFFEFEFED),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: _avatar != null
                          ? ClipOval(
                              child: Image.file(_avatar!, fit: BoxFit.cover),
                            )
                          : (widget.existing?.avatarUrl != null &&
                                !_removeAvatar)
                          ? ClipOval(
                              child: Image.network(
                                widget.existing!.avatarUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.person_outline_rounded,
                              size: 36,
                              color: textSecondary,
                            ),
                    ),
                  ),
                  // Camera badge
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: _pickAvatar,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                          border: Border.all(color: bg, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Remove badge — only shown when avatar exists
                  if (_hasAvatar)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: _clearAvatar,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE24B4A),
                            shape: BoxShape.circle,
                            border: Border.all(color: bg, width: 2),
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                _hasAvatar ? 'Tap to change photo' : 'Tap to add photo',
                style: TextStyle(fontSize: 13, color: textSecondary),
              ),
            ),
            const SizedBox(height: 28),

            // ── Basic info ───────────────────────────────────────────────────
            Text(
              'BASIC INFO',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: textSecondary,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 10),
            _FieldCard(
              borderColor: borderColor,
              cardBg: cardBg,
              fields: [
                _FieldItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Full name',
                  required: true,
                  controller: _nameCtrl,
                  placeholder: 'e.g. Sokha Chan',
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                  textSecondary: textSecondary,
                  borderColor: borderColor,
                ),
                _FieldItem(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  controller: _phoneCtrl,
                  placeholder: 'Optional',
                  keyboardType: TextInputType.phone,
                  textSecondary: textSecondary,
                  borderColor: borderColor,
                  isLast: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _FieldCard(
              borderColor: borderColor,
              cardBg: cardBg,
              fields: [
                _FieldItem(
                  icon: Icons.mail_outline_rounded,
                  label: 'Email',
                  controller: _emailCtrl,
                  placeholder: 'Optional',
                  keyboardType: TextInputType.emailAddress,
                  textSecondary: textSecondary,
                  borderColor: borderColor,
                  isLast: true,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Fields marked * are required.',
              style: TextStyle(fontSize: 12, color: textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Field card container ──────────────────────────────────────────────────────

class _FieldCard extends StatelessWidget {
  final Color borderColor;
  final Color cardBg;
  final List<_FieldItem> fields;

  const _FieldCard({
    required this.borderColor,
    required this.cardBg,
    required this.fields,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Column(children: fields),
    );
  }
}

// ── Single field row ──────────────────────────────────────────────────────────

class _FieldItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool required;
  final TextEditingController controller;
  final String placeholder;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Color textSecondary;
  final Color borderColor;
  final bool isLast;

  const _FieldItem({
    required this.icon,
    required this.label,
    this.required = false,
    required this.controller,
    required this.placeholder,
    this.keyboardType,
    this.validator,
    required this.textSecondary,
    required this.borderColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: textSecondary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          label,
                          style: TextStyle(fontSize: 12, color: textSecondary),
                        ),
                        if (required)
                          const Text(
                            ' *',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFE24B4A),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    TextFormField(
                      controller: controller,
                      keyboardType: keyboardType,
                      validator: validator,
                      style: const TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        hintText: placeholder,
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: textSecondary.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 0.5, thickness: 0.5, color: borderColor),
      ],
    );
  }
}
