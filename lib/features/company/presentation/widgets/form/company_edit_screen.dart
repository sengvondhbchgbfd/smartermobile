import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/company/domain/usecases/update_company_usecase.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/entities/company_entity.dart';
import '../../providers/company_provider.dart';

class CompanyEditScreen extends ConsumerStatefulWidget {
  final CompanyEntity company;
  const CompanyEditScreen({super.key, required this.company});

  @override
  ConsumerState<CompanyEditScreen> createState() => _CompanyEditScreenState();
}

class _CompanyEditScreenState extends ConsumerState<CompanyEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _tzCtrl;
  late final TextEditingController _currCtrl;
  File? _pendingLogo;
  File? _pendingBanner;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.company.companyName);
    _emailCtrl = TextEditingController(text: widget.company.email ?? '');
    _phoneCtrl = TextEditingController(text: widget.company.phone ?? '');
    _addressCtrl = TextEditingController(text: widget.company.address ?? '');
    _tzCtrl = TextEditingController(text: widget.company.timezone ?? '');
    _currCtrl = TextEditingController(text: widget.company.currency ?? '');
    for (final c in [
      _nameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _addressCtrl,
      _tzCtrl,
      _currCtrl,
    ]) {
      c.addListener(_markChanged);
    }
  }

  void _markChanged() => setState(() => _hasChanges = true);

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _addressCtrl,
      _tzCtrl,
      _currCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage({required bool isLogo}) async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() {
      if (isLogo) {
        _pendingLogo = File(picked.path);
      } else {
        _pendingBanner = File(picked.path);
      }
      _hasChanges = true;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(companyProvider.notifier);

    if (_pendingLogo != null) {
      final ok = await notifier.uploadLogo(
        companyId: widget.company.id,
        filePath: _pendingLogo!.path,
        isLogo: true,
        oldLogoPublicId: widget.company.logoPublicId,
      );
      if (!ok) {
        _showError(
          ref.read(companyProvider).valueOrNull?.error ??
              'Failed to upload logo',
        );
        return;
      }
    }
    if (_pendingBanner != null) {
      final ok = await notifier.uploadLogo(
        companyId: widget.company.id,
        filePath: _pendingBanner!.path,
        isLogo: false,
        oldBannerPublicId: widget.company.bannerPublicId,
      );
      if (!ok) {
        _showError(
          ref.read(companyProvider).valueOrNull?.error ??
              'Failed to upload banner',
        );
        return;
      }
    }

    final success = await notifier.updateCompany(
      UpdateCompanyParams(
        companyId: widget.company.id,
        companyName: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        timezone: _tzCtrl.text.trim(),
        currency: _currCtrl.text.trim(),
      ),
    );

    if (!mounted) return;

    if (success) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Company updated successfully'),
            ],
          ),
          backgroundColor: Pallets.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } else {
      _showError(
        ref.read(companyProvider).valueOrNull?.error ??
            'Failed to update company',
      );
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Pallets.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<bool> _confirmDiscard() async {
    if (!_hasChanges) return true;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final discard = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? Pallets.surfaceCard : Pallets.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Discard changes?',
          style: TextStyle(
            color: isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'You have unsaved changes. Leave anyway?',
          style: TextStyle(
            color: isDark
                ? Pallets.textSecondaryDark
                : Pallets.textSecondaryLight,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark
                    ? Pallets.textSecondaryDark
                    : Pallets.textSecondaryLight,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Pallets.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text('Discard', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUpdating =
        ref.watch(companyProvider).valueOrNull?.isUpdating ?? false;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surf = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final fill = isDark ? Pallets.surfaceElevated : Pallets.backgroundLight;
    final t2 = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;

    return PopScope(
      canPop: !_hasChanges,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (await _confirmDiscard() && mounted) context.pop();
      },
      child: Scaffold(
        backgroundColor: bg,
        body: CustomScrollView(
          slivers: [
            // ── SliverAppBar ─────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 230,
              pinned: true,
              backgroundColor: surf,
              automaticallyImplyLeading: false,
              leading: _BackButton(
                isDark: isDark,
                onTap: () async {
                  if (await _confirmDiscard() && context.mounted) context.pop();
                },
              ),
              title: Text(
                'Edit Company',
                style: TextStyle(
                  color: isDark
                      ? Pallets.textPrimaryDark
                      : Pallets.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              actions: [
                if (_hasChanges)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: TextButton(
                      onPressed: isUpdating ? null : _save,
                      style: TextButton.styleFrom(
                        backgroundColor: Pallets.blurple,
                        disabledBackgroundColor: Pallets.blurple.withOpacity(
                          0.4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: isUpdating
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                    ),
                  ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Banner image
                    _pendingBanner != null
                        ? Image.file(_pendingBanner!, fit: BoxFit.cover)
                        : widget.company.bannerUrl != null
                        ? Image.network(
                            widget.company.bannerUrl!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Pallets.purpleStart.withOpacity(0.6),
                                  Pallets.blurple.withOpacity(0.4),
                                ],
                              ),
                            ),
                          ),
                    // Scrim
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.55),
                          ],
                        ),
                      ),
                    ),
                    // Banner edit button
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: () => _pickImage(isLogo: false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.45),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Edit Banner',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Body ─────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Logo picker ──────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Pallets.surfaceCard
                              : Pallets.surfaceLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: border),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => _pickImage(isLogo: true),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Pallets.surfaceElevated
                                          : Pallets.backgroundLight,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: border,
                                        width: 2,
                                      ),
                                      image: _pendingLogo != null
                                          ? DecorationImage(
                                              image: FileImage(_pendingLogo!),
                                              fit: BoxFit.cover,
                                            )
                                          : widget.company.logoUrl != null
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                widget.company.logoUrl!,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child:
                                        (_pendingLogo == null &&
                                            widget.company.logoUrl == null)
                                        ? Icon(
                                            Icons.business_rounded,
                                            color: t2,
                                            size: 28,
                                          )
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Pallets.blurple,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isDark
                                              ? Pallets.backgroundDark
                                              : Pallets.backgroundLight,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                        size: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Company Logo',
                                    style: TextStyle(
                                      color: isDark
                                          ? Pallets.textPrimaryDark
                                          : Pallets.textPrimaryLight,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tap to change logo image',
                                    style: TextStyle(color: t2, fontSize: 12),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Pallets.blurple.withOpacity(0.10),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Pallets.blurple.withOpacity(
                                          0.25,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Change Photo',
                                      style: TextStyle(
                                        color: Pallets.blurple,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Section label ─────────────────────────────
                      _SectionLabel(label: 'Company Details', t2: t2),
                      const SizedBox(height: 12),

                      _Field(
                        controller: _nameCtrl,
                        label: 'Company Name',
                        icon: Icons.business_outlined,
                        isDark: isDark,
                        fill: fill,
                        border: border,
                        validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                      ),
                      _Field(
                        controller: _emailCtrl,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        isDark: isDark,
                        fill: fill,
                        border: border,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _Field(
                        controller: _phoneCtrl,
                        label: 'Phone',
                        icon: Icons.phone_outlined,
                        isDark: isDark,
                        fill: fill,
                        border: border,
                        keyboardType: TextInputType.phone,
                      ),
                      _Field(
                        controller: _addressCtrl,
                        label: 'Address',
                        icon: Icons.location_on_outlined,
                        isDark: isDark,
                        fill: fill,
                        border: border,
                      ),

                      const SizedBox(height: 8),
                      _SectionLabel(label: 'Regional Settings', t2: t2),
                      const SizedBox(height: 12),

                      _Field(
                        controller: _tzCtrl,
                        label: 'Timezone',
                        icon: Icons.public_outlined,
                        hint: 'e.g. Asia/Phnom_Penh',
                        isDark: isDark,
                        fill: fill,
                        border: border,
                      ),
                      _Field(
                        controller: _currCtrl,
                        label: 'Currency',
                        icon: Icons.attach_money_rounded,
                        hint: 'e.g. USD, KHR',
                        isDark: isDark,
                        fill: fill,
                        border: border,
                      ),

                      const SizedBox(height: 16),

                      // ── Save button (bottom) ───────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (_hasChanges && !isUpdating)
                              ? _save
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Pallets.blurple,
                            disabledBackgroundColor: Pallets.blurple
                                .withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: isUpdating
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
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

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  final Color t2;
  const _SectionLabel({required this.label, required this.t2});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: Pallets.blurple,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: t2,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}

// ── Back button ───────────────────────────────────────────────────────────────
class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDark;
  const _BackButton({required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDark ? Pallets.surfaceCard : Pallets.surfaceLight,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: isDark ? Pallets.borderDark : Pallets.borderLight,
            ),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight,
            size: 16,
          ),
        ),
      ),
    );
  }
}

// ── Field ─────────────────────────────────────────────────────────────────────
class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isDark;
  final Color fill;
  final Color border;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    required this.isDark,
    required this.fill,
    required this.border,
    this.hint,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final t1 = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
    final t2 = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(color: t1, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: t2, size: 19),
          labelStyle: TextStyle(color: t2, fontSize: 13),
          hintStyle: TextStyle(color: t2.withOpacity(0.5), fontSize: 13),
          filled: true,
          fillColor: fill,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Pallets.blurple, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Pallets.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Pallets.error, width: 1.5),
          ),
        ),
      ),
    );
  }
}
